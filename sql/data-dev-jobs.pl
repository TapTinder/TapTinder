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

    my $master_tr1_rref_id = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 1, # default repo for tt-tr1 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    )->id;
    return 0 unless $master_tr1_rref_id;

    my $b1_tr1_rref_id = $schema->resultset('rref')->find(
        {
            'me.name' => 'b1',
            'rcommit_id.rep_id' => 1, # default repo for tt-tr1 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    )->id;
    return 0 unless $b1_tr1_rref_id;

    my $master_tr2_rref_id = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 2, # default repo for tt-tr2 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    )->id;
    return 0 unless $master_tr2_rref_id;

    my $master_tr3_rref_id = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 3, # default repo for tt-tr3 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    )->id;
    return 0 unless $master_tr3_rref_id;

    # Parrot, Rakudo
    my $master_parrot_rref_rs = $schema->resultset('rref')->find(
        {
            'me.name' => 'master',
            'rcommit_id.rep_id' => 4, # default repo for tt-tr3 project, see data-dev.pl
        },
        {
            join => 'rcommit_id',
        }
    );
    my $master_parrot_rref_id = undef;
    $master_parrot_rref_id = $master_parrot_rref_rs->id if defined $master_parrot_rref_rs;

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
        [          1,            257,        1,       'tr1 A',  undef    ],
        [          2,            257,        2,  'tr1, tr2 A',  undef    ],
        [          3,            257,        3,  'tr1, tr3 A',  undef    ],
        [          4,            257,        4,       'tr1 B',  undef    ],
        [          5,            257,        1,         'tr2',  undef    ],
        [          6,            257,        1,         'tr3',  undef    ],
        [          7,            257,        1,      'Parrot',  undef    ],
        [          8,            257,        1,      'Rakudo',  undef    ],
        [          9,            257,        1,  'tr1 params',  undef    ],
    ]);

 
    # table: jobp
    $schema->resultset('jobp')->delete_all() if $delete_all;
    $schema->resultset('jobp')->populate([
        [ qw/ jobp_id  job_id  project_id   rorder                       name    descr    max_age  depends_on_id  extends /  ],
        [           1,      1,          1,       1,                 'sole tr1',  undef,  5*365*24,         undef,       0    ],

        [           2,      2,          1,       1,                     'base',  undef,  5*365*24,         undef,       0    ],
        [           3,      2,          2,       2,           'external tests',  undef,  5*365*24,             2,       1    ],

        [           4,      3,          1,       1,                     'base',  undef,  5*365*24,         undef,       0    ],
        [           5,      3,          3,       2,             'related part',  undef,  5*365*24,             4,       0    ],

        [           6,      4,          1,       1,                 'sole tr1',  undef,     undef,         undef,       0    ],

        [           7,      5,          2,       1,                 'sole tr2',  undef,     undef,         undef,       0    ],
        [           8,      6,          3,       1,                 'sole tr3',  undef,  5*365*24,         undef,       0    ],
        [           9,      7,          4,       1,              'sole Parrot',  undef,      1*24,         undef,       0    ],
        [          10,      8,          5,       1,              'sole Rakudo',  undef,      1*24,         undef,       0    ],
        [          11,      9,          1,       1,     'sole tr1 with params',  undef,  5*365*24,         undef,       0    ],
    ]);

 
    # table: jobp_cmd
    $schema->resultset('jobp_cmd')->delete_all() if $delete_all;
    $schema->resultset('jobp_cmd')->populate([
        [ qw/ jobp_cmd_id jobp_id rorder cmd_id params / ],

        # job_id = 1
        [ 1, 1, 1, 1, undef ],
        [ 2, 1, 2, 2, undef ],
        [ 3, 1, 3, 4, undef ],
        [ 4, 1, 4, 5, undef ],
        [ 5, 1, 5, 6, undef ],


        # job_id = 2
        [ 6,  2, 1, 1, undef ],
        [ 7,  2, 2, 2, undef ],
        [ 8,  2, 3, 4, undef ],
        [ 9,  2, 4, 5, undef ],
        [ 10, 2, 5, 6, undef ],

        [ 11, 3, 1, 1, undef ],
        [ 12, 3, 2, 2, undef ],
        [ 13, 3, 3, 6, undef ],


        # job_id = 3
        [ 14, 4, 1, 1, undef ],
        [ 15, 4, 2, 2, undef ],
        [ 16, 4, 3, 4, undef ],
        [ 17, 4, 4, 5, undef ],
        [ 18, 4, 5, 6, undef ],

        [ 19, 5, 1, 1, undef ],
        [ 20, 5, 2, 2, undef ],
        [ 21, 5, 3, 4, undef ],
        [ 22, 5, 4, 5, undef ],
        [ 23, 5, 5, 6, undef ],


        # job_id = 4
        [ 24, 6, 1, 1, undef ],
        [ 25, 6, 2, 2, undef ],
        [ 26, 6, 3, 4, undef ],
        [ 27, 6, 4, 5, undef ],


        # job_id = 5
        [ 28, 7, 1, 1, undef ],
        [ 29, 7, 2, 2, undef ],
        [ 30, 7, 3, 4, undef ],
        [ 31, 7, 4, 5, undef ],


        # job_id = 6
        [ 32, 8, 1, 1, undef ],
        [ 33, 8, 2, 2, undef ],
        [ 34, 8, 3, 4, undef ],
        [ 35, 8, 4, 5, undef ],


        # job_id = 7
        [ 36, 9, 1, 1, undef ],
        [ 37, 9, 2, 2, undef ],
        [ 38, 9, 3, 4, undef ],
        [ 39, 9, 4, 5, undef ],


        # job_id = 8
        [ 40, 10, 1, 1, undef ],
        [ 41, 10, 2, 2, undef ],
        [ 42, 10, 3, 4, undef ],
        [ 43, 10, 4, 5, undef ],


        # job_id = 9
        [ 44, 11, 1, 1, 'param1-val param2-val' ],
        [ 45, 11, 2, 2, 'param1-val param2-val' ],
        [ 46, 11, 3, 4, 'param1-val param2-val' ],
        [ 47, 11, 4, 5, 'param1-val param2-val' ],

    ]);


    # table: wconf_session
    $schema->resultset('wconf_session')->delete_all() if $delete_all;
    $schema->resultset('wconf_session')->populate([
        [ qw/ wconf_session_id machine_id processes_num / ],
        [ 1, 1, 1  ], # tapir1
        [ 2, 2, 3  ], # tapir2
        [ 3, 3, 2  ], # pc-jurosz2
        [ 4, 4, 1  ], # some-test-machine
    ]);


    # table: wconf_job
    $schema->resultset('wconf_job')->delete_all() if $delete_all;
    $schema->resultset('wconf_job')->populate([
        [ qw/ wconf_job_id  wconf_session_id  rep_id               rref_id  job_id  priority  / ],
        [                1,                1,      1,  $master_tr1_rref_id,      9,        1    ], # tapir1
       #[                2,                1,      1,  $master_tr1_rref_id,      2,        2    ], # tapir1 - ToDo #issue/17
       #[                3,                1,      1,  $master_tr1_rref_id,      3,        3    ], # tapir1 - ToDo #issue/17
        [                4,                1,      1,  $master_tr1_rref_id,      4,        4    ], # tapir1

        [                5,                2,      1,  $master_tr1_rref_id,      9,        1    ], # tapir2
        [                6,                2,      3,                undef,      6,        2    ], # tapir2
        [                7,                2,      2,  $master_tr2_rref_id,      5,        3    ], # tapir2
        [                8,                2,      2,                undef,      5,        4    ], # tapir2
        [                9,                2,      4,                undef,      7,        5    ], # tapir2
        [               10,                2,      5,                undef,      8,        6    ], # tapir2
        [               11,                2,      1,  $master_tr1_rref_id,      1,        7    ], # tapir2
       
       #[               12,                2,      1,                undef,      2,        7    ], # tapir2 - ToDo #issue/17
        [               13,                2,      1,                undef,      1,        8    ], # tapir2

        [               14,                3,      3,  $master_tr3_rref_id,      6,        1    ], # pc-jurosz2
        [               15,                3,      4,                undef,      7,        2    ], # pc-jurosz2
        [               16,                3,      5,                undef,      8,        3    ], # pc-jurosz2

        [               17,                4,      1,  $master_tr1_rref_id,      1,        1    ], # some-test-machine
    ]);


    # table: wconf_rref
    $schema->resultset('wconf_rref')->delete_all() if $delete_all;
    $schema->resultset('wconf_rref')->populate([
        [ qw/ wconf_rref_id              rref_id   priority /  ],
        [                 1, $master_tr1_rref_id,         1,   ],
        [                 2, $master_tr2_rref_id,         1,   ],
        [                 3, $master_tr3_rref_id,         1,   ],
    ]);
    if ( $master_parrot_rref_id ) {
        $schema->resultset('wconf_rref')->create({
            wconf_rref_id => 4,
            rref_id => $master_parrot_rref_id,
            priority => 1,
        });
    }
    if ( $master_rakudo_rref_id ) {
        $schema->resultset('wconf_rref')->create({
            wconf_rref_id => 5,
            rref_id => $master_rakudo_rref_id,
            priority => 1,
        });
    }


    # table: wui_rref
    $schema->resultset('wui_rref')->delete_all() if $delete_all;
    $schema->resultset('wui_rref')->populate([
        [ qw/ wui_rref_id              rref_id  wui_order /  ],
        [               1, $b1_tr1_rref_id,             1,   ],
        [               2, $master_tr1_rref_id,         2,   ],
        [               3, $master_tr2_rref_id,         3,   ],
        [               4, $master_tr3_rref_id,         4,   ],
    ]);

    # table: wui_build
    $schema->resultset('wui_build')->delete_all() if $delete_all;
    $schema->resultset('wui_build')->populate([
        [ qw/ wui_build_id  project_id  jobp_id /  ],
        [                1,          1,       1,   ],
        [                2,          2,       7,   ],
        [                3,          3,       8,   ],
        [                4,          4,       9,   ],
        [                5,          5,      10,   ],
    ]);


    # table: ichannel_conf
    $schema->resultset('ichannel_conf')->delete_all() if $delete_all;
    $schema->resultset('ichannel_conf')->populate([
        [ qw/ ichannel_conf_id  ibot_id  ichannel_id  errors_only  ireport_type_id  jobp_cmd_id  max_age / ],
        [                    1,       1,           1,           1,               1,           4,   14*24,  ],
        [                    2,       1,           1,           0,               1,           4,    7*24,  ],
        [                    3,       1,           1,           1,               1,          31,   undef,  ],
        [                    4,       1,           1,           1,               1,          39 ,   7*24,  ],
        [                    5,       1,           1,           1,               1,          43 ,   7*24,  ],
        [                    6,       1,           2,           1,               1,          35 ,   7*24,  ],
    ]);


    return 1;
};
