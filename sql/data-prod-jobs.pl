use strict;
use warnings;
use utf8;

return sub {
    my ( $schema, $delete_all, $data ) = @_;

    if ( $delete_all ) {
        $schema->resultset('msjobp_cmd')->delete_all();
        $schema->resultset('msjobp')->delete_all();
        $schema->resultset('msjob')->delete_all();
        $schema->resultset('msproc_log')->delete_all();
        $schema->resultset('msproc')->delete_all();
        $schema->resultset('mswatch_log')->delete_all();
        $schema->resultset('mslog')->delete_all();
        $schema->resultset('msession')->delete_all();
    }

    # MoarVM, Rakudo
    my $master_moarvm_rref_rs = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 4, # default repo for tt-tr3 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    );
    my $master_moarvm_rref_id = undef;
    $master_moarvm_rref_id = $master_moarvm_rref_rs->id if defined $master_moarvm_rref_rs;

    my $master_rakudo_rref_rs = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 5, # default repo for tt-tr3 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    );
    my $master_rakudo_rref_id = undef;
    $master_rakudo_rref_id = $master_rakudo_rref_rs->id if defined $master_rakudo_rref_rs;


    # table: job
    $schema->resultset('job')->delete_all() if $delete_all;
    $schema->resultset('job')->populate([
        [ qw/ job_id  client_min_ver  priority           name   descr / ],
        [          1,            257,        1,      'MoarVM',  undef    ],
        [          2,            257,        2,      'Rakudo',  undef    ],
    ]);


    # table: jobp
    $schema->resultset('jobp')->delete_all() if $delete_all;
    $schema->resultset('jobp')->populate([
        [ qw/ jobp_id  job_id  project_id    rorder             name    descr    max_age  depends_on_id  extends /  ],
        [           1,      1,          4,       1,     'sole MoarVM',  undef,      3*24,         undef,       0    ],
        [           2,      2,          5,       1,     'sole Rakudo',  undef,      3*24,         undef,       0    ],
    ]);


    # table: jobp_cmd
    $schema->resultset('jobp_cmd')->delete_all() if $delete_all;
    $schema->resultset('jobp_cmd')->populate([
        [ qw/ jobp_cmd_id jobp_id rorder cmd_id / ],

        # job_id = 1
        [  1, 1, 1, 1 ],
        [  2, 1, 2, 2 ],
        [  3, 1, 3, 4 ],
        [  4, 1, 4, 5 ],


        # job_id = 2, ToDo
        [  5, 2, 1, 1 ],
        [  6, 2, 2, 2 ],
        [  7, 2, 3, 4 ],
        [  8, 2, 4, 5 ],
    ]);

    # table: wconf_job
    $schema->resultset('wconf_job')->delete_all() if $delete_all;
    $schema->resultset('wconf_job')->populate([
        [ qw/ wconf_job_id   rep_id                  rref_id  job_id  machine_id  priority  / ],
        [                1,       4,  $master_moarvm_rref_id,      1,         1,         1    ],
        [                2,       4,  $master_moarvm_rref_id,      1,         2,         1    ],
        [                3,       4,  $master_moarvm_rref_id,      1,         3,         1    ],
        [                4,       4,  $master_moarvm_rref_id,      1,         4,         1    ],
        [                5,       4,  $master_moarvm_rref_id,      1,         5,         1    ],
        [                6,       4,  $master_moarvm_rref_id,      1,         6,         1    ],
        [                7,       4,  $master_moarvm_rref_id,      1,         7,         1    ],
        [                8,       4,  $master_moarvm_rref_id,      1,         8,         1    ],
       # ToDo Rakudo
       #[                9,       5,  $master_rakudo_rref_id,      2,         9,         3    ],
    ]);


    # table: wconf_rref
    $schema->resultset('wconf_rref')->delete_all() if $delete_all;
    if ( $master_moarvm_rref_id ) {
        $schema->resultset('wconf_rref')->create({
            wconf_rref_id => 1,
            rref_id => $master_moarvm_rref_id,
            priority => 1,
        });
    }
    if ( $master_rakudo_rref_id ) {
        $schema->resultset('wconf_rref')->create({
            wconf_rref_id => 2,
            rref_id => $master_rakudo_rref_id,
            priority => 1,
        });
    }


    # table: wui_build
    $schema->resultset('wui_build')->delete_all() if $delete_all;
    $schema->resultset('wui_build')->populate([
        [ qw/ wui_build_id  project_id  jobp_id /  ],
        [                1,          4,       1,   ],
        [                2,          5,       2,   ],
    ]);


    # table: ichannel_conf
    $schema->resultset('ichannel_conf')->delete_all() if $delete_all;
    $schema->resultset('ichannel_conf')->populate([
        [ qw/ ichannel_conf_id  ibot_id  ichannel_id  errors_only  ireport_type_id  jobp_cmd_id  max_age / ],
        [                    1,       1,           1,           1,               1,           4,    7*24,  ],
       #[                    2,       1,           1,           1,               1,           8,    7*24,  ],
    ]);


    return 1;
};
