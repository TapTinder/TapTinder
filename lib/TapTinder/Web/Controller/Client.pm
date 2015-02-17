package TapTinder::Web::Controller::Client;

# ABSTRACT: TapTinder::Web client controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;

use Digest::MD5 qw(md5);
use DateTime;
use File::Spec;
use File::Copy;

# ToDo - see TapTinder::Client::WebAgent
use constant SUPPORTED_REVISION => 400;


=head1 DESCRIPTION

Catalyst controller for TapTinder client services.

=method get_lock_for_machine_action

Try to obtain lock for $machine_id and $action_name.

=cut

sub get_lock_for_machine_action {
    my ( $self, $c, $machine_id, $action_name ) = @_;
    my $dbh = $c->model('WebDB')->schema->storage->dbh;
    my $db_name = $c->config->{db}->{name};
    my $lock_name = $db_name.'-m'.$machine_id.'-'.$action_name;
    my $ra_row = $dbh->selectrow_arrayref("SELECT GET_LOCK(?,5) as ret_code;", undef, $lock_name );
    return $ra_row->[0];
}


=method release_lock_for_machine_action

Try to release lock for $machine_id and $action_name.

=cut

sub release_lock_for_machine_action {
    my ( $self, $c, $machine_id, $action_name ) = @_;
    my $dbh = $c->model('WebDB')->schema->storage->dbh;
    my $db_name = $c->config->{db}->{name};
    my $lock_name = $db_name.'-m'.$machine_id.'-'.$action_name;
    my $ra_row = $dbh->selectrow_arrayref("SELECT RELEASE_LOCK(?) as ret_code;", undef, $lock_name );
    return $ra_row->[0];
}

=method txn_end_c

Commit or rollback transaction.

=cut

sub txn_end_c {
	my ( $self, $c, $data, $do_commit ) = @_;

	my $ret_val = $self->SUPER::txn_end_c( $c, $do_commit );

	return 1 if $ret_val;

	$data->{err} = 1;
	$data->{err_msg} = "Error: Transaction commit failed.";
	return 0;
}

=method token2md5

Return md5 for token provided.

=cut

sub token2md5 {
	my ( $self, $token ) = @_;
	return substr( md5($token), -8)
}

=method use_reg_token

Use reg_token to register machine.

=cut

sub use_reg_token {
    my ( $self, $c, $data, $client_token, $reg_token ) = @_;

	# ToDO - more configurations
	# * disable open reg (reg_token)
	# * custom reg_token
	# * more than one reg_token
	# * reg_token configurable per user_id (use to fill machine.user_id)
	# * ...
	if ( $reg_token ne 'openTTserver' ) {
		$data->{ag_err} = 1;
		$data->{ag_err_msg} = "Error: Provided reg_token is invalid.";
		return 0;
	}

    my $machine_rs = $c->model('WebDB::machine')->create({
        token => $self->token2md5( $client_token ),
        created  => DateTime->now,
    });
    if ( ! $machine_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Failed to create new machine."; # TODO
        return 0;
    }
    return $machine_rs->get_column('machine_id');


}

=method token2machine_id

Check client_token and log login params - machine_id and password.

=cut

sub token2machine_id {
    my ( $self, $c, $data, $client_token, $reg_token ) = @_;

    my $rs = $c->model('WebDB::machine')->search( {
        token => $self->token2md5( $client_token ),
    } );
    my $row = $rs->next;
    #$self->dumper( $c, { $row->get_columns() } );
    return $row->get_column('machine_id') if $row;

	if ( ! $reg_token ) {
		$data->{ag_err} = 1;
		$data->{ag_err_msg} = "Error: Unknown client_token (and reg_token not provided).";
		return 0;
	}

	return $self->use_reg_token( $c, $data, $client_token, $reg_token );
}


=method msession_ok

Check msession_id param.

=cut

sub msession_ok {
    my ( $self, $c, $data, $machine_id, $msession_id ) = @_;

    my $rs = $c->model('WebDB::msession')->search( {
        msession_id => $msession_id,
    } );
    my $row = $rs->next;
    if ( !$row ) {
        $data->{ag_err} = 101; # special ag_err def
        $data->{ag_err_msg} = "Error: Msession (msession_id=$msession_id) not found.";
        return 0;
    }

    my %cols = $row->get_columns();
    if ( $cols{machine_id} != $machine_id ) {
        $data->{ag_err} = 1;
        $data->{ag_err_msg} = "Error: Msession msession_id=$msession_id is not machine_id=$machine_id session.";
        return 0;
    }

    if ( $cols{abort_reason_id} ) {
        $data->{ag_err} = 1;
        $data->{ag_err_msg} = "Error: Msession msession_id=$msession_id was aborted (abort_reason=$cols{abort_reason_id}).";
        $data->{ag_err_msesion_abort_reason_id} = $cols{abort_reason_id};
        return 0;
    }

    if ( $cols{end_time} ) {
        $data->{ag_err} = 1;
        $data->{ag_err_msg} = "Error: Msession msession_id=$msession_id already ended.";
        return 0;
    }

    return 1;
}


=method access_allowed

Default method for all actions. Do base checks (L<login_ok|login_ok>, L<msession_ok|msession_ok>);

=cut

