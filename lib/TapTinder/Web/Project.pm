package TapTinder::Web::Project;

# ABSTRACT: TapTinder::Web::Project class for DB project cluster.

use strict;
use warnings;


=head1 DESCRIPTION

Class for methods related to 'Project' database schema cluster.

=method get_project_ref_info

Load info for project name and ref name.

=cut

sub get_project_ref_info {
    my ( $self, $c, $project_name, $ref_name ) = @_;

    my $search = {
        'me.name' => $ref_name,
        'me.active' => 1,
        'rep_id.active' => 1,
        'project_id.name' => $project_name,
    };
    #$self->dumper( $c, { project_name => $project_name, ref_name => $ref_name } );
    my $prref_rs = $c->model('WebDB::rref')->search( $search,
        {
            join => { 'rcommit_id' => { 'rep_id' => 'project_id', }, },
            'select' => [qw/ me.rref_id me.name   rcommit_id.rcommit_id rep_id.rep_id rep_id.github_url project_id.project_id project_id.name project_id.url /],
            'as' =>     [qw/ rref_id    rref_name rcommit_id            rep_id        github_url        project_id            project_name    project_url    /],
        }
    );
    my $prref_row = $prref_rs->next;
    die "Can't find any commit for project '$project_name' and branch '$ref_name'." unless $prref_row;

    my $prref_info = { $prref_row->get_columns };
    $c->stash->{prref_info} = $prref_info;
    #$self->dumper( $c, $prref_info );

    return $prref_info;
}

=method get_rcommits_rs

Return RecordSet to rcommits info for provided rref_id.

=cut

sub get_rcommits_rs {
    my ( $self, $c, $rref_id ) = @_;

    #$self->dadd( $c, "get_rcommits_rs for rref_id: $rref_id\n" );

    my $rs_rcommits = $c->model('WebDB::rref_rcommit')->search( {
        'me.rref_id' => $rref_id,
    }, {
        select => [ qw/
            me.rcommit_id rcommit_id.committer_time rcommit_id.msg sha_id.sha
            author_id.rauthor_id author_id.rep_login
        / ],
        as => [ qw/
            rcommit_id date msg sha
            rep_author_id rep_login
        / ],
        join => { 'rcommit_id' => [ 'author_id', 'sha_id' ], },
        order_by => [ 'rcommit_id.committer_time DESC' ],
        page => 1,
        rows => 100,
        #offset => 0,
    } );

    return $rs_rcommits;
}

=method get_rcommits

Return rcommits info for provided rref_id.

=cut

sub get_rcommits {
    my $rs_rcommits = get_rcommits_rs( @_ );

    my @rcommits = ();
    while ( my $row_obj = $rs_rcommits->next ) {
        push @rcommits, { $row_obj->get_columns() };
    }
    return @rcommits;
}


1;