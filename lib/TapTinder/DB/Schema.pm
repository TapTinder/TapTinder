

package TapTinder::DB::Schema::rref_rcommit;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rref_rcommit');


__PACKAGE__->add_columns(
    'rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);


package TapTinder::DB::Schema::msproc_abort_reason;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msproc_abort_reason');


__PACKAGE__->add_columns(
    'msproc_abort_reason_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msproc_abort_reason_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('msproc_abort_reason_id');


package TapTinder::DB::Schema::wui_test;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wui_test');


__PACKAGE__->add_columns(
    'wui_test_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_test_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'jobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'jobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wui_test_id');


package TapTinder::DB::Schema::wui_build;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wui_build');


__PACKAGE__->add_columns(
    'wui_build_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_build_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'jobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'jobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wui_build_id');


package TapTinder::DB::Schema::rcparent;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rcparent');


__PACKAGE__->add_columns(
    'rcparent_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rcparent_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'child_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'child_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'parent_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'parent_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'num' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'num',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('rcparent_id');


package TapTinder::DB::Schema::rfile;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rfile');


__PACKAGE__->add_columns(
    'rfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rpath_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rpath_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('rfile_id');


package TapTinder::DB::Schema::rauthor;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rauthor');


__PACKAGE__->add_columns(
    'rauthor_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rauthor_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rep_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rep_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rep_login' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'rep_login',
      'is_nullable' => 1,
      'size' => '255'
    },
    'email' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'email',
      'is_nullable' => 1,
      'size' => '255'
    },
    'user_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'user_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('rauthor_id');


package TapTinder::DB::Schema::jobp_cmd;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('jobp_cmd');


__PACKAGE__->add_columns(
    'jobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'jobp_cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'jobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'jobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rorder' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rorder',
      'is_nullable' => 0,
      'size' => '10'
    },
    'cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'params' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'params',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('jobp_cmd_id');


package TapTinder::DB::Schema::rref;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rref');


__PACKAGE__->add_columns(
    'rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '500'
    },
    'fullname' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fullname',
      'is_nullable' => 0,
      'size' => '500'
    },
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'active' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'active',
      'is_nullable' => 0,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('rref_id');


package TapTinder::DB::Schema::rcommit;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rcommit');


__PACKAGE__->add_columns(
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rep_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rep_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'sha_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'sha_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'tree_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'tree_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'parents_num' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'parents_num',
      'is_nullable' => 0,
      'size' => '10'
    },
    'parent_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'parent_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'author_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'author_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'author_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'author_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'committer_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'committer_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'committer_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'committer_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'msg' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msg',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('rcommit_id');


package TapTinder::DB::Schema::user;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('user');


__PACKAGE__->add_columns(
    'user_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'user_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'login' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'login',
      'is_nullable' => 0,
      'size' => '20'
    },
    'passwd' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'passwd',
      'is_nullable' => 0,
      'size' => '20'
    },
    'first_name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => '',
      'is_foreign_key' => 0,
      'name' => 'first_name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'last_name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => '',
      'is_foreign_key' => 0,
      'name' => 'last_name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'irc_nick' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'irc_nick',
      'is_nullable' => 1,
      'size' => '25'
    },
    'active' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'active',
      'is_nullable' => 0,
      'size' => '0'
    },
    'created' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'created',
      'is_nullable' => 0,
      'size' => '0'
    },
    'last_login' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'last_login',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('user_id');


package TapTinder::DB::Schema::msproc_log;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msproc_log');


__PACKAGE__->add_columns(
    'msproc_log_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msproc_log_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msproc_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msproc_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msproc_status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msproc_status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'attempt_number' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'attempt_number',
      'is_nullable' => 1,
      'size' => '10'
    },
    'change_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'change_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'estimated_finish_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'estimated_finish_time',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('msproc_log_id');


package TapTinder::DB::Schema::ichannel;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ichannel');


__PACKAGE__->add_columns(
    'ichannel_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ichannel_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '50'
    },
);
__PACKAGE__->set_primary_key('ichannel_id');


package TapTinder::DB::Schema::param;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('param');


__PACKAGE__->add_columns(
    'param_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'param_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'param_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'param_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'value' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'value',
      'is_nullable' => 1,
      'size' => '255'
    },
);
__PACKAGE__->set_primary_key('param_id');


package TapTinder::DB::Schema::msession;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msession');


__PACKAGE__->add_columns(
    'msession_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msession_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'machine_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'machine_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'client_rev' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'client_rev',
      'is_nullable' => 0,
      'size' => '21'
    },
    'pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'pid',
      'is_nullable' => 1,
      'size' => '10'
    },
    'watchdog_pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'watchdog_pid',
      'is_nullable' => 1,
      'size' => '10'
    },
    'start_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'start_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'end_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'end_time',
      'is_nullable' => 1,
      'size' => '0'
    },
    'abort_reason_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'abort_reason_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('msession_id');


package TapTinder::DB::Schema::wconf_rref;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wconf_rref');


__PACKAGE__->add_columns(
    'wconf_rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wconf_rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'priority' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'priority',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wconf_rref_id');


package TapTinder::DB::Schema::msabort_reason;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msabort_reason');