sub access_allowed {
    my ( $self, $c, $data, $params, $param_msid_checks ) = @_;

    unless ( $params->{ctok} ) {
        $data->{ag_err} = 1;
        $data->{ag_err_msg} = "Error: Parameter ctok (client_token) required.";
        return 0;
    }
    my $client_token = $params->{ctok};
    my $reg_token = $params->{rtok} || '';

    my $machine_id = $self->token2machine_id( $c, $data, $client_token, $reg_token );
    return 0 unless $machine_id;

    if ( $param_msid_checks ) {
		if ( ! $params->{msid} ) {
			$data->{ag_err} = 1;
			$data->{ag_err_msg} = "Error: Parameter msid (msession.msession_id) required.";
			return 0;
		}

		my $msession_id = $params->{msid};
		my $login_ok = $self->msession_ok( $c, $data, $machine_id, $msession_id );
		return 0 unless $login_ok;
	}

    $data->{ag_err} = 0;
    return $machine_id;
}


=method check_param

Method checks mandatory param. Sets error message if value is empty.

=cut

sub check_param {
    my ( $self, $c, $data, $params, $key, $key_desc ) = @_;

    unless ( $params->{$key} ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Parameter $key ($key_desc) required.";
        return 0;
    }
    return 1;
}


=method check_client_rev

Check if client revision is supported by server.

=cut

sub check_client_rev {
    my ( $self, $c, $data, $client_rev ) = @_;

    if ( $client_rev < SUPPORTED_REVISION ) {
        $data->{ag_err} = 102; # special ag_err def
        $data->{ag_err_msg} = "Error: Your client (revision $client_rev) is not supported. Revision >= " . SUPPORTED_REVISION . " required.";
        return 0;
    }
    return 1;
}


=method create_mslog

Create new machine session log (mslog) entry.

=cut

sub create_mslog {
    my (
        $self, $c, $data, $action_name,
        $msession_id, $msstatus_id,
        $attempt_number, $change_time, $estimated_finish_time
    ) = @_;

    my $rs = $c->model('WebDB::mslog')->create({
        msession_id             => $msession_id,
        msstatus_id             => $msstatus_id,
        attempt_number          => $attempt_number,
        change_time             => $change_time,
        estimated_finish_time   => $estimated_finish_time,
    });
    unless ( $rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Create mslog entry failed (action=$action_name)."; # TODO
        return 0;
    }
    return 1;
}


=method cmd_mscreate

Create new machine session (msession).

=cut

sub cmd_mscreate {
    my ( $self, $c, $machine_id, $data, $params ) = @_;

    $self->check_param( $c, $data, $params, 'crev', 'client code revision' ) || return 0;
    my $client_rev = $params->{crev};
    $self->check_client_rev( $c, $data, $client_rev ) || return 0;

    $self->check_param( $c, $data, $params, 'pid', 'client process ID' ) || return 0;
    my $pid = $params->{pid};


    my $msession_rs = $c->model('WebDB::msession')->create({
        machine_id  => $machine_id,
        client_rev  => $client_rev,
        pid         => $pid,
        start_time  => DateTime->now,
    });
    if ( ! $msession_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: xxx"; # TODO
        return 0;
    }
    my $msession_id = $msession_rs->get_column('msession_id');

    # create mslog
    my $ret_code = $self->create_mslog(
        $c, $data, 'mscreate',
        $msession_id,
        2, # $msstatus_id, 2 .. msession just created
        1, # $attempt_number
        DateTime->now, # $change_time
        undef # $estimated_finish_time
    ) || return 0;

    $data->{msid} = $msession_id;
    return 1;
}


=method cmd_msdestroy

Destroy machine session (msession).

=cut

sub cmd_msdestroy {
    my ( $self, $c, $data, $params ) = @_;

    # $params->{msid} - already checked
    my $msession_id = $params->{msid};

    my $abort_reason_id = 5; # iterrupted by user

    my $msession_rs = $c->model('WebDB::msession')->search( {
        msession_id => $msession_id,
    } );

    my $ret_val = $msession_rs->update( {
        end_time => DateTime->now,
        abort_reason_id => $abort_reason_id,
    } );

    unless ( $ret_val ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: cmd_destroy ... (ret_val=$ret_val)."; # TODO
        return 0;
    }

    # TODO
    # * check msjob, ...

    # create mslog
    my $ret_code = $self->create_mslog(
        $c, $data, 'msdestroy',
        $msession_id,
        6, # $msstatus_id, 6 .. stop by user
        1, # $attempt_number
        DateTime->now, # $change_time
        undef # $estimated_finish_time
    ) || return 0;

    return 1;
}


=method create_msproc_log

Create new machine session process log (msproc_log) entry.

=cut

sub create_msproc_log {
    my (
        $self, $c, $data, $action_name,
        $msproc_id, $msproc_status_id,
        $attempt_number, $change_time, $estimated_finish_time
    ) = @_;

    my $rs = $c->model('WebDB::msproc_log')->create({
        msproc_id               => $msproc_id,
        msproc_status_id        => $msproc_status_id,
        attempt_number          => $attempt_number,
        change_time             => $change_time,
        estimated_finish_time   => $estimated_finish_time,
    });
    unless ( $rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Create msproc_log entry failed (action=$action_name)."; # TODO
        return 0;
    }
    return 1;
}


=method cmd_mspcreate

Create new machine session process (msproc).

=cut

