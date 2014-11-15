use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec;
use Cwd 'abs_path';


return sub {
    my ( $schema, $delete_all, $data ) = @_;
    
    my $server_data_dir = abs_path( 
        File::Spec->catdir( $FindBin::Bin, '..', '..', 'server-data' )
    );
    

    # table: params
    $schema->resultset('param')->search({
        'param_type_id' => 2, # delete all old 'instance-name' rows
    })->delete_all;
    $schema->resultset('param')->populate([
        [ qw/ param_type_id value / ],
        [ 2, 'ttdev' ],
    ]);
    
    
    # table: user
    $schema->resultset('user')->delete_all() if $delete_all;
    $schema->resultset('user')->populate([
        [ qw/ user_id login passwd first_name last_name irc_nick active created last_login / ],
        [ 1, 'adm', 'baxXrXtQl0c6Y', 'Admin', 'User',  'adm', 1, \'NOW()', undef ], # passwd: 'bar123'
        [ 2, 'kn',  'baxXrXtQl0c6Y', 'Karel', 'Novak', 'kn',  1, \'NOW()', undef ], # passwd: 'bar123'
    ]);

    # table: user_roles
    $schema->resultset('user_roles')->delete_all() if $delete_all;
    $schema->resultset('user_roles')->populate([
        [ qw/ user_id role_id / ],
        [ 1, 1 ], # admin
        [ 1, 2 ], # add_machine
        [ 1, 3 ], # add_branch
    ]);

    # table: farm
    $schema->resultset('farm')->delete_all() if $delete_all;
    $schema->resultset('farm')->populate([
        [ qw/ farm_id name has_same_hw has_same_sw descr / ],
        [ 1, 'tapir cluster', 1, 0, 'Dedicated to TapTinder.' ],
    ]);


    # table: machine
    $schema->resultset('machine')->delete_all() if $delete_all;
    $schema->resultset('machine')->populate([
        [ qw/ machine_id name user_id passwd descr created ip cpuarch osname archname disabled prev_machine_id farm_id / ],
        [ 1, 'docker1',  1, \'substring(unhex(MD5("tt-docker-pswd765")), -8)', undef, \'NOW()', '127.0.0.1', 'x86_64', 'linux', 'i386-linux-thread-multi', 0, undef, 1 ],
    ]);


    # table: project
    $schema->resultset('project')->delete_all() if $delete_all;
    $schema->resultset('project')->populate([
        [ qw/ project_id name url descr / ],
        [ 1, 'tt-tr1', 'http://dev.taptinder.org/wiki/TapTinder-tr1', 'TapTinder test repository 1' ],
        [ 2, 'tt-tr2', 'http://dev.taptinder.org/wiki/TapTinder-tr2', 'TapTinder test repository 2' ],
        [ 3, 'tt-tr3', 'http://dev.taptinder.org/wiki/TapTinder-tr3', 'TapTinder test repository 3' ],
    ]);

 
    # table: rep
    $schema->resultset('rep')->delete_all() if $delete_all;
    $schema->resultset('rep')->populate([
        [ qw/ rep_id  project_id  active       name                              repo_url                          github_url                 descr / ],
        [         1,          1,       1, 'default',   'git://github.com/TapTinder/tt-tr1.git',   'https://github.com/TapTinder/tt-tr1', 'Main repository', ],
        [         2,          2,       1, 'default',   'git://github.com/TapTinder/tt-tr2.git',   'https://github.com/TapTinder/tt-tr2', 'Main repository', ],
        [         3,          3,       1, 'default',   'git://github.com/TapTinder/tt-tr3.git',   'https://github.com/TapTinder/tt-tr3', 'Main repository', ],
    ]);


    # table: fspath
    $schema->resultset('fspath')->delete_all() if $delete_all;
    $schema->resultset('fspath')->populate([
        [ qw/ fspath_id path web_path public created deleted name descr / ],
        [ 1, $server_data_dir.'/cmdout',   'file/cmdout', 1, \'NOW()', undef, 'dir-cmdout',   'dir for command outputs'  ],
        [ 2, $server_data_dir.'/archive',  'file/patch',  1, \'NOW()', undef, 'dir-archive',  'dir for archives'         ],
    ]);

 
    # table: fspath_select
    $schema->resultset('fspath_select')->delete_all() if $delete_all;
    $schema->resultset('fspath_select')->populate([
        [ qw/ fspath_select_id  fsfile_type_id  rep_id  fspath_id / ],
        [                    1,              1,      1,         1,  ],
        [                    2,              1,      2,         1,  ],
        [                    3,              1,      3,         1,  ],

        [                    6,              2,      1,         1,  ],
        [                    7,              2,      2,         1,  ],
        [                    8,              2,      3,         1,  ],

        [                   11,              3,      1,         2,  ],
        [                   12,              3,      2,         2,  ],
        [                   13,              3,      3,         2,  ],
    ]);

 
    # table: ibot
    $schema->resultset('ibot')->delete_all() if $delete_all;
    $schema->resultset('ibot')->populate([
        [ qw/ ibot_id        nick              full_name               server  port  operator_id /  ],
        [          1, 'ttbot-dev', 'TapTinder bot (dev).', 'irc.freenode.org', 6667,           1,   ],
    ]);


    # table: ichannel
    $schema->resultset('ichannel')->delete_all() if $delete_all;
    $schema->resultset('ichannel')->populate([
        [ qw/ ichannel_id                  name  / ],
        [               1, '#taptinder-bottest1',  ],
        [               2, '#taptinder-bottest2',  ],
    ]);


    # table: wui_project
    $schema->resultset('wui_project')->delete_all() if $delete_all;
    $schema->resultset('wui_project')->populate([
        [ qw/ wui_project_id project_id wui_order / ],
        [ 1, 1, 1 ],
        [ 2, 2, 2 ],
        [ 3, 3, 3 ],
    ]);

    return 1;
};
