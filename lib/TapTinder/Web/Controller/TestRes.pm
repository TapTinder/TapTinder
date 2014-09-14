package TapTinder::Web::Controller::TestRes;

# ABSTRACT: TapTinder::Web test results controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;

use TapTinder::Web::Project;

=head1 DESCRIPTION

Catalyst controller for TapTinder::Web to show test results and to allow comparing them.

=cut

sub action_do {
    my ( $self, $c ) = @_;

    $self->dumper( $c, $c->request->params );
    my @selected_trun_ids = grep { defined $_; } map { $_ =~ /^trun-(\d+)/; $1; } keys %{$c->request->params};
    #$self->dumper( $c, \@selected_trun_ids );
    unless ( scalar @selected_trun_ids ) {
        $c->stash->{error} = "Please select some test results. One to show failing tests. More to show diff.";
        #$c->response->redirect( ); # TODO
        return;
    }

    if ( scalar(@selected_trun_ids) == 1 ) {
        return $self->action_do_one( $c, $selected_trun_ids[0] );
    }
    return $self->action_do_many( $c, \@selected_trun_ids );
}


sub get_trun_infos {
    my ( $self, $c, $ra_trun_ids ) = @_;

    my $rs_trun_info = $c->model('WebDB::trun')->search(
        {
            trun_id => $ra_trun_ids,
        },
        {
            join => {
                'msjobp_cmd_id' => [
                    'status_id',
                    { msjobp_id => [
                        'jobp_id',
                        { 'rev_id' => 'author_id' },
                        { msjob_id => [
                            { msession_id => { 'machine_id' => 'user_id', }, },
                            'job_id',
                        ], },
                    ], },
                    { 'jobp_cmd_id' => 'cmd_id' },
                ],
            },
            '+select' => [qw/
                rev_id.rev_id rev_id.rev_num rev_id.date rev_id.msg
                author_id.rlogin
                status_id.name status_id.desc
                cmd_id.name jobp_id.name job_id.name
                machine_id.machine_id machine_id.name machine_id.osname machine_id.cpuarch
                user_id.first_name user_id.last_name user_id.login
                msjobp_cmd_id.outdata_id msjobp_cmd_id.output_id
            /],
            '+as' => [qw/
                rev_id rev_num rev_date rev_msg
                rev_author_rlogin
                mjpc_status mjpc_status_desc
                jobp_cmd_name jobp_name job_name
                machine_id machine_name machine_osname machine_cpuarch
                user_first_name user_last_name user_login
                outdata_id output_id
            /],
            order_by => 'rev_id.rev_num',
        }
    );
    my @trun_infos = ();
    while (my $trun_info = $rs_trun_info->next) {
        my %row = ( $trun_info->get_columns() );
        push @trun_infos, \%row;
    }
    #$self->dumper( $c, \@trun_infos );
    return @trun_infos;
}


sub get_ttest_rs {
    my ( $self, $c, $ra_trun_ids ) = @_;

    my $rs = $c->model('WebDB::ttest')->search(
        {
            'me.trun_id' => $ra_trun_ids,
        },
        {
            join => [
                { rtest_id => 'rfile_id', },
            ],
            '+select' => [qw/
                rtest_id.rfile_id
                rtest_id.number
                rtest_id.name

                rfile_id.rpath_id
                rfile_id.sub_path
                rfile_id.rev_num_from
                rfile_id.rev_num_to
            /],
            '+as' => [qw/
                rfile_id
                test_number
                test_name

                rpath_id
                sub_path
                rev_num_from
                rev_num_to
            /],
            order_by => [ 'rfile_id.sub_path', 'me.rtest_id' ],
        }
    );
    return $rs;
}


sub get_trest_infos {
    my ( $self, $c ) = @_;

    #$self->dumper( $c, $c->model('WebDB::build') );
    my $rs_trest_info = $c->model('WebDB::trest')->search;
    my %trest_infos = ();
    while (my $trest_info = $rs_trest_info->next) {
        my %row = ( $trest_info->get_columns() );
        $trest_infos{ $trest_info->trest_id } = \%row;
    }
    #$self->dumper( $c, \%trest_infos );
    return %trest_infos;
}