sub cmd_mspcreate {
    my ( $self, $c, $data, $params ) = @_;

    # $params->{msid} - already checked
    my $msession_id = $params->{msid};

    $self->check_param( $c, $data, $params, 'pid', 'client process ID' ) || return 0;
    my $pid = $params->{pid};

    my $msproc_rs = $c->model('WebDB::msproc')->create({
        msession_id => $msession_id,
        pid         => $pid,
        start_time  => DateTime->now,
    });
    if ( ! $msproc_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: xxx"; # TODO
        return 0;
    }
    my $msproc_id = $msproc_rs->get_column('msproc_id');

    # create mslog
    my $ret_code = $self->create_msproc_log(
        $c, $data, 'mspcreate',
        $msproc_id,
        2, # $msproc_status_id, 2 .. msproc just created
        1, # $attempt_number
        DateTime->now, # $change_time
        undef # $estimated_finish_time
    ) || return 0;

    $data->{mspid} = $msproc_id;
    return 1;
}


=method get_new_job

Return new job description for client.

=cut

sub get_new_job {
    my ( $self, $c, $data, $machine_id, $msession_id ) = @_;

    my $cols = [ qw/
        wconf_job_id
        rep_id
        rref_id
        job_id
        wcj_priority
        wcr_priority
        jobp_id
    / ];
    my $sql = "
        from (
            select wcj.wconf_job_id,
                   wcj.rep_id,
                   wcj.rref_id,
                   wcj.job_id,
                   wcj.priority as wcj_priority,
                   wcr.priority as wcr_priority,
                   jp.jobp_id
              from wconf_session wcs
              join wconf_job wcj
                on wcj.wconf_session_id = wcs.wconf_session_id
              join jobp jp
                on jp.job_id = wcj.job_id
               and jp.rorder = 1
              join wconf_rref wcr
                on wcr.rref_id = wcj.rref_id
              join rref rr
                on rr.rref_id = wcr.rref_id
              join rcommit rc
                on rc.rcommit_id = rr.rcommit_id
             where wcs.machine_id = ?

             union all

            select wcj.wconf_job_id,
                   wcj.rep_id,
                   wcr.rref_id,
                   wcj.job_id,
                   wcj.priority as wcj_priority,
                   wcr.priority as wcr_priority,
                   jp.jobp_id
              from wconf_session as wcs
              join wconf_job as wcj
                on wcj.wconf_session_id = wcs.wconf_session_id
               and wcj.rref_id is null
              join jobp jp
                on jp.job_id = wcj.job_id
               and jp.rorder = 1
              join rep as r
                on r.rep_id = wcj.rep_id
              join wconf_rref as wcr
              join rref as rr
                on rr.rref_id = wcr.rref_id
              join rcommit as rc
                on rc.rcommit_id = rr.rcommit_id
               and rc.rep_id = r.rep_id
             where wcs.machine_id = ?
        ) al
      order by wcj_priority, wcr_priority
   "; # end sql

    my $ba = [ $machine_id, $machine_id ];
    my $sr_job_data = $self->edbi_selectall_arrayref_slice( $c, $cols, $sql, $ba );
    #print STDERR Data::Dumper::Dumper( $sr_job_data );

    my $job_id = undef;
    my $rc_data = undef;
    my $rref_done_list = {};
    $cols = [
        'rcommit_id',
    ];

    foreach my $row ( @$sr_job_data ) {
        my $rref_id = $row->{rref_id};
        my $rep_id = $row->{rep_id};
        $job_id = $row->{job_id};

        my $done_key = $job_id . '-' . $rep_id;

        if ( $rref_id ) {
            $done_key .= '-' . $rref_id;

            next if exists $rref_done_list->{ $done_key };
            $rref_done_list->{ $done_key } = 1;

            $sql = "
              from (
                select rc.rcommit_id
                  from rref_rcommit rrc
                  join rcommit rc
                    on rc.rcommit_id = rrc.rcommit_id
                  join jobp jp
                    on jp.jobp_id = ?
                 where rrc.rref_id = ?
                   and not exists (
                        select 1
                          from msession ms,
                               msproc msp,
                               msjob msj,
                               msjobp msjp,
                               jobp jp
                         where ms.machine_id = ?
                           and msp.msession_id = ms.msession_id
                           and msj.msproc_id = msp.msproc_id
                           and msj.job_id = ?
                           and msjp.msjob_id = msj.msjob_id
                           and msjp.rcommit_id = rc.rcommit_id
                  )
                  and ( jp.max_age is null or DATE_SUB(CURDATE(), INTERVAL jp.max_age HOUR) <= rc.committer_time )
                order by rc.committer_time desc
                limit 1
              ) al
            ";
            $ba = [ $row->{jobp_id}, $rref_id, $machine_id, $job_id ];

        } else {
            # ToDo - Is this part usefull?
            next;

            # No rref_id given. Doing for all refs.
            next if exists $rref_done_list->{ $done_key };
            $rref_done_list->{ $done_key } = 1;

            $sql = "
              from (
                select rc.rcommit_id
                  from rcommit rc
                  join jobp jp
                    on jp.jobp_id = ?
                 where rc.rep_id = ?
                   and not exists (
                        select 1
                          from msession ms,
                               msproc msp,
                               msjob msj,
                               msjobp msjp,
                               jobp jp
                         where ms.machine_id = ?
                           and msp.msession_id = ms.msession_id
                           and msj.msproc_id = msp.msproc_id
                           and msj.job_id = ?
                           and msjp.msjob_id = msj.msjob_id
                           and msjp.rcommit_id = rc.rcommit_id
                  )
                  and ( jp.max_age is null or DATE_SUB(CURDATE(), INTERVAL jp.max_age HOUR) <= rc.committer_time )
                order by rc.committer_time desc
                limit 1
              ) al
            ";
            $ba = [ $row->{jobp_id}, $rep_id, $machine_id, $job_id ];
        }

        $rc_data = $self->edbi_selectall_arrayref_slice( $c, $cols, $sql, $ba );
        if ( scalar @$rc_data ) {
            print STDERR Data::Dumper::Dumper( $rc_data );
            last;
        }
    }

    return undef unless defined $rc_data;
    return undef unless scalar @$rc_data;
    return {
        'rcommit_id' => $rc_data->[0]->{rcommit_id},
        'job_id' => $job_id,
    };
}