__PACKAGE__->add_columns(
    'msabort_reason_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msabort_reason_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('msabort_reason_id');


package TapTinder::DB::Schema::msjob;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msjob');


__PACKAGE__->add_columns(
    'msjob_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msjob_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msproc_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msproc_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'job_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'job_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'start_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'start_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'end_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'end_time',
      'is_nullable' => 1,
      'size' => '0'
    },
    'pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'pid',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('msjob_id');


package TapTinder::DB::Schema::fsfile_type;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('fsfile_type');


__PACKAGE__->add_columns(
    'fsfile_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fsfile_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('fsfile_type_id');


package TapTinder::DB::Schema::cmd;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('cmd');


__PACKAGE__->add_columns(
    'cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('cmd_id');


package TapTinder::DB::Schema::trun_status;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('trun_status');


__PACKAGE__->add_columns(
    'trun_status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'trun_status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('trun_status_id');


package TapTinder::DB::Schema::sha;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('sha');


__PACKAGE__->add_columns(
    'sha_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'sha_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'sha' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'sha',
      'is_nullable' => 1,
      'size' => '40'
    },
);
__PACKAGE__->set_primary_key('sha_id');


package TapTinder::DB::Schema::fsfile_ext;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('fsfile_ext');


__PACKAGE__->add_columns(
    'fsfile_ext_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fsfile_ext_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'archive_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'archive_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'org_name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'org_name',
      'is_nullable' => 1,
      'size' => '255'
    },
    'fsfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'fsfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('fsfile_ext_id');


package TapTinder::DB::Schema::rpath;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rpath');


__PACKAGE__->add_columns(
    'rpath_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rpath_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'path' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'path',
      'is_nullable' => 0,
      'size' => '1000'
    },
);
__PACKAGE__->set_primary_key('rpath_id');


package TapTinder::DB::Schema::bfile;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('bfile');


__PACKAGE__->add_columns(
    'bfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'bfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'brun_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'brun_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'run_time' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'run_time',
      'is_nullable' => 1,
      'size' => '10'
    },
    'hang' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'hang',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('bfile_id');


package TapTinder::DB::Schema::rtest;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rtest');


__PACKAGE__->add_columns(
    'rtest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rtest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'number' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'number',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'has_another_name' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'has_another_name',
      'is_nullable' => 0,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('rtest_id');


package TapTinder::DB::Schema::wconf_session;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wconf_session');


__PACKAGE__->add_columns(
    'wconf_session_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wconf_session_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'machine_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'machine_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'processes_num' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'processes_num',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wconf_session_id');


package TapTinder::DB::Schema::cmd_status;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('cmd_status');


__PACKAGE__->add_columns(
    'cmd_status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'cmd_status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('cmd_status_id');


package TapTinder::DB::Schema::farm;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('farm');


__PACKAGE__->add_columns(
    'farm_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'farm_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '30'
    },
    'has_same_hw' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'has_same_hw',
      'is_nullable' => 0,
      'size' => '0'
    },
    'has_same_sw' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'has_same_sw',
      'is_nullable' => 0,
      'size' => '0'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('farm_id');


package TapTinder::DB::Schema::ireport_type;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ireport_type');


__PACKAGE__->add_columns(
    'ireport_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ireport_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '15'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('ireport_type_id');


package TapTinder::DB::Schema::trest;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('trest');


__PACKAGE__->add_columns(
    'trest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'trest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('trest_id');


package TapTinder::DB::Schema::jobp;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('jobp');


__PACKAGE__->add_columns(
    'jobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'jobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'job_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'job_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'project_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'rorder' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rorder',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
    'max_age' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'max_age',
      'is_nullable' => 1,
      'size' => '10'
    },
    'depends_on_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'depends_on_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'extends' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'extends',
      'is_nullable' => 0,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('jobp_id');


package TapTinder::DB::Schema::fspath;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('fspath');


__PACKAGE__->add_columns(
    'fspath_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fspath_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'path' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'path',
      'is_nullable' => 1,
      'size' => '1023'
    },
    'web_path' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'web_path',
      'is_nullable' => 1,
      'size' => '255'
    },
    'public' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'public',
      'is_nullable' => 1,
      'size' => '0'
    },
    'created' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'created',
      'is_nullable' => 0,
      'size' => '0'
    },
    'deleted' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'deleted',
      'is_nullable' => 1,
      'size' => '0'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('fspath_id');


package TapTinder::DB::Schema::mslog;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('mslog');


__PACKAGE__->add_columns(
    'mslog_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'mslog_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msession_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msession_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msstatus_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msstatus_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'attempt_number' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'attempt_number',
      'is_nullable' => 1,
      'size' => '10'
    },
    'change_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'change_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'estimated_finish_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'estimated_finish_time',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('mslog_id');


package TapTinder::DB::Schema::msproc_status;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msproc_status');


__PACKAGE__->add_columns(
    'msproc_status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msproc_status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('msproc_status_id');


package TapTinder::DB::Schema::role;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('role');


__PACKAGE__->add_columns(
    'role_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'role_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'role' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'role',
      'is_nullable' => 1,
      'size' => '32'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('role_id');


package TapTinder::DB::Schema::msproc;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msproc');


__PACKAGE__->add_columns(
    'msproc_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msproc_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msession_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msession_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'start_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'start_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'end_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'end_time',
      'is_nullable' => 1,
      'size' => '0'
    },
    'pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'pid',
      'is_nullable' => 1,
      'size' => '10'
    },
    'abort_reason_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'abort_reason_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('msproc_id');


package TapTinder::DB::Schema::fsfile;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('fsfile');


__PACKAGE__->add_columns(
    'fsfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fsfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'fspath_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'fspath_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '255'
    },
    'size' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'size',
      'is_nullable' => 0,
      'size' => '10'
    },
    'created' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'created',
      'is_nullable' => 0,
      'size' => '0'
    },
    'deleted' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'deleted',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('fsfile_id');


package TapTinder::DB::Schema::param_type;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('param_type');


__PACKAGE__->add_columns(
    'param_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'param_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '20'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('param_type_id');


package TapTinder::DB::Schema::project;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('project');


__PACKAGE__->add_columns(
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'url' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'url',
      'is_nullable' => 0,
      'size' => '255'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('project_id');


package TapTinder::DB::Schema::msjobp;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msjobp');


__PACKAGE__->add_columns(
    'msjobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msjobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msjob_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msjob_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'jobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'jobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'start_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'start_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'end_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'end_time',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('msjobp_id');


package TapTinder::DB::Schema::wconf_job;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wconf_job');


__PACKAGE__->add_columns(
    'wconf_job_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wconf_job_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'wconf_session_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'wconf_session_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rep_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rep_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'rref_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'job_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'job_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'priority' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'priority',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wconf_job_id');


package TapTinder::DB::Schema::msstatus;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msstatus');


__PACKAGE__->add_columns(
    'msstatus_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msstatus_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('msstatus_id');


package TapTinder::DB::Schema::tskipall_msg;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('tskipall_msg');


__PACKAGE__->add_columns(
    'tskipall_msg_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'tskipall_msg_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msg' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msg',
      'is_nullable' => 1,
      'size' => '65535'
    },
    'hash' => {
      'data_type' => 'CHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'hash',
      'is_nullable' => 0,
      'size' => '30'
    },
);
__PACKAGE__->set_primary_key('tskipall_msg_id');


package TapTinder::DB::Schema::brun;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('brun');


__PACKAGE__->add_columns(
    'brun_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'brun_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msjobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msjobp_cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'conf_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'conf_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('brun_id');


package TapTinder::DB::Schema::ibot_log;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ibot_log');


__PACKAGE__->add_columns(
    'ibot_log_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ibot_log_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ibot_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ibot_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ichannel_conf_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ichannel_conf_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rcommit_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rcommit_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('ibot_log_id');


package TapTinder::DB::Schema::msjobp_cmd;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('msjobp_cmd');


__PACKAGE__->add_columns(
    'msjobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msjobp_cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msjobp_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msjobp_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'jobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'jobp_cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'pid',
      'is_nullable' => 1,
      'size' => '10'
    },
    'start_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'start_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'end_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'end_time',
      'is_nullable' => 1,
      'size' => '0'
    },
    'output_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'output_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'outdata_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'outdata_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('msjobp_cmd_id');


package TapTinder::DB::Schema::machine;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('machine');


__PACKAGE__->add_columns(
    'machine_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'machine_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'user_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'user_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '20'
    },
    'passwd' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'passwd',
      'is_nullable' => 0,
      'size' => '20'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
    'ip' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'ip',
      'is_nullable' => 1,
      'size' => '15'
    },
    'cpuarch' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'cpuarch',
      'is_nullable' => 1,
      'size' => '50'
    },
    'osname' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'osname',
      'is_nullable' => 1,
      'size' => '50'
    },
    'archname' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'archname',
      'is_nullable' => 1,
      'size' => '255'
    },
    'disabled' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'disabled',
      'is_nullable' => 0,
      'size' => '0'
    },
    'created' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'created',
      'is_nullable' => 0,
      'size' => '0'
    },
    'prev_machine_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'prev_machine_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'farm_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'farm_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('machine_id');


