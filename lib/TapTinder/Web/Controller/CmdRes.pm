package TapTinder::Web::Controller::CmdRes;

# ABSTRACT: TapTinder::Web cr controller.

use strict;
use warnings;
use base 'TapTinder::Web::ControllerBase';

use File::ReadBackwards;
use HTML::Entities;

=head1 DESCRIPTION

Catalyst controller for TapTinder. Shows detail informations 
about machine session job part command (by msjobp_cmd_id).

=method index

Base index method.

=cut

sub index : PathPart('cr') Chained('/') Args(1) {
    my ( $self, $c, $msjobp_cmd_id ) = @_;

    # Info about this msjobp_cmd_id
    my $cmd_rs = $c->model('WebDB::msjobp_cmd')->search( 
        { 'msjobp_cmd_id' => $msjobp_cmd_id, },
        {
            prefetch => [
                { 'jobp_cmd_id' => 'cmd_id' },
                {
                    'msjobp_id' => {
                        'msjob_id' => [ 
                            {
                                'msproc_id' => [
                                    'abort_reason_id',
                                    { 
                                        'msession_id' => [
                                            'abort_reason_id',
                                            'machine_id',
                                        ],
                                    },
                                ],
                            },
                            'job_id',
                        ],
                        'rcommit_id' => [ 
                            { 'author_id' => 'user_id' },
                            { 'committer_id' => 'user_id' },
                            'sha_id',
                            { 'rep_id' => 'project_id' },
                        ],
                    },
                },
                'status_id',
                { 'output_id' => 'fspath_id', },
                { 'outdata_id' => 'fspath_id', },
            ],
            'select' => [qw/
                me.msjobp_cmd_id        me.jobp_cmd_id
                me.start_time           me.end_time
                cmd_id.name             jobp_cmd_id.params      jobp_cmd_id.rorder
                status_id.name          status_id.descr
                output_id.fsfile_id     output_id.fspath_id     output_id.name
                fspath_id.web_path      fspath_id.path
                outdata_id.fsfile_id    outdata_id.name         fspath_id_2.web_path    
                author_id.rauthor_id    author_id.rep_login     user_id.irc_nick
                committer_id.rauthor_id committer_id.rep_login  user_id_2.irc_nick
                rep_id.rep_id           rep_id.name             rep_id.github_url
                project_id.project_id   project_id.name
                project_id.url          project_id.descr
                msjobp_id.start_time    msjobp_id.end_time      
                msjob_id.msjob_id       msjob_id.start_time     msjob_id.end_time
                msproc_id.start_time    msproc_id.end_time      
                abort_reason_id.name    abort_reason_id.descr
                rcommit_id.rcommit_id   rcommit_id.msg          rcommit_id.sha_id
                sha_id.sha              rcommit_id.author_time  rcommit_id.committer_time
                machine_id.machine_id   machine_id.name         machine_id.descr
                machine_id.cpuarch      machine_id.osname       machine_id.archname
                msession_id.msession_id msproc_id.msproc_id
                job_id.job_id           msjobp_id.jobp_id
            /],
            'as' => [qw/ 
                msjobp_cmd_id           jobp_cmd_id
                cmd_start_time          cmd_end_time
                cmd_name                cmd_params              cmd_order
                status_name             status_descr
                output_fsfile_id        output_fspath_id        output_fname
                output_fwpath           output_fspath
                outdata_id              outdata_fname           outdata_fwpath
                author_rauthor_id       author_login            author_irc_nick
                committer_rauthor_id    committer_login         commitrer_irc_nick
                rep_id                  rep_name                rep_github_url
                project_id              project_name            
                project_url             project_descr
                msjobp_start_time       msjobp_end_time
                msjob_id                msjob_start_time        msjob_end_time
                msproc_start_time       msproc_end_time
                msproc_areason_name     msproc_areason_descr
                rcommit_id              rcommit_msg             sha_id
                rcommit_sha             rcommit_author_date     rcommit_committer_date
                machine_id              machine_name            machine_descr
                machine_cpuarch         machine_osname          machine_archname
                msession_id             msproc_id
                job_id                  jobp_id
            /],
        }
    );
    my $cmd_row = $cmd_rs->next;
    my $info = { $cmd_row->get_columns };
    $c->stash->{info} = $info;


    # Info about other parts of msjob (all msjobp, all msjobp_cmd).

    my $log_fpath = $info->{output_fspath} . '/' . $info->{output_fname};
    my $bw_fh = File::ReadBackwards->new( $log_fpath );
    my $log_tail = '';
    if ( $bw_fh ) {
        my $lines_num = 25;
        my $line = undef;
        while ( defined($line = $bw_fh->readline) && $lines_num>0 ) {
            $log_tail = $line . $log_tail;
            $lines_num--;
        }
        if ( defined($line = $bw_fh->readline) ) {
            $log_tail = '...' . "\n" . $log_tail;
        }
    }
    
    my $status_class = 'unk';
    if ( $info->{status_name} eq 'ok' ) {
        $status_class = 'ok';
    } elsif ( $info->{status_name} eq 'error' || $info->{status_name} eq 'killed' ) {
        $status_class = 'err';
    }
    $c->stash->{status_class} = $status_class;
    
    $log_tail = encode_entities( $log_tail );
    $log_tail = '<div class="log_sh log_sh_' . $status_class . '">' . $log_tail . '</div>';
    $log_tail =~ s{(warning)}{\<span class\=\'warn\'>$1\<\/span\>}ig;
    $log_tail =~ s{(error)}{\<span class\=\'err\'>$1\<\/span\>}ig;
    
    $c->stash->{log_tail_html} = $log_tail;


    my $all_cmds_rs = $c->model('WebDB::msjobp_cmd')->search( 
        { 'msjobp_id.msjob_id' => $info->{msjob_id}, },
        {
            prefetch => [
                { 'jobp_cmd_id' => 'cmd_id' },
                {
                    'msjobp_id' => [
                        { 'msjob_id' => 'job_id', },
                        { 'rcommit_id' => [ 
                            'sha_id',
                            { 'rep_id' => 'project_id', },
                        ], },
                        'jobp_id',
                    ],
                },
                'status_id',
            ],
            'order_by' => [qw/ jobp_id.rorder jobp_cmd_id.rorder /],
            'select' => [qw/
                me.msjobp_cmd_id
                cmd_id.name             cmd_id.descr
                jobp_cmd_id.params      jobp_cmd_id.rorder      
                status_id.name          status_id.descr
                rep_id.name             rep_id.github_url
                project_id.project_id   project_id.name
                project_id.url          project_id.descr
                rcommit_id.msg
                sha_id.sha              rcommit_id.author_time  rcommit_id.committer_time
            /],
            'as' => [qw/ 
                msjobp_cmd_id
                cmd_name                cmd_descr
                cmd_params              cmd_rorder              
                status_name             status_descr
                rep_name                rep_github_url
                project_id              project_name            
                project_url             project_descr
                rcommit_msg
                rcommit_sha             rcommit_author_date     rcommit_committer_date
            /],
        }
    );
    
    my @cmds = ();
    while ( my $row_obj = $all_cmds_rs->next ) {
        push @cmds, { $row_obj->get_columns() };
    }
    $c->stash->{cmds} = \@cmds;

    #$self->dumper( $c, \@cmds );
    #$self->dumper( $c, $info );
   
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