=method create_msjob

Insert new row to msjob table.

=cut

sub create_msjob {
    my ( $self, $c, $data, $msproc_id, $job_id ) = @_;

    my $new_rs = $c->model('WebDB::msjob')->create({
        msproc_id   => $msproc_id,
        job_id      => $job_id,
        start_time  => DateTime->now,
        end_time    => undef,
        pid         => undef,
    });
    if ( ! $new_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: xxx"; # TODO
        return undef;
    }
    my $msjob_id = $new_rs->get_column('msjob_id');
    return $msjob_id;
}


=method create_msjobp

Insert new row to msjobp table.

=cut

sub create_msjobp {
    my ( $self, $c, $data, $msjob_id, $jobp_id, $rcommit_id ) = @_;

    my $new_rs = $c->model('WebDB::msjobp')->create({
        msjob_id    => $msjob_id,
        jobp_id     => $jobp_id,
        rcommit_id  => $rcommit_id,
        start_time  => DateTime->now,
        end_time    => undef,
    });
    if ( ! $new_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: xxx"; # TODO
        return undef;
    }
    my $msjobp_id = $new_rs->get_column('msjobp_id');
    return $msjobp_id;
}


=method create_msjobp_cmd

Insert new row to msjobp_cmd table.

=cut

sub create_msjobp_cmd {
    my ( $self, $c, $data, $msjobp_id, $jobp_cmd_id ) = @_;

    my $new_rs = $c->model('WebDB::msjobp_cmd')->create({
        msjobp_id   => $msjobp_id,
        jobp_cmd_id => $jobp_cmd_id,
        status_id   => 1, # created
        pid         => undef,
        start_time  => DateTime->now,
        end_time    => undef,
        output_id   => undef,
    });
    if ( ! $new_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: xxx"; # TODO
        return undef;
    }
    my $msjobp_cmd_id = $new_rs->get_column('msjobp_cmd_id');
    return $msjobp_cmd_id;
}



=method get_next_cmd

Get next cmd info.

=cut

sub get_next_cmd {
    my ( $self, $c, $data, $job_id, $jobp_order, $jobp_cmd_order ) = @_;

    my $sql = "
        select jp.jobp_id,
               jpc.jobp_cmd_id,
               c.name as cmd_name,
               jpc.params as cmd_params
          from jobp jp,
               jobp_cmd jpc,
               cmd c
         where jp.job_id = ?
           and jpc.jobp_id = jp.jobp_id
           and (    ( ? is null or jpc.rorder > ? )
                 or ( ? is null or jp.rorder > ? )
               )
           and c.cmd_id = jpc.cmd_id
         order by jp.rorder, jpc.rorder
    "; # end sql

    my $ba = [
        $job_id,
        $jobp_cmd_order, $jobp_cmd_order,
        $jobp_order, $jobp_order,
    ];
    my $row_data = $self->edbi_selectrow_hashref( $c, undef, $sql, $ba );

    #$self->dumper( $c, $row_data );
    # ToDo - if jobp_cmd_id changed, then ...
    return $row_data;
}


=method get_next_cmd_mcid

Get next cmd info for previous $msjobp_cmd_id.

=cut

sub get_next_cmd_pmcid {
    my ( $self, $c, $data, $msproc_id, $msjobp_cmd_id ) = @_;

    my $rs = $c->model('WebDB::msjobp_cmd')->search( {
        'msjobp_cmd_id' => $msjobp_cmd_id,
        'msjob_id.msproc_id' => $msproc_id,
    }, {
        select => [ 'msjobp_id.msjob_id', 'msjobp_id.msjobp_id', 'jobp_id.job_id', 'jobp_id.jobp_id', 'msjobp_id.rcommit_id', 'jobp_id.rorder', 'jobp_cmd_id.rorder', ],
        as =>     [ 'msjob_id',           'msjobp_id',           'job_id',         'jobp_id',         'rcommit_id',           'jobp_order',    'jobp_cmd_order',     ],
        join => [ { 'msjobp_id' => [ 'msjob_id', 'jobp_id', ] }, 'jobp_cmd_id', ],
    } );
    #$self->dump_rs( $c, $rs );

    my $row = $rs->next;
    if ( !$row ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Machine session job part command id (msjobp_cmd_id=$msjobp_cmd_id) not found.";
        return 0;
    }

    my $prev_data = { $row->get_columns() };

    my $next_cmd = $self->get_next_cmd(
        $c, $data,
        $prev_data->{job_id},
        $prev_data->{jobp_order},
        $prev_data->{jobp_cmd_order}
    );
    # TODO, get rev_id, ...

    return {
        'new' => $next_cmd,
        'prev' => $prev_data,
    };
}