package TapTinder::DB::Schema::ttest;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ttest');


__PACKAGE__->add_columns(
    'ttest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ttest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'trun_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'trun_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rtest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rtest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'trest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'trest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('ttest_id');


package TapTinder::DB::Schema::tdiag_msg;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('tdiag_msg');


__PACKAGE__->add_columns(
    'tdiag_msg_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'tdiag_msg_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ttest_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ttest_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msg' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'msg',
      'is_nullable' => 1,
      'size' => '65535'
    },
    'hash' => {
      'data_type' => 'CHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'hash',
      'is_nullable' => 0,
      'size' => '30'
    },
);
__PACKAGE__->set_primary_key('tdiag_msg_id');


package TapTinder::DB::Schema::wui_project;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wui_project');


__PACKAGE__->add_columns(
    'wui_project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'wui_order' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_order',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wui_project_id');


package TapTinder::DB::Schema::brun_conf;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('brun_conf');


__PACKAGE__->add_columns(
    'brun_conf_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'brun_conf_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'hash' => {
      'data_type' => 'CHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'hash',
      'is_nullable' => 0,
      'size' => '30'
    },
    'args' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'args',
      'is_nullable' => 1,
      'size' => '255'
    },
    'alias_conf_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'alias_conf_id',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('brun_conf_id');


package TapTinder::DB::Schema::user_roles;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('user_roles');


__PACKAGE__->add_columns(
    'user_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'user_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'role_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'role_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('user_id', 'role_id');


package TapTinder::DB::Schema::mswatch_log;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('mswatch_log');


__PACKAGE__->add_columns(
    'mswatch_log_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'mswatch_log_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msession_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msession_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'pid' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'pid',
      'is_nullable' => 0,
      'size' => '10'
    },
    'last_activity_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'last_activity_time',
      'is_nullable' => 0,
      'size' => '0'
    },
    'kill_time' => {
      'data_type' => 'DATETIME',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'kill_time',
      'is_nullable' => 0,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('mswatch_log_id');


package TapTinder::DB::Schema::job;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('job');


__PACKAGE__->add_columns(
    'job_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'job_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'client_min_ver' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'client_min_ver',
      'is_nullable' => 1,
      'size' => '40'
    },
    'priority' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'priority',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 1,
      'size' => '25'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
);
__PACKAGE__->set_primary_key('job_id');


package TapTinder::DB::Schema::wui_rref;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('wui_rref');


__PACKAGE__->add_columns(
    'wui_rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rref_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rref_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'wui_order' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'wui_order',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('wui_rref_id');


package TapTinder::DB::Schema::trun;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('trun');


__PACKAGE__->add_columns(
    'trun_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'trun_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'msjobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'msjobp_cmd_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'trun_status_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'trun_status_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'parse_errors' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'parse_errors',
      'is_nullable' => 0,
      'size' => '10'
    },
    'not_seen' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'not_seen',
      'is_nullable' => 0,
      'size' => '10'
    },
    'failed' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'failed',
      'is_nullable' => 0,
      'size' => '10'
    },
    'todo' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'todo',
      'is_nullable' => 0,
      'size' => '10'
    },
    'skip' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'skip',
      'is_nullable' => 0,
      'size' => '10'
    },
    'bonus' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'bonus',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ok' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ok',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('trun_id');


package TapTinder::DB::Schema::ichannel_conf;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ichannel_conf');


__PACKAGE__->add_columns(
    'ichannel_conf_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ichannel_conf_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ibot_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ibot_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ichannel_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ichannel_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'ireport_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'ireport_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'errors_only' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'errors_only',
      'is_nullable' => 0,
      'size' => '0'
    },
    'jobp_cmd_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'jobp_cmd_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'max_age' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'max_age',
      'is_nullable' => 1,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('ichannel_conf_id');


package TapTinder::DB::Schema::fspath_select;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('fspath_select');


__PACKAGE__->add_columns(
    'fspath_select_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'fspath_select_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'fsfile_type_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'fsfile_type_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rep_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'rep_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'fspath_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'fspath_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('fspath_select_id');


package TapTinder::DB::Schema::ibot;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('ibot');


__PACKAGE__->add_columns(
    'ibot_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'ibot_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'nick' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'nick',
      'is_nullable' => 0,
      'size' => '50'
    },
    'full_name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'full_name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'server' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'server',
      'is_nullable' => 0,
      'size' => '50'
    },
    'port' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'port',
      'is_nullable' => 0,
      'size' => '10'
    },
    'operator_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'operator_id',
      'is_nullable' => 0,
      'size' => '10'
    },
);
__PACKAGE__->set_primary_key('ibot_id');


package TapTinder::DB::Schema::tfile;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('tfile');


__PACKAGE__->add_columns(
    'tfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'tfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'trun_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'trun_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'rfile_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'rfile_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'all_passed' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'all_passed',
      'is_nullable' => 0,
      'size' => '0'
    },
    'tskipall_msg_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 1,
      'name' => 'tskipall_msg_id',
      'is_nullable' => 1,
      'size' => '10'
    },
    'hang' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '0',
      'is_foreign_key' => 0,
      'name' => 'hang',
      'is_nullable' => 1,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('tfile_id');


