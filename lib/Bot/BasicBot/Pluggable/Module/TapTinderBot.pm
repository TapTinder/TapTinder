package Bot::BasicBot::Pluggable::Module::TapTinderBot;

#ABSTRACT: Report TapTinder status updates.

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;

use Data::Dumper;
use Carp qw(carp croak verbose);

our $tick_counter = 0;


sub init {
    my $self = shift;

    $self->{loop_num} = 0;
    $self->set('user_tick', "1") unless defined ( $self->get('user_tick') );
}


sub tick {
    my $self = shift;

    my $period = $self->get('user_tick');
    my $tick_counter++;
    return if ( $tick_counter < $period);
    $tick_counter = 0;
    return $self->_check_news();
}

sub _save_done {
    my ( $self, $ibot_id, $ichannel_conf_id, $rcommit_id ) = @_;

    return $self->{schema}->resultset('ibot_log')->create({
        ibot_id => $ibot_id,
        ichannel_conf_id => $ichannel_conf_id,
        rcommit_id => $rcommit_id,
    });
}


sub _check_news {
    my ( $self, $debug ) = @_;
    $self->{loop_num}++;

    my $sql = <<'SQLEND';
        select ichc.ibot_id,
               ichc.ichannel_id,
               ichc.ireport_type_id,
               ichc.ichannel_conf_id,
               ich.name as channel,
               m.machine_id,
               m.name as machine_name,
               m.archname,
               jp.project_id,
               c.name as cmd_name,
               p.name as project_name,
               rc.rcommit_id,
               rc.rep_id,
               s.sha,
               unix_timestamp( rc.committer_time ) as committer_time_ts,
               ra.rep_login as author_login,
               cs.name as status_name,
               mjpc.msjobp_cmd_id,
               concat(fsp.web_path, '/', fsf.name) as web_fpath,
               (
                 select 1
                   from ibot_log ibl
                  where ibl.ibot_id = ichc.ibot_id
                    and ibl.ichannel_conf_id = ichc.ichannel_conf_id
                    and ibl.rcommit_id = rc.rcommit_id
                  limit 1
               ) as reported
          from ichannel_conf ichc,
               ichannel ich,
               jobp_cmd jpc,
               jobp jp,
               cmd c,
               job j,
               msjobp_cmd mjpc,
               msjobp mjp,
               msjob mj,
               msproc mp,
               msession ms,
               machine m,
               rcommit rc,
               sha s,
               rep r,
               project p,
               rauthor ra,
               cmd_status cs,
               fsfile fsf,
               fspath fsp
         where ichc.ibot_id = ? -- <<<
           and ich.ichannel_id = ichc.ichannel_id
           and jpc.jobp_cmd_id = ichc.jobp_cmd_id
           and jp.jobp_id = jpc.jobp_id
           and c.cmd_id = jpc.cmd_id
           and j.job_id = jp.job_id
           and mjpc.jobp_cmd_id = ichc.jobp_cmd_id
           and ( mjpc.status_id = 4 or mjpc.status_id = 7 )
           and ( ichc.errors_only = 0 or mjpc.status_id = 7 )
           and mjp.msjobp_id = mjpc.msjobp_id
           and mjp.jobp_id = jp.jobp_id
           and rc.rcommit_id = mjp.rcommit_id
           and ( ichc.max_age is null or DATE_SUB(CURDATE(), INTERVAL ichc.max_age HOUR) <= rc.committer_time )
           and ra.rauthor_id = rc.author_id
           and mj.msjob_id = mjp.msjob_id
           and mj.job_id = j.job_id
           and mp.msproc_id = mj.msproc_id
           and ms.msession_id = mp.msession_id
           and m.machine_id = ms.machine_id
           and r.rep_id = rc.rep_id
           and p.project_id = r.project_id
           and s.sha_id = rc.sha_id
           and cs.cmd_status_id = mjpc.status_id
           and fsf.fsfile_id = mjpc.output_id
           and fsp.fspath_id = fsf.fspath_id
         order by ichc.ichannel_id, ichc.ireport_type_id, rc.committer_time, rc.rcommit_id
SQLEND

    my $ba = [ $self->{ibot_id} ];

    my $dbh = $self->{schema}->storage->dbh;
    my $sth = $dbh->prepare( $sql );
    $sth->execute( @$ba );

    my $max_rc = {};
    while ( my $row = $sth->fetchrow_hashref() ) {
        print Dumper( $row ) if $debug;
        my $key =
              $row->{ichannel_id} . '-'
            . $row->{ireport_type_id} . '-'
            . $row->{archname} . '-'
            . $row->{rep_id} . '-'
            . $row->{status_name}
        ;
        if ( (not exists $max_rc->{$key}) || $row->{committer_time_ts} > $max_rc->{$key}->{committer_time_ts} ) {
            $max_rc->{$key} = { %$row };
        }
    }
    print Dumper( $max_rc ) if $debug;

    foreach my $key ( keys %$max_rc ) {
        next if $max_rc->{$key}->{reported};

        my $channel_name = $max_rc->{$key}->{channel};
        unless ( exists $self->{Bot}->{channel_data}->{$channel_name} ) {
            carp "Bot not started for channel '$channel_name'.";
            next;
        }
        my $data = $max_rc->{$key};

        my $msg = '';
        #$msg .= "$data->{author_login}: ";
        $msg .= "$data->{project_name} ";
        $msg .= substr($data->{sha},0,8) . " $data->{archname}";

        # build report
        if ( $data->{ireport_type_id} == 1 ) {
            $msg .= " $data->{cmd_name} $data->{status_name}";
            $msg .= " " . $self->{server_base_url} . 'cr/' . $data->{msjobp_cmd_id};
            $msg .= " (debug: $self->{loop_num})" if $self->{irc_debug};
            $self->tell( $channel_name, $msg );

        # ttest report
        } elsif ( $data->{ireport_type_id} == 2 ) {
            # ToDo
            # $self->tell( $channel_name, $msg );
        }

        $self->_save_done( $data->{ibot_id}, $data->{ichannel_conf_id}, $data->{rcommit_id} );
    }

    return $self;
}


sub help {
    return "Gives TapTinder report status.";
}


sub _my_init {
    my ( $self, $ibot_id, $schema, $server_base_url, $ver, $debug ) = @_;
    $self->{ibot_id} = $ibot_id;
    $self->{schema} = $schema;
    $self->{server_base_url} = $server_base_url;
    $self->{ver} = $ver;
    $self->{debug} = $debug;
    $self->{irc_debug} = $debug;
    return $self;
}


=head1 SEE ALSO

L<TapTinder>, L<Bot::BasicBot::Pluggable>

=cut

1;