=method start_new_job

Get new job and insert new rows to apropriate tables.

=cut

sub start_new_job {
    my ( $self, $c, $data, $machine_id, $msession_id, $msproc_id ) = @_;

    my $new_job = $self->get_new_job( $c, $data, $machine_id, $msession_id );
    #$self->dumper( $c, $new_job );
    return undef unless $new_job; # undef isn't error

    my $job_id = $new_job->{job_id};
    my $rcommit_id = $new_job->{rcommit_id};

    # TODO, use SQL with jobp.rorder=1, jobp_cmd.rorder=1
    my $next_cmd = $self->get_next_cmd( $c, $data, $job_id, undef, undef );
    return $next_cmd unless $next_cmd; # undef isn't error

    my $jobp_id = $next_cmd->{jobp_id};
    my $jobp_cmd_id = $next_cmd->{jobp_cmd_id};

    my $msjob_id = $self->create_msjob( $c, $data, $msproc_id, $job_id );
    return 0 unless $msjob_id;

    my $msjobp_id = $self->create_msjobp( $c, $data, $msjob_id, $jobp_id, $rcommit_id );
    return 0 unless $msjobp_id;

    my $msjobp_cmd_id = $self->create_msjobp_cmd( $c, $data, $msjobp_id, $jobp_cmd_id );
    return 0 unless $msjobp_cmd_id;

    #$self->dumper( $c, "job_id: $job_id, rcommit_id: $rcommit_id");
    #$self->dumper( $c, "jobp_id: $jobp_id, jobp_cmd_id: $jobp_cmd_id");
    #$self->dumper( $c, "msjob_id: $msjob_id, msjobp_id: $msjobp_id, msjobp_cmd_id: $msjobp_cmd_id" );

    # need to be in sync with cmd_cget
    $data->{msjob_id} = $msjob_id;
    $data->{rcommit_id} = $rcommit_id;
    $data->{msjobp_id} = $msjobp_id;
    $data->{msjobp_cmd_id} = $msjobp_cmd_id;
    $data->{cmd_name} = $next_cmd->{cmd_name};
    $data->{cmd_params} = $next_cmd->{cmd_params} if $next_cmd->{cmd_params};
    return 1;
}


=method get_jobp_master_ref_rcommit_id

Return master ref rcommit_id for jobp_id.project_id.

=cut

sub get_jobp_master_ref_rcommit_id {
    my ( $self, $c, $data, $jobp_id ) = @_;

    my $job = $c->model('WebDB::jobp')->single( { jobp_id => $jobp_id, } );
    my $project_id = $job->get_column('project_id');
    my $rs = $c->model('WebDB::rref')->search(
        {
            'me.name' => 'master',
            'me.active' => 1,
            'rep_id.active' => 1,
            'rep_id.project_id' => $project_id,
        },
        {
            join => { 'rcommit_id' => 'rep_id' },
            'select' => [qw/ rcommit_id.rcommit_id /],
            'as' =>     [qw/ rcommit_id            /],
        }
    );
    my $row = $rs->next;
    if ( !$row ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Master ref rcommit_id for jobp_id $jobp_id not found.";
        return undef;
    }
    return $row->get_column('rcommit_id');
}


=method cmd_cget

Get command to run on client. Insert new row to msjob_command table and new
row to msjob table if needed.

=cut