package TapTinder::DB::Schema::rep;
use base 'TapTinder::DB::DBIxClassBase';

__PACKAGE__->table('rep');


__PACKAGE__->add_columns(
    'rep_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 1,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'rep_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'project_id' => {
      'data_type' => 'int',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 1,
      'name' => 'project_id',
      'is_nullable' => 0,
      'size' => '10'
    },
    'name' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'name',
      'is_nullable' => 0,
      'size' => '255'
    },
    'repo_url' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'repo_url',
      'is_nullable' => 0,
      'size' => '255'
    },
    'github_url' => {
      'data_type' => 'VARCHAR',
      'is_auto_increment' => 0,
      'default_value' => undef,
      'is_foreign_key' => 0,
      'name' => 'github_url',
      'is_nullable' => 0,
      'size' => '255'
    },
    'descr' => {
      'data_type' => 'TEXT',
      'is_auto_increment' => 0,
      'default_value' => 'NULL',
      'is_foreign_key' => 0,
      'name' => 'descr',
      'is_nullable' => 1,
      'size' => '65535'
    },
    'active' => {
      'data_type' => 'BOOLEAN',
      'is_auto_increment' => 0,
      'default_value' => '1',
      'is_foreign_key' => 0,
      'name' => 'active',
      'is_nullable' => 0,
      'size' => '0'
    },
);
__PACKAGE__->set_primary_key('rep_id');

package TapTinder::DB::Schema::rref_rcommit;

__PACKAGE__->belongs_to('rref_id','TapTinder::DB::Schema::rref','rref_id');

__PACKAGE__->belongs_to('rcommit_id','TapTinder::DB::Schema::rcommit','rcommit_id');


package TapTinder::DB::Schema::msproc_abort_reason;

__PACKAGE__->has_many('get_msproc', 'TapTinder::DB::Schema::msproc', 'abort_reason_id');

package TapTinder::DB::Schema::wui_test;

__PACKAGE__->belongs_to('project_id','TapTinder::DB::Schema::project','project_id');

__PACKAGE__->belongs_to('jobp_id','TapTinder::DB::Schema::jobp','jobp_id');


package TapTinder::DB::Schema::wui_build;

__PACKAGE__->belongs_to('project_id','TapTinder::DB::Schema::project','project_id');

__PACKAGE__->belongs_to('jobp_id','TapTinder::DB::Schema::jobp','jobp_id');


package TapTinder::DB::Schema::rcparent;

__PACKAGE__->belongs_to('child_id','TapTinder::DB::Schema::rcommit','child_id');

__PACKAGE__->belongs_to('parent_id','TapTinder::DB::Schema::rcommit','parent_id');


package TapTinder::DB::Schema::rfile;

__PACKAGE__->belongs_to('rcommit_id','TapTinder::DB::Schema::rcommit','rcommit_id');

__PACKAGE__->belongs_to('rpath_id','TapTinder::DB::Schema::rpath','rpath_id');

__PACKAGE__->has_many('get_tfile', 'TapTinder::DB::Schema::tfile', 'rfile_id');
__PACKAGE__->has_many('get_rtest', 'TapTinder::DB::Schema::rtest', 'rfile_id');
__PACKAGE__->has_many('get_bfile', 'TapTinder::DB::Schema::bfile', 'rfile_id');

package TapTinder::DB::Schema::rauthor;

__PACKAGE__->belongs_to('rep_id','TapTinder::DB::Schema::rep','rep_id');

__PACKAGE__->belongs_to('user_id','TapTinder::DB::Schema::user','user_id',{join_type => 'left'});

__PACKAGE__->has_many('get_rcommit', 'TapTinder::DB::Schema::rcommit', 'author_id');
__PACKAGE__->has_many('get_rcommit_committer_id', 'TapTinder::DB::Schema::rcommit', 'committer_id');

package TapTinder::DB::Schema::jobp_cmd;

__PACKAGE__->belongs_to('jobp_id','TapTinder::DB::Schema::jobp','jobp_id');

__PACKAGE__->belongs_to('cmd_id','TapTinder::DB::Schema::cmd','cmd_id');

__PACKAGE__->has_many('get_msjobp_cmd', 'TapTinder::DB::Schema::msjobp_cmd', 'jobp_cmd_id');
__PACKAGE__->has_many('get_ichannel_conf', 'TapTinder::DB::Schema::ichannel_conf', 'jobp_cmd_id');

package TapTinder::DB::Schema::rref;

__PACKAGE__->belongs_to('rcommit_id','TapTinder::DB::Schema::rcommit','rcommit_id');

__PACKAGE__->has_many('get_rref_rcommit', 'TapTinder::DB::Schema::rref_rcommit', 'rref_id');
__PACKAGE__->has_many('get_wconf_job', 'TapTinder::DB::Schema::wconf_job', 'rref_id');
__PACKAGE__->has_many('get_wconf_rref', 'TapTinder::DB::Schema::wconf_rref', 'rref_id');
__PACKAGE__->has_many('get_wui_rref', 'TapTinder::DB::Schema::wui_rref', 'rref_id');

package TapTinder::DB::Schema::rcommit;

__PACKAGE__->belongs_to('rep_id','TapTinder::DB::Schema::rep','rep_id');

__PACKAGE__->belongs_to('sha_id','TapTinder::DB::Schema::sha','sha_id');

__PACKAGE__->belongs_to('tree_id','TapTinder::DB::Schema::sha','tree_id');

__PACKAGE__->belongs_to('parent_id','TapTinder::DB::Schema::rcommit','parent_id',{join_type => 'left'});

__PACKAGE__->has_many('get_rcommit', 'TapTinder::DB::Schema::rcommit', 'parent_id');
__PACKAGE__->belongs_to('author_id','TapTinder::DB::Schema::rauthor','author_id');

__PACKAGE__->belongs_to('committer_id','TapTinder::DB::Schema::rauthor','committer_id');

