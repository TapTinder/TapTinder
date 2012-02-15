package TapTinder::Web::Controller::BuildStatus;

# ABSTRACT: TapTinder::Web buildstat controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;

use TapTinder::Web::Project;

=head1 DESCRIPTION

Catalyst controller for TapTinder. Shows build status.

=method index

Base index method.

=cut

sub index : Path  {
    my ( $self, $c, $p_project_name, $p_ref_name, $p_jobp_id, @args  ) = @_;

    my ( $project_name, $ref_name ) = $self->process_projec_ref_url( $c, $p_project_name, $p_ref_name );
    my $prref_info = TapTinder::Web::Project::get_project_ref_info( $self, $c, $project_name, $ref_name );
    my $rref_id = $prref_info->{rref_id};

    my $jobp_id = $p_jobp_id;
    unless ( $jobp_id ) {
        my $search_wui_build = {
            'project_id' => $prref_info->{project_id},
        };
        my $wui_build_rs = $c->model('WebDB::wui_build')->search( $search_wui_build, {} );
        my $jobp_row = $wui_build_rs->next;
        return 0 unless $jobp_row;
        $jobp_id = $jobp_row->get_column('jobp_id');
    }

    my $cmd_id = 5;
    if ( $args[0] ) {
        ( $cmd_id ) = $args[0] =~ /^c\-(\d+)$/;
    }

    my @rcommits = TapTinder::Web::Project::get_rcommits( $self, $c, $rref_id );
    return 1 unless scalar @rcommits;


    my $commit_time_from = $rcommits[-1]->{date};
    my $commit_time_to = $rcommits[0]->{date};
    $self->dadd( $c, "Commit time from $commit_time_from to $commit_time_to.\n" );

    my $cols = [ qw/
        machine_id
        rcommit_id
        status_id
        status_name
        msjobp_cmd_id
    / ];

    my $sql = "
    from (
       select ms.machine_id,
              rc.rcommit_id,
              mjpc.status_id,
              cs.name as status_name,
              mjpc.msjobp_cmd_id
         from rref_rcommit rrc,
              rcommit rc,
              jobp jp,
              jobp_cmd jpc,
              msjobp mjp,
              msjobp_cmd mjpc,
              cmd_status cs,
              msjob mj,
              msproc msp,
              msession ms
        where rrc.rref_id = ?
          and rc.rcommit_id = rrc.rcommit_id
          and rc.committer_time >= str_to_date(?,'%Y-%m-%d %H:%i:%s')
          and rc.committer_time <= str_to_date(?,'%Y-%m-%d %H:%i:%s')
          and jp.jobp_id = ? -- only this job
          and jpc.jobp_id = jp.jobp_id
          and jpc.cmd_id = ? -- only this cmd
          and mjp.rcommit_id = rc.rcommit_id
          and mjp.jobp_id = jp.jobp_id
          and mjpc.jobp_cmd_id = jpc.jobp_cmd_id
          and mjpc.msjobp_id = mjp.msjobp_id
          and cs.cmd_status_id = mjpc.status_id
          and mj.msjob_id = mjp.msjobp_id
          and msp.msproc_id = mj.msproc_id
          and ms.msession_id = msp.msession_id
    ) a_f
   "; # end sql

    $self->dadd( $c, "jobp_id: $jobp_id\n" );
    my $ba = [
        $rref_id,
        $commit_time_from,
        $commit_time_to,
        $jobp_id, # jp.jobp_id
        $cmd_id, # jpc.cmd_id
    ];
    my $all_rows = $self->edbi_selectall_arrayref_slice( $c, $cols, $sql, $ba );
    #$self->dumper( $c, $all_rows );

    my %ress = ();
    my %machines = ();
    foreach my $row ( @$all_rows ) {
        my $machine_id = $row->{machine_id};
        $ress{ $row->{rcommit_id} }->{ $machine_id } = $row;
        $machines{ $machine_id }++;
    }

    $c->stash->{rcommits} = \@rcommits;
    $c->stash->{ress} = \%ress;
    $c->stash->{machines} = \%machines;


    if ( 1 ) {
        $self->dumper( $c, \%machines );
        $self->dumper( $c, \@rcommits );
        #$self->dumper( $c, $rev_num_from );
        $self->dumper( $c, \%ress );
    }

}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