sub action_do_one {
    my ( $self, $c, $trun_id ) = @_;

    my $ra_selected_trun_ids = [ $trun_id ];
    my @trun_infos = $self->get_trun_infos( $c, $ra_selected_trun_ids ) ;
    #$c->stash->{trun_infos} = \@trun_infos;

    my $rs = $self->get_ttest_rs( $c, $ra_selected_trun_ids ) ;
    my @ress = ();
    while (my $res_info = $rs->next) {
        my %row = ( $res_info->get_columns() );

        my $to_base_report = 0;
        my $trest_id = $row{trest_id};
        # 1 not seen, 2 failed, 5 bonus
        $to_base_report = 1 if $trest_id == 1 || $trest_id == 2 || $trest_id == 5;
        next unless $to_base_report;

        my %res = (
            $row{trun_id} => $trest_id,
        );

        delete $row{trest_id};
        delete $row{trun_id};
        push @ress, {
            file => { %row },
            results => { %res },
        };
    }

    $self->dumper( $c, \@ress );
    $c->stash->{ress} = \@ress;

    my %trest_infos = $self->get_trest_infos( $c ) ;
    $c->stash->{trest_infos} = \%trest_infos;

    $c->stash->{template} = 'testres/diff.tt2';
    return;
}


sub action_do_many {
    my ( $self, $c, $ra_selected_trun_ids ) = @_;

    my @trun_infos = $self->get_trun_infos( $c, $ra_selected_trun_ids ) ;
    $c->stash->{trun_infos} = \@trun_infos;

    # Get all ttest and related rtest and rfile info from database.
    # Ok results aren't saved.
    my $rs = $self->get_ttest_rs( $c, $ra_selected_trun_ids ) ;

    my @ress = ();
    my $prev_rt_id = 0;
    my %res_cache = ();
    my %res_ids_sum = ();
    my $num_of_res = scalar @$ra_selected_trun_ids;
    my %row;
    my %prev_row = ();
    my $same_rpath_id = 1;
    # $rs is ordered by ttest.rtest_id


    # We need $prev_row, $row and info if next row will be defined.
    my $res = undef;
    my $res_next = $rs->next;
    my $num = 1;
    TTEST_NEXT: while ( 1 ) {
        # First run of while loop.
        unless ( defined $res ) {
            # Nothing found.
            last TTEST_NEXT unless defined $res_next;
        }

        # Use previous rs to get row.
        $res = $res_next;
        #$self->dumper( $c, $res );
        $res_next = $rs->next;

        if ( defined $res ) {
            %row = ( $res->get_columns() );
            $same_rpath_id = 0 if %prev_row && $row{rpath_id} != $prev_row{rpath_id};
        }


        # Another one rtest. Find if results for truns are same.
        if ( (not defined $res) || $prev_rt_id != $row{rtest_id} ) {
            my $are_same = 1;
            if ( $prev_rt_id ) {
                $are_same = 0 if scalar( keys %res_ids_sum ) > 1;
                if ( $are_same ) {
                    TTEST_SAME: while (  my ( $k, $v ) = each(%res_ids_sum) ) {
                        if ( $num_of_res != $v ) {
                            $are_same = 0;
                            last TTEST_SAME;
                        }
                    }
                }
            }

            # Remember not different results.
            unless ( $are_same ) {
                #$self->dumper( $c, \%res_ids_sum );
                #$self->dumper( $c, \%res_cache );
                delete $prev_row{trest_id};
                delete $prev_row{trun_id};
                #$self->dumper( $c, \%prev_row );
                #$self->dumper( $c, \@trun_infos );

                my $to_base_report = 0;
                foreach my $trun_info ( @trun_infos ) {
                    if ( exists $res_cache{ $trun_info->{trun_id} } ) {
                        my $trest_id = $res_cache{ $trun_info->{trun_id} };
                        # 1 not seen, 2 failed, 5 bonus
                        $to_base_report = 1 if ( $trest_id == 1 || $trest_id == 2 || $trest_id == 5 );
                        next;
                    }
                    if ( $trun_info->{rev_num} >= $prev_row{rev_num_from}
                         && ( !$prev_row{rev_num_to} || $trun_info->{rev_num} <= $prev_row{rev_num_to} )
                       )
                    {
                        $res_cache{ $trun_info->{trun_id} } = 6; # ok

                    } else {
                        $to_base_report = 1;
                    }
                    #my $trun_
                }

                if ( $to_base_report ) {
                    #$self->dumper( $c, \%res_cache );
                    push @ress, {
                        file => { %prev_row },
                        results => { %res_cache },
                    };
                }
            }

            last TTEST_NEXT unless defined $res;

            %prev_row = %row;
            $prev_rt_id = $row{rtest_id};
            %res_cache = ();
            %res_ids_sum = ();
        }


        # another test
        $res_cache{ $row{trun_id} } = $row{trest_id};
        $res_ids_sum{ $row{trest_id} }++;
        $num++;

    } # TTEST_NEXT: while ( 1 ) {

    $self->dumper( $c, \@trun_infos );
    $self->dumper( $c, \@ress );
    $c->stash->{same_rpath_id} = $same_rpath_id;
    $c->stash->{ress} = \@ress;

    my %trest_infos = $self->get_trest_infos( $c ) ;
    $c->stash->{trest_infos} = \%trest_infos;

    $c->stash->{template} = 'report/diff.tt2';
    return;
}