sub cmd_cget {
    my ( $self, $c, $machine_id, $data, $params ) = @_;

    # $params->{msid} - already checked
    my $msession_id = $params->{msid};
    # $params->{mspid} - already checked
    my $msproc_id = $params->{mspid};
    # TODO - is_numeric?
    my $attempt_number = $params->{an};

    my $start_new_job = 0;
    if ( ! $params->{pmcid} ) {
        $start_new_job = 1;
    } else {
        # check if previous command wasn't last one in job
        # pmcid - previous msjobp_cmd_id
        $self->txn_begin_c( $c );
        my $cmds_data = $self->get_next_cmd_pmcid( $c, $data, $msproc_id, $params->{pmcid} );
        # next command in job found (in same jop part or new job part)
        if ( $cmds_data && $cmds_data->{new}->{jobp_cmd_id} ) {
            my $jobp_cmd_id = $cmds_data->{new}->{jobp_cmd_id};

            # use old msjobp_id or create new
            my $msjobp_id;
            # job part id can be same as prev or newly selected
            my $jobp_id = $cmds_data->{new}->{jobp_id};
            if ( $jobp_id == $cmds_data->{prev}->{jobp_id} ) {
                $msjobp_id = $cmds_data->{prev}->{msjobp_id};

            # if job part id is new, then we should create new msjobp_id
            } else {
                #$self->dumper( $c, $cmds_data );
                my $msjob_id = $cmds_data->{prev}->{msjob_id};

                # find new rcommit_id
                my $rcommit_id = $self->get_jobp_master_ref_rcommit_id( $c, $data, $jobp_id );
                return $self->txn_end_c( $c, $data, 0 ) unless $rcommit_id;

                # ToDo #issue/17 - get not tested rcommit_id
                return $self->txn_end_c( $c, $data, 0 );

                $msjobp_id = $self->create_msjobp( $c, $data, $msjob_id, $jobp_id, $rcommit_id );
                return $self->txn_end_c( $c, $data, 0 ) unless $msjobp_id;

                # need to be in sync with start_new_job
                $data->{msjob_id} = $msjob_id;
                $data->{rcommit_id} = $rcommit_id;
                $data->{msjobp_id} = $msjobp_id;
            }

            my $msjobp_cmd_id = $self->create_msjobp_cmd( $c, $data, $msjobp_id, $jobp_cmd_id );
            return $self->txn_end_c( $c, $data, 0 ) unless $msjobp_cmd_id;

            #$self->dumper( $c, "jobp_cmd_id: $jobp_cmd_id, msjobp_id: $msjobp_id, msjobp_cmd_id: $msjobp_cmd_id" );
            $data->{msjobp_cmd_id} = $msjobp_cmd_id;
            $data->{cmd_name} = $cmds_data->{new}->{cmd_name};
            $data->{cmd_params} = $cmds_data->{new}->{cmd_params} if $cmds_data->{new}->{cmd_params};

        } else {
            $start_new_job = 1;
        }
        $self->txn_end_c( $c, $data, 1 ) || return 0;
    }

    if ( $start_new_job ) {
        my $locked = $self->get_lock_for_machine_action( $c, $machine_id, 'get_new_job' );
        unless ( $locked ) {
            $data->{err} = 1001; # special err def
            $data->{err_msg} = "Error: cmd_get Can't obtain 'get_new_job' lock.";
            return 0;
        }
        $self->txn_begin_c( $c );
        my $ret_val = $self->start_new_job( $c, $data, $machine_id, $msession_id, $msproc_id );
        $self->txn_end_c( $c, $data, 1 ); # without return
        $self->release_lock_for_machine_action( $c, $machine_id, 'get_new_job' );
        unless ( defined $ret_val ) {
            # create msproc_log
            my $ret_code = $self->create_msproc_log(
                $c, $data, 'cget',
                $msproc_id,
                2, # $msproc_status_id, 2 .. waiting for new job
                $attempt_number,
                DateTime->now, # $change_time
                undef # $estimated_finish_time
            ) || return 0;
            return 1;
        }
        unless ( $ret_val ) {
            $data->{err} = 1;
            $data->{err_msg} = "Error: cmd_get ... (ret_val=$ret_val)."; # TODO
            return 0;
        }
    }

    # create msproc_log
    my $ret_code = $self->create_msproc_log(
        $c, $data, 'cget',
        $msproc_id,
        4, # $msstatus_id, 4 .. running command
        $attempt_number,
        DateTime->now, # $change_time
        undef # $estimated_finish_time
    ) || return 0;

    return 1;
}


=method get_msjobp_cmd_info

Return info for $msproc_id and $msjobp_cmd_id.

=cut

sub get_msjobp_cmd_info {
    my ( $self, $c, $data, $msproc_id, $msjobp_cmd_id ) = @_;

    my $rs = $c->model('WebDB::msjobp_cmd')->search( {
        'me.msjobp_cmd_id' => $msjobp_cmd_id,
        'msjob_id.msproc_id' => $msproc_id,
    }, {
        select => [ 'msjobp_id.msjobp_id', 'msjob_id.msjob_id', 'msjobp_id.rcommit_id', 'rcommit_id.rep_id' ],
        as =>     [ 'msjobp_id',           'msjob_id',          'rcommit_id',           'rep_id'            ],
        join =>   { 'msjobp_id' => [ 'msjob_id', 'jobp_id', 'rcommit_id', ] },
    } );

    my $row = $rs->next;
    if ( !$row ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Machine session job part command id (msproc_id=$msproc_id, msjobp_cmd_id=$msjobp_cmd_id) not found.";
        return 0;
    }
    my $row_data = { $row->get_columns() };
    return $row_data;
}


=method get_fspath_info

Select fspath info for fsfile_type_id and rep_id.

=cut


sub get_fspath_info {
    my ( $self, $c, $data, $fsfile_type_id, $rep_id ) = @_;

    my $row_data = $self->get_fspath_select_row( $c, $fsfile_type_id, $rep_id );
    if ( !$row_data ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Fspath id (fsfile_type_id=$fsfile_type_id, rep_id=$rep_id) not found.";
        return 0;
    }
    return $row_data;
}


=method move_uploaded_file

Create new machine session log (mslog) entry.

=cut

sub move_uploaded_file {
    my ( $self, $c, $data, $upload_req, $fspath_id, $fspath, $file_name  ) = @_;

    my $old_path = $upload_req->tempname;
    my $new_path = File::Spec->catfile( $fspath, $file_name );
    unless ( move( $old_path, $new_path ) ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Move file failed ( '$old_path', '$new_path' ):\n$!";
        return 0;
    }

    my $size = $upload_req->size(); # in bytes
    my $created = DateTime->now;

    my $fsfile_rs = $c->model('WebDB::fsfile')->create({
        fspath_id   => $fspath_id,
        name        => $file_name,
        size        => $size,
        created     => $created,
        deleted     => undef,
    });
    unless ( $fsfile_rs ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Create fsfile entry failed."; # TODO
        return 0;
    }
    my $fsfile_id = $fsfile_rs->get_column('fsfile_id');
    return $fsfile_id;
}


=method uploaded_file_found

Do all around file uploading.

=cut