__PACKAGE__->has_many('get_rcparent', 'TapTinder::DB::Schema::rcparent', 'child_id');
__PACKAGE__->has_many('get_rcparent_parent_id', 'TapTinder::DB::Schema::rcparent', 'parent_id');
__PACKAGE__->has_many('get_rref', 'TapTinder::DB::Schema::rref', 'rcommit_id');
__PACKAGE__->has_many('get_rref_rcommit', 'TapTinder::DB::Schema::rref_rcommit', 'rcommit_id');
__PACKAGE__->has_many('get_rfile', 'TapTinder::DB::Schema::rfile', 'rcommit_id');
__PACKAGE__->has_many('get_msjobp', 'TapTinder::DB::Schema::msjobp', 'rcommit_id');
__PACKAGE__->has_many('get_ibot_log', 'TapTinder::DB::Schema::ibot_log', 'rcommit_id');

package TapTinder::DB::Schema::user;

__PACKAGE__->has_many('get_user_roles', 'TapTinder::DB::Schema::user_roles', 'user_id');
__PACKAGE__->has_many('get_machine', 'TapTinder::DB::Schema::machine', 'user_id');
__PACKAGE__->has_many('get_rauthor', 'TapTinder::DB::Schema::rauthor', 'user_id');
__PACKAGE__->has_many('get_ibot', 'TapTinder::DB::Schema::ibot', 'operator_id');

package TapTinder::DB::Schema::msproc_log;

__PACKAGE__->belongs_to('msproc_id','TapTinder::DB::Schema::msproc','msproc_id');

__PACKAGE__->belongs_to('msproc_status_id','TapTinder::DB::Schema::msproc_status','msproc_status_id');


package TapTinder::DB::Schema::ichannel;

__PACKAGE__->has_many('get_ichannel_conf', 'TapTinder::DB::Schema::ichannel_conf', 'ichannel_id');

package TapTinder::DB::Schema::param;

__PACKAGE__->belongs_to('param_type_id','TapTinder::DB::Schema::param_type','param_type_id');


package TapTinder::DB::Schema::msession;

__PACKAGE__->belongs_to('machine_id','TapTinder::DB::Schema::machine','machine_id');

__PACKAGE__->belongs_to('abort_reason_id','TapTinder::DB::Schema::msabort_reason','abort_reason_id',{join_type => 'left'});

__PACKAGE__->has_many('get_msproc', 'TapTinder::DB::Schema::msproc', 'msession_id');
__PACKAGE__->has_many('get_mslog', 'TapTinder::DB::Schema::mslog', 'msession_id');
__PACKAGE__->has_many('get_mswatch_log', 'TapTinder::DB::Schema::mswatch_log', 'msession_id');

package TapTinder::DB::Schema::wconf_rref;

__PACKAGE__->belongs_to('rref_id','TapTinder::DB::Schema::rref','rref_id');


package TapTinder::DB::Schema::msjob;

__PACKAGE__->belongs_to('msproc_id','TapTinder::DB::Schema::msproc','msproc_id');

__PACKAGE__->belongs_to('job_id','TapTinder::DB::Schema::job','job_id');

__PACKAGE__->has_many('get_msjobp', 'TapTinder::DB::Schema::msjobp', 'msjob_id');

package TapTinder::DB::Schema::msabort_reason;

__PACKAGE__->has_many('get_msession', 'TapTinder::DB::Schema::msession', 'abort_reason_id');

package TapTinder::DB::Schema::fsfile_type;

__PACKAGE__->has_many('get_fspath_select', 'TapTinder::DB::Schema::fspath_select', 'fsfile_type_id');

package TapTinder::DB::Schema::cmd;

__PACKAGE__->has_many('get_jobp_cmd', 'TapTinder::DB::Schema::jobp_cmd', 'cmd_id');

package TapTinder::DB::Schema::trun_status;

__PACKAGE__->has_many('get_trun', 'TapTinder::DB::Schema::trun', 'trun_status_id');

package TapTinder::DB::Schema::sha;

__PACKAGE__->has_many('get_rcommit', 'TapTinder::DB::Schema::rcommit', 'sha_id');
__PACKAGE__->has_many('get_rcommit_tree_id', 'TapTinder::DB::Schema::rcommit', 'tree_id');

package TapTinder::DB::Schema::fsfile_ext;

__PACKAGE__->belongs_to('archive_id','TapTinder::DB::Schema::fsfile','archive_id');

__PACKAGE__->belongs_to('fsfile_id','TapTinder::DB::Schema::fsfile','fsfile_id');


package TapTinder::DB::Schema::rpath;

__PACKAGE__->has_many('get_rfile', 'TapTinder::DB::Schema::rfile', 'rpath_id');

package TapTinder::DB::Schema::bfile;

__PACKAGE__->belongs_to('brun_id','TapTinder::DB::Schema::brun','brun_id');

__PACKAGE__->belongs_to('rfile_id','TapTinder::DB::Schema::rfile','rfile_id');


package TapTinder::DB::Schema::rtest;

__PACKAGE__->belongs_to('rfile_id','TapTinder::DB::Schema::rfile','rfile_id');

__PACKAGE__->has_many('get_ttest', 'TapTinder::DB::Schema::ttest', 'rtest_id');

package TapTinder::DB::Schema::wconf_session;

__PACKAGE__->belongs_to('machine_id','TapTinder::DB::Schema::machine','machine_id');

__PACKAGE__->has_many('get_wconf_job', 'TapTinder::DB::Schema::wconf_job', 'wconf_session_id');

package TapTinder::DB::Schema::cmd_status;

__PACKAGE__->has_many('get_msjobp_cmd', 'TapTinder::DB::Schema::msjobp_cmd', 'status_id');

package TapTinder::DB::Schema::farm;

__PACKAGE__->has_many('get_machine', 'TapTinder::DB::Schema::machine', 'farm_id');

package TapTinder::DB::Schema::ireport_type;

__PACKAGE__->has_many('get_ichannel_conf', 'TapTinder::DB::Schema::ichannel_conf', 'ireport_type_id');

package TapTinder::DB::Schema::trest;

__PACKAGE__->has_many('get_ttest', 'TapTinder::DB::Schema::ttest', 'trest_id');

package TapTinder::DB::Schema::jobp;

__PACKAGE__->belongs_to('job_id','TapTinder::DB::Schema::job','job_id');

__PACKAGE__->belongs_to('project_id','TapTinder::DB::Schema::project','project_id',{join_type => 'left'});

__PACKAGE__->belongs_to('depends_on_id','TapTinder::DB::Schema::jobp','depends_on_id',{join_type => 'left'});

