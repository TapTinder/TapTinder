use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec;
use Cwd 'abs_path';


return sub {
    my ( $schema, $delete_all, $data ) = @_;
    
    my $server_data_dir = '/opt/taptinder/server';

    # table: params
    $schema->resultset('param')->search({
        'param_type_id' => 2, # delete all old 'instance-name' rows
    })->delete_all;
    $schema->resultset('param')->populate([
        [ qw/ param_type_id value / ],
        [ 2, 'ttprod' ],
    ]);
    

    # table: user
    $schema->resultset('user')->delete_all() if $delete_all;
    $schema->resultset('user')->populate([
        [ qw/ user_id login passwd first_name last_name irc_nick active created last_login / ],
        [ 1, 'mj41', \'substring(MD5(RAND()), -8)', 'Michal', 'Jurosz', 'mj41', 1, \'NOW()', undef ],
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
        [ 1, 'tapir1',        1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.191.11', 'x86_64', 'linux',       'i386-linux-thread-multi',     0, undef, 1       ],
        [ 2, 'tapir2',        1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.191.12', 'x86_64', 'linux',       'i386-linux-thread-multi',     0, undef, 1       ],
        [ 3, 'pc-jurosz2',    1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.5.124',  'i386',   'MSWin32',     'MSWin32-x86-multi-thread',    0, undef, undef   ],
        [ 4, 'ttcl-rh5-32',   1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.73',   'x86_64', 'linux',       'i386-linux-thread-multi',     0, undef, undef   ],
        [ 5, 'ttcl-fbsd-32',  1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.193',  'x86_64', 'FreeBSD',     'i386-freebsd-64int',          0, undef, undef   ],
        [ 6, 'ttcl-macos-32', 1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.183',  'x86_64', 'MacOS 10.5',  'darwin-thread-multi-2level',  0, undef, undef   ],
        [ 7, 'ttcl-win-32',   1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.152',  'x86_64', 'cygwin',      'cygwin-thread-multi-64int',   0, undef, undef   ],
        [ 8, 'ttcl-win2-32',  1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.160',  'x86_64', 'MSWin32',     'MSWin32-x86-multi-thread',    0, undef, undef   ],
        [ 9, 'ttcl-osol-64',  1, \'substring(MD5(RAND()), -8)', undef, \'NOW()', '147.229.2.153',  'x86_64', 'OpenSolaris', 'i86pc-solaris-64int',         0, undef, undef   ],
    ]);

    # table: project
    $schema->resultset('project')->delete_all() if $delete_all;
    $schema->resultset('project')->populate([
        [ qw/ project_id name url descr / ],
        [ 1, 'tt-tr1', 'http://dev.taptinder.org/wiki/TapTinder-tr1', 'TapTinder test repository 1' ],
        [ 2, 'tt-tr2', 'http://dev.taptinder.org/wiki/TapTinder-tr2', 'TapTinder test repository 2' ],
        [ 3, 'tt-tr3', 'http://dev.taptinder.org/wiki/TapTinder-tr3', 'TapTinder test repository 3' ],
        [ 4, 'Parrot', 'http://www.parrot.org/', 'Parrot' ],
        [ 5, 'Rakudo', 'http://www.rakudo.org/', 'Rakudo Perl 6' ],
    ]);

 
    # table: rep
    $schema->resultset('rep')->delete_all() if $delete_all;
    $schema->resultset('rep')->populate([
        [ qw/ rep_id  project_id  active       name                              repo_url                          github_url                 descr / ],
        [         1,          1,       1, 'default',   'git://github.com/mj41/tt-tr1.git',   'https://github.com/mj41/tt-tr1', 'Default repository', ],
        [         2,          2,       1, 'default',   'git://github.com/mj41/tt-tr2.git',   'https://github.com/mj41/tt-tr2', 'Default repository', ],
        [         3,          3,       1, 'default',   'git://github.com/mj41/tt-tr3.git',   'https://github.com/mj41/tt-tr3', 'Default repository', ],
        [         4,          4,       1, 'default', 'git://github.com/parrot/parrot.git', 'https://github.com/parrot/parrot', 'Default repository', ],
        [         5,          5,       1, 'default', 'git://github.com/rakudo/rakudo.git', 'https://github.com/rakudo/rakudo', 'Default repository', ],
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
        [                    4,              1,      4,         1,  ],
        [                    5,              1,      5,         1,  ],

        [                    6,              2,      1,         1,  ],
        [                    7,              2,      2,         1,  ],
        [                    8,              2,      3,         1,  ],
        [                    9,              2,      4,         1,  ],
        [                   10,              2,      5,         1,  ],
    ]);

 
    # table: ibot
    $schema->resultset('ibot')->delete_all() if $delete_all;
    $schema->resultset('ibot')->populate([
        [ qw/ ibot_id        nick              full_name               server  port  operator_id /  ],
        [          1,     'ttbot',      'TapTinder bot.',      'irc.perl.org', 6667,           1,   ],
    ]);

    # table: ichannel
    $schema->resultset('ichannel')->delete_all() if $delete_all;
    $schema->resultset('ichannel')->populate([
        [ qw/ ichannel_id                  name  / ],
        [               1,            '#parrot',   ],
    ]);


    # table: wui_project
    $schema->resultset('wui_project')->delete_all() if $delete_all;
    $schema->resultset('wui_project')->populate([
        [ qw/ wui_project_id project_id wui_order / ],
        [ 1, 4, 1 ],
        [ 2, 5, 2 ],
        [ 3, 1, 3 ],
        [ 4, 2, 4 ],
        [ 5, 3, 5 ],
    ]);


    return 1;
};