=head2 index



=cut


sub compare :  PathPart('tr/compare') Chained('/') Args(0) {
    my ( $self, $c, @args ) = @_;

	die 'do';
    
}


sub list_pr_setup :  PathPart('tr/list') Chained('/') CaptureArgs(2) {
	shift->process_project_ref_args( @_ );
}


sub list_pr :  PathPart('') Chained('list_pr_setup') Args(0) {
    my ( $self, $c ) = @_;

    my $rref_id = $c->stash->{prref_info}{rref_id};

    $c->stash->{template} = 'testres/index.tt2';

    my @rcommits = TapTinder::Web::Project::get_rcommits( $self, $c, $rref_id, {rows=>10} );
    return 1 unless scalar @rcommits;

    $self->dumper( $c, \@rcommits );
    $c->stash->{rcommits} = \@rcommits;

    my $trun_search = {
        join => [
            { msjobp_cmd_id => [
                { msjobp_id => [
                    'jobp_id', { msjob_id => { msproc_id => { msession_id => 'machine_id', } } },
                ] },
            ], },
        ],
        'select' => [qw/
            machine_id.machine_id
            machine_id.name
            machine_id.cpuarch
            machine_id.osname
            machine_id.archname

            me.trun_id
            me.msjobp_cmd_id
            me.parse_errors
            me.not_seen
            me.failed
            me.todo
            me.skip
            me.bonus
            me.ok
            
            msjobp_id.rcommit_id
        /],
        'as' => [qw/
            machine_id
            machine_name
            cpuarch
            osname
            archname

            trun_id
            msjobp_cmd_id
            parse_errors
            not_seen
            failed
            todo
            skip
            bonus
            ok
            
            rcommit_id
        /],
        order_by => 'machine_id',

    };

    my $trun_rs = $c->model('WebDB::trun')->search(
        {
            'me.trun_status_id' => 2, # ok - archive parsed and loaded to DB
            'msjobp_id.rcommit_id' => [ map { $_->{rcommit_id} } @rcommits ],
        },
        $trun_search
    );
    
    my $builds = {};
    while (my $trun = $trun_rs->next) {
        my %trun_rows = ( $trun->get_columns() );    
        #$self->dumper( $c, \%trun_rows );
        push @{$builds->{ $trun_rows{rcommit_id} }}, \%trun_rows;
    }

    $self->dumper( $c, $builds );
    $c->stash->{builds} = $builds;
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=head1 AUTHOR

Michal Jurosz <mj@mj41.cz>

=head1 LICENSE

This file is part of TapTinder. See L<TapTinder> license.

=cut


1;