sub uploaded_file_found {
    my ( $self, $c, $data, $input_name, $rep_id, $msjobp_cmd_id ) = @_;

    # TODO validate params

    my $output_file_upload_req = $c->request->upload( $input_name );
    #$self->dumper( $c, $c->request->uploads );
    unless ( $output_file_upload_req ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: cmd_sset upload output file failed ... ."; # TODO
        return 0;
    }

    my $file_name = undef;
    my $fsfile_type_id = undef;
    if ( $input_name eq 'output_file' ) {
        $fsfile_type_id = 1; # command output
        $file_name = $msjobp_cmd_id . '.txt';

    } elsif ( $input_name eq 'outdata_file' ) {
        $fsfile_type_id = 2; # command outdata
        $file_name = $msjobp_cmd_id . '.tar.gz';

    } else {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Upload output file failed. Unknown input_name '$input_name'."; # TODO
        return 0;
    }

    my $fspath_info = $self->get_fspath_info( $c, $data, $fsfile_type_id, $rep_id );
    return 0 unless $fspath_info;
    #$self->dumper( $c, $fspath_info );

    my $fsfile_id = $self->move_uploaded_file(
        $c,
        $data,
        $output_file_upload_req,    # $upload_req
        $fspath_info->{fspath_id},  # $fspath_id
        $fspath_info->{path},       # $fspath
        $file_name
    );
    return 0 unless $fsfile_id;
    return $fsfile_id;
}


=method update_msjobp_cmd

Update row with $msjobp_cmd_id in msjobp_cmd table. New values are in $to_set hash ref.

=cut


sub update_msjobp_cmd {
    my ( $self, $c, $data, $msjobp_cmd_id, $to_set ) = @_;

    my $msjobp_cmd_rs = $c->model('WebDB::msjobp_cmd')->search( {
        msjobp_cmd_id => $msjobp_cmd_id,
    } );

    my $ret_val = $msjobp_cmd_rs->update( $to_set );

    unless ( $ret_val ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: update msjobp_cmd failed ... (ret_val=$ret_val)."; # TODO
        return 0;
    }

    return 1;
}


=method cmd_sset

Set msjobp_cmd.status_id.

=cut

sub cmd_sset {
    my ( $self, $c, $data, $params, $upload ) = @_;

    # $params->{mspid} - already checked
    my $msproc_id = $params->{mspid};
    # TODO - is_numeric?
    my $msjobp_cmd_id = $params->{mcid};
    # TODO is valid status_id?
    my $cmd_status_id = $params->{csid};

    my $msjob_info = $self->get_msjobp_cmd_info( $c, $data, $msproc_id, $msjobp_cmd_id );
    return 0 unless $msjob_info;

    my $to_set = {
        status_id => $cmd_status_id,
    };
    if ( $params->{etime} ) {
        $to_set->{end_time} = DateTime->from_epoch( epoch => $params->{etime} );
    }

    if ( $params->{output_file} ) {
        my $fsfile_id = $self->uploaded_file_found(
            $c, $data,
            'output_file', # $input_name
            $msjob_info->{rep_id}, # rep_id
            $msjobp_cmd_id
        );
        return 0 unless $fsfile_id;
        $to_set->{output_id} = $fsfile_id;
    }

    if ( $params->{outdata_file} ) {
        my $fsfile_id = $self->uploaded_file_found(
            $c, $data,
            'outdata_file', # $input_name
            $msjob_info->{rep_id}, # rep_id
            $msjobp_cmd_id
        );
        return 0 unless $fsfile_id;
        $to_set->{outdata_id} = $fsfile_id;
    }

    return $self->update_msjobp_cmd( $c, $data, $msjobp_cmd_id, $to_set );
}


=method get_rcommit_info

Select rep info and rcommit info for given rcommit_id.

=cut

sub get_rcommit_info {
    my ( $self, $c, $data, $rcommit_id ) = @_;

    my $rs = $c->model('WebDB::rcommit')->search( {
        'me.rcommit_id' => $rcommit_id,
    }, {
        select => [ 'project_id.name', 'rep_id.name', 'rep_id.repo_url', 'sha_id.sha', ],
        as => [ 'project_name', 'repo_name', 'repo_url', 'sha', ],
        join => [ { 'rep_id' => 'project_id' }, 'sha_id' ],
    } );
    my $row = $rs->next;
    if ( !$row ) {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Rcommit_id id (rcommit_id=$rcommit_id) not found (get_rcommit_info).";
        return 0;
    }
    my $row_data = { $row->get_columns() };
    return $row_data;
}


=method rh_copy_kv_to

Copy (rewrite/add) input hash ref keys/values to output hash ref.

=cut


sub rh_copy_kv_to {
    my ( $self, $rh_in, $rh_out ) = @_;

    foreach my $key ( keys %$rh_in ) {
        $rh_out->{ $key } = $rh_in->{ $key };
    }
    return 1;
}


=method cmd_rciget

Get info for rep_path_id an rev_id.

=cut

sub cmd_rciget {
    my ( $self, $c, $data, $params, $upload ) = @_;

    # $params->{msid} - already checked
    my $msession_id = $params->{msid};
    # $params->{mspid} - already checked
    my $msproc_id = $params->{mspid};

    my $rcommit_id = $params->{rcid};

    my $rcommit_info = $self->get_rcommit_info( $c, $data, $rcommit_id );
    return 0 unless $rcommit_info;

    $self->rh_copy_kv_to( $rcommit_info, $data );

    # create mslog
    my $ret_code = $self->create_msproc_log(
        $c, $data, 'rciget',
        $msproc_id,
        4, # $msproc_status_id, 4 .. command preparation
        1,
        DateTime->now, # $change_time
        undef # $estimated_finish_time
    ) || return 0;

    return 1;
}


