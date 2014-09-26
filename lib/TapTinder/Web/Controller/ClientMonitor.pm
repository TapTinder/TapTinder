package TapTinder::Web::Controller::ClientMonitor;

# ABSTRACT: TapTinder::Web clientmonitor controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;


=head1 DESCRIPTION

Catalyst controller for TapTinder client state monitoring.

=method index

Base index method.

=cut

sub index : Path Args(0) {
    my ( $self, $c, $params, @args ) = @_;

    my $pr = $self->get_page_params( $params );

    my $date_from = DateTime->now( time_zone => 'GMT' );
    my $second_back = 1.5*60*60 + ( $date_from->second );
    if ( 0 && $c->log->is_debug  ) {
        $second_back = 7*24*60*60 + ( $date_from->second );
    }
    $date_from->add(
        # 1.5 hours old and caching each minute.
        seconds => -$second_back,
    );
    my $date_from_str = $date_from->ymd . ' ' . $date_from->hms;
    #$self->dumper( $c, $date_from_str );

    my $cols = [ qw/ 
        machine_id machine_name
        cpuarch osname archname 
        msession_id client_rev msession_start_time 
        last_finished_msjobp_cmd_id
        msproc_id msproc_start_time
        max_mslog_id 
        max_msproc_log_id
        last_finished_msjobp_cmd_id
        msproc_log_id msproc_log_change_time msproc_status_name
        mslog_id mslog_change_time mslog_status_name
        last_cmd_name last_cmd_end_time
        last_cmd_rcommit_id last_cmd_rcommit_sha
        last_cmd_author last_cmd_project_name
    / ];

    my $sql = "
        from (
            select xm.*,
                   mspl.msproc_log_id,
                   mspl.change_time as msproc_log_change_time,
                   msps.name as msproc_status_name,
                   msl.mslog_id,
                   msl.change_time as mslog_change_time,
                   mss.name as mslog_status_name,
                   c.name as last_cmd_name,
                   mjpc.end_time as last_cmd_end_time,
                   rc.rcommit_id as last_cmd_rcommit_id,
                   s.sha as last_cmd_rcommit_sha,
                   ra.rep_login as last_cmd_author,
                   project.name as last_cmd_project_name
              from (
                select ma.machine_id,
                       ma.name as machine_name,
                       ma.cpuarch,
                       ma.osname,
                       ma.archname,
                       ms.msession_id,
                       ms.client_rev,
                       ms.start_time as msession_start_time,
                       msp.msproc_id,
                       msp.start_time as msproc_start_time,
                       ( select max(i_ml.mslog_id)
                           from mslog i_ml
                          where i_ml.msession_id = ms.msession_id
                       ) as max_mslog_id,
                       ( select max(i_mpl.msproc_log_id)
                           from msproc_log i_mpl
                          where i_mpl.msproc_id = msp.msproc_id
                       ) as max_msproc_log_id,
                       ( select max(msjpc.msjobp_cmd_id)
                           from msjob msj,
                                msjobp msjp,
                                msjobp_cmd msjpc
                          where msp.msession_id = ms.msession_id
                            and msj.msproc_id = msp.msproc_id
                            and msjp.msjob_id = msj.msjob_id
                            and msjpc.msjobp_id = msjp.msjobp_id
                       ) as last_finished_msjobp_cmd_id
                  from msproc msp,
                       msession ms,
                       machine ma
                 where ma.machine_id = ms.machine_id
                   and ms.end_time is null
                   and ms.abort_reason_id is null
              ) xm,
              mslog msl,
              msstatus mss,
              msproc_log mspl,
              msproc_status msps,
              msjobp_cmd mjpc,
              msjobp mjp,
              jobp_cmd jpc,
              jobp jp,
              cmd c,
              rcommit rc,
              sha s,
              rauthor ra,
              rep,
              project
            where msl.mslog_id = xm.max_mslog_id
              and mss.msstatus_id = msl.msstatus_id
              and mspl.msproc_log_id = xm.max_msproc_log_id
              and mspl.change_time > ?
              and msps.msproc_status_id = mspl.msproc_status_id
              and mjpc.msjobp_cmd_id = last_finished_msjobp_cmd_id
              and mjp.msjobp_id = mjpc.msjobp_id
              and jpc.jobp_cmd_id = mjpc.jobp_cmd_id
              and jp.jobp_id = jpc.jobp_id
              and c.cmd_id = jpc.cmd_id
              and rc.rcommit_id = mjp.rcommit_id
              and s.sha_id = rc.sha_id
              and ra.rauthor_id = rc.author_id
              and rep.rep_id = rc.rep_id
              and rep.project_id = jp.project_id
              and project.project_id = rep.project_id
            order by xm.machine_id, xm.msession_start_time, xm.msproc_start_time
            limit 100
        ) a_f
    "; # end sql

    my $ba = [ $date_from_str ];
    my $all_rows = $self->edbi_selectall_arrayref_slice( $c, $cols, $sql, $ba );
    $self->dumper( $c, $all_rows );

    $c->stash->{states} = $all_rows;
}



=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