__PACKAGE__->has_many('get_jobp', 'TapTinder::DB::Schema::jobp', 'depends_on_id');
__PACKAGE__->has_many('get_jobp_cmd', 'TapTinder::DB::Schema::jobp_cmd', 'jobp_id');
__PACKAGE__->has_many('get_msjobp', 'TapTinder::DB::Schema::msjobp', 'jobp_id');
__PACKAGE__->has_many('get_wui_build', 'TapTinder::DB::Schema::wui_build', 'jobp_id');
__PACKAGE__->has_many('get_wui_test', 'TapTinder::DB::Schema::wui_test', 'jobp_id');

package TapTinder::DB::Schema::fspath;

__PACKAGE__->has_many('get_fsfile', 'TapTinder::DB::Schema::fsfile', 'fspath_id');
__PACKAGE__->has_many('get_fspath_select', 'TapTinder::DB::Schema::fspath_select', 'fspath_id');

package TapTinder::DB::Schema::mslog;

__PACKAGE__->belongs_to('msession_id','TapTinder::DB::Schema::msession','msession_id');

__PACKAGE__->belongs_to('msstatus_id','TapTinder::DB::Schema::msstatus','msstatus_id');


package TapTinder::DB::Schema::msproc_status;

__PACKAGE__->has_many('get_msproc_log', 'TapTinder::DB::Schema::msproc_log', 'msproc_status_id');

package TapTinder::DB::Schema::role;

__PACKAGE__->has_many('get_user_roles', 'TapTinder::DB::Schema::user_roles', 'role_id');

package TapTinder::DB::Schema::msproc;

__PACKAGE__->belongs_to('msession_id','TapTinder::DB::Schema::msession','msession_id');

__PACKAGE__->belongs_to('abort_reason_id','TapTinder::DB::Schema::msproc_abort_reason','abort_reason_id',{join_type => 'left'});

__PACKAGE__->has_many('get_msjob', 'TapTinder::DB::Schema::msjob', 'msproc_id');
__PACKAGE__->has_many('get_msproc_log', 'TapTinder::DB::Schema::msproc_log', 'msproc_id');

package TapTinder::DB::Schema::fsfile;

__PACKAGE__->has_many('get_msjobp_cmd', 'TapTinder::DB::Schema::msjobp_cmd', 'output_id');
__PACKAGE__->has_many('get_msjobp_cmd_outdata_id', 'TapTinder::DB::Schema::msjobp_cmd', 'outdata_id');
__PACKAGE__->belongs_to('fspath_id','TapTinder::DB::Schema::fspath','fspath_id');

__PACKAGE__->has_many('get_fsfile_ext', 'TapTinder::DB::Schema::fsfile_ext', 'archive_id');
__PACKAGE__->has_many('get_fsfile_ext_fsfile_id', 'TapTinder::DB::Schema::fsfile_ext', 'fsfile_id');

package TapTinder::DB::Schema::param_type;

__PACKAGE__->has_many('get_param', 'TapTinder::DB::Schema::param', 'param_type_id');

package TapTinder::DB::Schema::project;

__PACKAGE__->has_many('get_rep', 'TapTinder::DB::Schema::rep', 'project_id');
__PACKAGE__->has_many('get_jobp', 'TapTinder::DB::Schema::jobp', 'project_id');
__PACKAGE__->has_many('get_wui_project', 'TapTinder::DB::Schema::wui_project', 'project_id');
__PACKAGE__->has_many('get_wui_build', 'TapTinder::DB::Schema::wui_build', 'project_id');
__PACKAGE__->has_many('get_wui_test', 'TapTinder::DB::Schema::wui_test', 'project_id');

package TapTinder::DB::Schema::msjobp;

__PACKAGE__->belongs_to('msjob_id','TapTinder::DB::Schema::msjob','msjob_id');

__PACKAGE__->belongs_to('jobp_id','TapTinder::DB::Schema::jobp','jobp_id');

__PACKAGE__->belongs_to('rcommit_id','TapTinder::DB::Schema::rcommit','rcommit_id');

__PACKAGE__->has_many('get_msjobp_cmd', 'TapTinder::DB::Schema::msjobp_cmd', 'msjobp_id');

package TapTinder::DB::Schema::wconf_job;

__PACKAGE__->belongs_to('wconf_session_id','TapTinder::DB::Schema::wconf_session','wconf_session_id');

__PACKAGE__->belongs_to('rep_id','TapTinder::DB::Schema::rep','rep_id');

__PACKAGE__->belongs_to('rep_id','TapTinder::DB::Schema::rep','rep_id');

__PACKAGE__->belongs_to('rref_id','TapTinder::DB::Schema::rref','rref_id',{join_type => 'left'});

__PACKAGE__->belongs_to('job_id','TapTinder::DB::Schema::job','job_id',{join_type => 'left'});


package TapTinder::DB::Schema::msstatus;

__PACKAGE__->has_many('get_mslog', 'TapTinder::DB::Schema::mslog', 'msstatus_id');

package TapTinder::DB::Schema::tskipall_msg;

__PACKAGE__->has_many('get_tfile', 'TapTinder::DB::Schema::tfile', 'tskipall_msg_id');

package TapTinder::DB::Schema::brun;

__PACKAGE__->belongs_to('msjobp_cmd_id','TapTinder::DB::Schema::msjobp_cmd','msjobp_cmd_id');

__PACKAGE__->belongs_to('conf_id','TapTinder::DB::Schema::brun_conf','conf_id');

__PACKAGE__->has_many('get_bfile', 'TapTinder::DB::Schema::bfile', 'brun_id');

package TapTinder::DB::Schema::ibot_log;

__PACKAGE__->belongs_to('ibot_id','TapTinder::DB::Schema::ibot','ibot_id');

__PACKAGE__->belongs_to('ichannel_conf_id','TapTinder::DB::Schema::ichannel_conf','ichannel_conf_id');

__PACKAGE__->belongs_to('rcommit_id','TapTinder::DB::Schema::rcommit','rcommit_id');


package TapTinder::DB::Schema::msjobp_cmd;

__PACKAGE__->belongs_to('msjobp_id','TapTinder::DB::Schema::msjobp','msjobp_id');

__PACKAGE__->belongs_to('jobp_cmd_id','TapTinder::DB::Schema::jobp_cmd','jobp_cmd_id');

__PACKAGE__->belongs_to('status_id','TapTinder::DB::Schema::cmd_status','status_id');

__PACKAGE__->belongs_to('output_id','TapTinder::DB::Schema::fsfile','output_id',{join_type => 'left'});