=method cmd_mevent

Machine event occured.

=cut

sub cmd_mevent {
    my ( $self, $c, $data, $params ) = @_;

    # $params->{msid} - already checked
    my $msession_id = $params->{msid};
    # $params->{mspid} - already checked
    my $msproc_id = $params->{mspid};

    # TODO - undef or is_numeric?
    my $msjobp_cmd_id = $params->{mcid};

    $self->check_param( $c, $data, $params, 'en', 'event name' ) || return 0;
    my $event_name = $params->{en};

    my $new_msstatus_id = undef;
    my $new_cmd_status_id = undef;

    if ( $event_name eq 'pause' ) {
        $new_msstatus_id = 4; # paused by user
        $new_cmd_status_id = 4; # paused by user

    } elsif ( $event_name eq 'pause refresh' ) {
        $new_msstatus_id = 5; # paused by user - refresh

    } elsif ( $event_name eq 'continue' ) {
        # TODO - try to restore msstatus_id from before pause
        $new_msstatus_id = 1; # unknown status
        $new_cmd_status_id = 3; # running

    } else {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Unknown event name '$event_name'.";
        return 0;
    }


    if ( $new_msstatus_id ) {
        # create mslog
        my $ret_code = $self->create_mslog(
            $c, $data, 'mevent',
            $msession_id,
            $new_msstatus_id, # $msstatus_id
            1, # $attempt_number
            DateTime->now, # $change_time
            undef # $estimated_finish_time
        ) || return 0;
    }

    if ( $msjobp_cmd_id && $new_cmd_status_id ) {
        # check/validate of msession_id vs. msjobp_cmd_id
        my $msjob_info = $self->get_msjobp_cmd_info( $c, $data, $msproc_id, $msjobp_cmd_id );
        return 0 unless $msjob_info;

        my $to_set = {
            status_id => $new_cmd_status_id,
        };
        return $self->update_msjobp_cmd( $c, $data, $msjobp_cmd_id, $to_set );
    }

    return 1;
}


=method process_action

Process all params but 'ot'.

=cut

sub process_action {
    my ( $self, $c, $action ) = @_;

    my $params = $c->request->params;
    my $data = {};
    $c->stash->{data} = $data;

    $data->{is_debug} = 1 if $c->log->is_debug;

    if ( $params->{ot} eq 'html' && $c->log->is_debug ) {
        $self->dumper( $c, $params );

        # [% dumper(data) | html %]
        $c->stash->{dumper} = sub { DBIx::Dumper::Dumper( $_[0] ); };
    }

    my $param_msid_checks;
         if ( $action eq 'mscreate' )   { $param_msid_checks = 0;   # msession create
    } elsif ( $action eq 'msdestroy' )  { $param_msid_checks = 1;   # msession destroy
    } elsif ( $action eq 'mspcreate' )  { $param_msid_checks = 1;   # msproc create
    } elsif ( $action eq 'cget' )       { $param_msid_checks = 1;   # get command
    } elsif ( $action eq 'sset' )       { $param_msid_checks = 1;   # set status
    } elsif ( $action eq 'rciget' )     { $param_msid_checks = 1;   # rep rev info get
    } elsif ( $action eq 'mevent' )     { $param_msid_checks = 1;   # machine event occured
    # debug commands
    } elsif ( $action eq 'login' )      { $param_msid_checks = 0;   # login
    } else {
        $data->{err} = 1;
        $data->{err_msg} = "Error: Unknow action '$action'.";
        return 0;
    }

    my $machine_id = $self->access_allowed( $c, $data, $params, $param_msid_checks );

    my $cmd_ret_code = undef;
    if ( $machine_id ) {
        if ( $action eq 'mscreate' ) {
            $cmd_ret_code = $self->cmd_mscreate( $c, $machine_id, $data, $params );

        } elsif ( $action eq 'mspcreate' ) {
            $cmd_ret_code = $self->cmd_mspcreate( $c, $data, $params );

        } elsif ( $action eq 'msdestroy' ) {
            $cmd_ret_code = $self->cmd_msdestroy( $c, $data, $params );

        } elsif ( $action eq 'cget' ) {
            $cmd_ret_code = $self->cmd_cget( $c, $machine_id, $data, $params );

        } elsif ( $action eq 'sset' ) {
            $cmd_ret_code = $self->cmd_sset( $c, $data, $params, $c->request->upload );

        } elsif ( $action eq 'rciget' ) {
            $cmd_ret_code = $self->cmd_rciget( $c, $machine_id, $data, $params );

        } elsif ( $action eq 'mevent' ) {
            $cmd_ret_code = $self->cmd_mevent( $c, $machine_id, $data, $params );

        }
    }

    return 1;
}


=method index

Base index method.

Use params:

ot - output type, allowed 'html' and 'json', default 'json'

=cut


sub index : Path {
    my ( $self, $c, $action, @args ) = @_;

    $self->process_action( $c, $action );

    my $params = $c->request->params;
    if ( $params->{ot} eq 'html' ) {
        return;
    }
    $c->forward('TapTinder::Web::View::JSON');
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