__PACKAGE__->belongs_to('outdata_id','TapTinder::DB::Schema::fsfile','outdata_id',{join_type => 'left'});

__PACKAGE__->has_many('get_trun', 'TapTinder::DB::Schema::trun', 'msjobp_cmd_id');
__PACKAGE__->has_many('get_brun', 'TapTinder::DB::Schema::brun', 'msjobp_cmd_id');

package TapTinder::DB::Schema::machine;

__PACKAGE__->belongs_to('user_id','TapTinder::DB::Schema::user','user_id');

__PACKAGE__->belongs_to('prev_machine_id','TapTinder::DB::Schema::machine','prev_machine_id',{join_type => 'left'});

__PACKAGE__->has_many('get_machine', 'TapTinder::DB::Schema::machine', 'prev_machine_id');
__PACKAGE__->belongs_to('farm_id','TapTinder::DB::Schema::farm','farm_id',{join_type => 'left'});

__PACKAGE__->has_many('get_wconf_session', 'TapTinder::DB::Schema::wconf_session', 'machine_id');
__PACKAGE__->has_many('get_msession', 'TapTinder::DB::Schema::msession', 'machine_id');

package TapTinder::DB::Schema::ttest;

__PACKAGE__->belongs_to('trun_id','TapTinder::DB::Schema::trun','trun_id');

__PACKAGE__->belongs_to('rtest_id','TapTinder::DB::Schema::rtest','rtest_id');

__PACKAGE__->belongs_to('trest_id','TapTinder::DB::Schema::trest','trest_id');

__PACKAGE__->has_many('get_tdiag_msg', 'TapTinder::DB::Schema::tdiag_msg', 'ttest_id');

package TapTinder::DB::Schema::tdiag_msg;

__PACKAGE__->belongs_to('ttest_id','TapTinder::DB::Schema::ttest','ttest_id');


package TapTinder::DB::Schema::wui_project;

__PACKAGE__->belongs_to('project_id','TapTinder::DB::Schema::project','project_id');


package TapTinder::DB::Schema::brun_conf;

__PACKAGE__->belongs_to('alias_conf_id','TapTinder::DB::Schema::brun_conf','alias_conf_id',{join_type => 'left'});

__PACKAGE__->has_many('get_brun_conf', 'TapTinder::DB::Schema::brun_conf', 'alias_conf_id');
__PACKAGE__->has_many('get_brun', 'TapTinder::DB::Schema::brun', 'conf_id');

package TapTinder::DB::Schema::user_roles;

__PACKAGE__->belongs_to('user_id','TapTinder::DB::Schema::user','user_id');

__PACKAGE__->belongs_to('role_id','TapTinder::DB::Schema::role','role_id');


package TapTinder::DB::Schema::mswatch_log;

__PACKAGE__->belongs_to('msession_id','TapTinder::DB::Schema::msession','msession_id');


package TapTinder::DB::Schema::job;

__PACKAGE__->has_many('get_jobp', 'TapTinder::DB::Schema::jobp', 'job_id');
__PACKAGE__->has_many('get_wconf_job', 'TapTinder::DB::Schema::wconf_job', 'job_id');
__PACKAGE__->has_many('get_msjob', 'TapTinder::DB::Schema::msjob', 'job_id');

package TapTinder::DB::Schema::wui_rref;

__PACKAGE__->belongs_to('rref_id','TapTinder::DB::Schema::rref','rref_id');


package TapTinder::DB::Schema::trun;

__PACKAGE__->belongs_to('trun_status_id','TapTinder::DB::Schema::trun_status','trun_status_id');

__PACKAGE__->belongs_to('msjobp_cmd_id','TapTinder::DB::Schema::msjobp_cmd','msjobp_cmd_id');

__PACKAGE__->has_many('get_tfile', 'TapTinder::DB::Schema::tfile', 'trun_id');
__PACKAGE__->has_many('get_ttest', 'TapTinder::DB::Schema::ttest', 'trun_id');

package TapTinder::DB::Schema::ichannel_conf;

__PACKAGE__->belongs_to('ibot_id','TapTinder::DB::Schema::ibot','ibot_id');

__PACKAGE__->belongs_to('ichannel_id','TapTinder::DB::Schema::ichannel','ichannel_id');

__PACKAGE__->belongs_to('ireport_type_id','TapTinder::DB::Schema::ireport_type','ireport_type_id');

__PACKAGE__->belongs_to('jobp_cmd_id','TapTinder::DB::Schema::jobp_cmd','jobp_cmd_id',{join_type => 'left'});

__PACKAGE__->has_many('get_ibot_log', 'TapTinder::DB::Schema::ibot_log', 'ichannel_conf_id');

package TapTinder::DB::Schema::fspath_select;

__PACKAGE__->belongs_to('fsfile_type_id','TapTinder::DB::Schema::fsfile_type','fsfile_type_id');

__PACKAGE__->belongs_to('rep_id','TapTinder::DB::Schema::rep','rep_id',{join_type => 'left'});

__PACKAGE__->belongs_to('fspath_id','TapTinder::DB::Schema::fspath','fspath_id');


package TapTinder::DB::Schema::ibot;

__PACKAGE__->belongs_to('operator_id','TapTinder::DB::Schema::user','operator_id');

__PACKAGE__->has_many('get_ichannel_conf', 'TapTinder::DB::Schema::ichannel_conf', 'ibot_id');
__PACKAGE__->has_many('get_ibot_log', 'TapTinder::DB::Schema::ibot_log', 'ibot_id');

package TapTinder::DB::Schema::tfile;

__PACKAGE__->belongs_to('trun_id','TapTinder::DB::Schema::trun','trun_id');

__PACKAGE__->belongs_to('rfile_id','TapTinder::DB::Schema::rfile','rfile_id');

__PACKAGE__->belongs_to('tskipall_msg_id','TapTinder::DB::Schema::tskipall_msg','tskipall_msg_id',{join_type => 'left'});


package TapTinder::DB::Schema::rep;

__PACKAGE__->belongs_to('project_id','TapTinder::DB::Schema::project','project_id');

__PACKAGE__->has_many('get_rauthor', 'TapTinder::DB::Schema::rauthor', 'rep_id');
__PACKAGE__->has_many('get_rcommit', 'TapTinder::DB::Schema::rcommit', 'rep_id');
__PACKAGE__->has_many('get_wconf_job', 'TapTinder::DB::Schema::wconf_job', 'rep_id');
__PACKAGE__->has_many('get_wconf_job_rep_id', 'TapTinder::DB::Schema::wconf_job', 'rep_id');
__PACKAGE__->has_many('get_fspath_select', 'TapTinder::DB::Schema::fspath_select', 'rep_id');



package TapTinder::DB::Schema;
use base 'DBIx::Class::Schema';
use strict;
use warnings;

__PACKAGE__->register_class('rref_rcommit', 'TapTinder::DB::Schema::rref_rcommit');

__PACKAGE__->register_class('msproc_abort_reason', 'TapTinder::DB::Schema::msproc_abort_reason');

__PACKAGE__->register_class('wui_test', 'TapTinder::DB::Schema::wui_test');

__PACKAGE__->register_class('wui_build', 'TapTinder::DB::Schema::wui_build');

__PACKAGE__->register_class('rcparent', 'TapTinder::DB::Schema::rcparent');

__PACKAGE__->register_class('rfile', 'TapTinder::DB::Schema::rfile');

__PACKAGE__->register_class('rauthor', 'TapTinder::DB::Schema::rauthor');

__PACKAGE__->register_class('jobp_cmd', 'TapTinder::DB::Schema::jobp_cmd');

__PACKAGE__->register_class('rref', 'TapTinder::DB::Schema::rref');

__PACKAGE__->register_class('rcommit', 'TapTinder::DB::Schema::rcommit');

__PACKAGE__->register_class('user', 'TapTinder::DB::Schema::user');

__PACKAGE__->register_class('msproc_log', 'TapTinder::DB::Schema::msproc_log');

__PACKAGE__->register_class('ichannel', 'TapTinder::DB::Schema::ichannel');

__PACKAGE__->register_class('param', 'TapTinder::DB::Schema::param');

__PACKAGE__->register_class('msession', 'TapTinder::DB::Schema::msession');

__PACKAGE__->register_class('wconf_rref', 'TapTinder::DB::Schema::wconf_rref');

__PACKAGE__->register_class('msabort_reason', 'TapTinder::DB::Schema::msabort_reason');

__PACKAGE__->register_class('msjob', 'TapTinder::DB::Schema::msjob');

__PACKAGE__->register_class('fsfile_type', 'TapTinder::DB::Schema::fsfile_type');

__PACKAGE__->register_class('cmd', 'TapTinder::DB::Schema::cmd');

__PACKAGE__->register_class('trun_status', 'TapTinder::DB::Schema::trun_status');

__PACKAGE__->register_class('sha', 'TapTinder::DB::Schema::sha');

__PACKAGE__->register_class('fsfile_ext', 'TapTinder::DB::Schema::fsfile_ext');

__PACKAGE__->register_class('rpath', 'TapTinder::DB::Schema::rpath');

__PACKAGE__->register_class('bfile', 'TapTinder::DB::Schema::bfile');

__PACKAGE__->register_class('rtest', 'TapTinder::DB::Schema::rtest');

__PACKAGE__->register_class('wconf_session', 'TapTinder::DB::Schema::wconf_session');

__PACKAGE__->register_class('cmd_status', 'TapTinder::DB::Schema::cmd_status');

__PACKAGE__->register_class('farm', 'TapTinder::DB::Schema::farm');

__PACKAGE__->register_class('ireport_type', 'TapTinder::DB::Schema::ireport_type');

__PACKAGE__->register_class('trest', 'TapTinder::DB::Schema::trest');

__PACKAGE__->register_class('jobp', 'TapTinder::DB::Schema::jobp');

__PACKAGE__->register_class('fspath', 'TapTinder::DB::Schema::fspath');

__PACKAGE__->register_class('mslog', 'TapTinder::DB::Schema::mslog');

__PACKAGE__->register_class('msproc_status', 'TapTinder::DB::Schema::msproc_status');

__PACKAGE__->register_class('role', 'TapTinder::DB::Schema::role');

__PACKAGE__->register_class('msproc', 'TapTinder::DB::Schema::msproc');

__PACKAGE__->register_class('fsfile', 'TapTinder::DB::Schema::fsfile');

__PACKAGE__->register_class('param_type', 'TapTinder::DB::Schema::param_type');

__PACKAGE__->register_class('project', 'TapTinder::DB::Schema::project');

__PACKAGE__->register_class('msjobp', 'TapTinder::DB::Schema::msjobp');

__PACKAGE__->register_class('wconf_job', 'TapTinder::DB::Schema::wconf_job');

__PACKAGE__->register_class('msstatus', 'TapTinder::DB::Schema::msstatus');

__PACKAGE__->register_class('tskipall_msg', 'TapTinder::DB::Schema::tskipall_msg');

__PACKAGE__->register_class('brun', 'TapTinder::DB::Schema::brun');

__PACKAGE__->register_class('ibot_log', 'TapTinder::DB::Schema::ibot_log');

__PACKAGE__->register_class('msjobp_cmd', 'TapTinder::DB::Schema::msjobp_cmd');

__PACKAGE__->register_class('machine', 'TapTinder::DB::Schema::machine');

__PACKAGE__->register_class('ttest', 'TapTinder::DB::Schema::ttest');

__PACKAGE__->register_class('tdiag_msg', 'TapTinder::DB::Schema::tdiag_msg');

__PACKAGE__->register_class('wui_project', 'TapTinder::DB::Schema::wui_project');

__PACKAGE__->register_class('brun_conf', 'TapTinder::DB::Schema::brun_conf');

__PACKAGE__->register_class('user_roles', 'TapTinder::DB::Schema::user_roles');

__PACKAGE__->register_class('mswatch_log', 'TapTinder::DB::Schema::mswatch_log');

__PACKAGE__->register_class('job', 'TapTinder::DB::Schema::job');

__PACKAGE__->register_class('wui_rref', 'TapTinder::DB::Schema::wui_rref');

__PACKAGE__->register_class('trun', 'TapTinder::DB::Schema::trun');

__PACKAGE__->register_class('ichannel_conf', 'TapTinder::DB::Schema::ichannel_conf');

__PACKAGE__->register_class('fspath_select', 'TapTinder::DB::Schema::fspath_select');

__PACKAGE__->register_class('ibot', 'TapTinder::DB::Schema::ibot');

__PACKAGE__->register_class('tfile', 'TapTinder::DB::Schema::tfile');

__PACKAGE__->register_class('rep', 'TapTinder::DB::Schema::rep');

1;
