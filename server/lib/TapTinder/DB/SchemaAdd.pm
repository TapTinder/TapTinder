package TapTinder::DB::SchemaAdd;

use base 'TapTinder::DB::Schema';


# Own resultsets:

package TapTinder::DB::Schema::msjobp_cmd;

my $source5 = __PACKAGE__->result_source_instance();
my $new_source5 = $source5->new( $source5 );
$new_source5->source_name( 'NotLoadedTruns' );

$new_source5->name(\<<'SQLEND');
(
select mjpc.msjobp_cmd_id,
       fsp.path as file_path,
       fsf.name as file_name,
       mjp.rev_id,
       r.rev_num,
       jp.rep_path_id
 from msjobp_cmd mjpc,
      jobp_cmd jpc,
      fsfile fsf,
      fspath fsp,
      msjobp mjp,
      rev r,
      msjob mj,
      jobp jp
where mjpc.outdata_id is not null
  and jpc.jobp_cmd_id = mjpc.jobp_cmd_id
  and jpc.cmd_id = 6 -- trun
    and not exists (
    select 1
      from trun tr
     where tr.msjobp_cmd_id = mjpc.msjobp_cmd_id
  )
  and fsf.fsfile_id = mjpc.outdata_id
  and fsp.fspath_id = fsf.fspath_id
  and mjp.msjobp_id = mjpc.msjobp_id
  and r.rev_id = mjp.rev_id
  and mj.msjob_id = mjp.msjob_id
  and jp.jobp_id = mjp.jobp_id
order by mjpc.msjobp_cmd_id desc
)
SQLEND

TapTinder::DB::Schema->register_extra_source( 'NotLoadedTruns' => $new_source5 );



package TapTinder::DB::Schema::rpath;

my $source6 = __PACKAGE__->result_source_instance();
my $new_source6 = $source5->new( $source6 );
$new_source6->source_name( 'ActiveRepPathList' );

$new_source6->name(\<<'SQLEND');
(
   SELECT rp.*,
          mr.max_rev_num,
          r.rev_id, r.author_id, r.date,
          ra.rep_login
     FROM rep_path rp,
        ( SELECT rrp.rep_path_id, max(r.rev_num) as max_rev_num
           FROM rev_rep_path  rrp, rev r
          WHERE r.rev_id = rrp.rev_id
          GROUP BY rrp.rep_path_id
        ) mr,
        rev r,
        rep_author ra
    WHERE rp.rep_id = ?
      and rp.rev_num_to is null -- optimalization
      and rp.path not like "tags/%"
      and mr.rep_path_id = rp.rep_path_id
      and r.rev_num = mr.max_rev_num
      and ra.rep_author_id = r.author_id
    ORDER BY max_rev_num DESC
)
SQLEND

TapTinder::DB::Schema->register_extra_source('ActiveRepPathList' => $new_source6);


# ViewMD - view metadata

package TapTinder::DB::Schema::machine;
__PACKAGE__->cwm_conf( {
    auth => {
        'passwd' => 'R',
        'ip' => 'R',
    },
} );


package TapTinder::DB::Schema::msession;
__PACKAGE__->cwm_conf( {
    auth => {
        'key' => 'R',
        'pid' => 'R',
    },
} );


package TapTinder::DB::Schema::msjob;
__PACKAGE__->cwm_conf( {
     max_deep => 2,
} );


package TapTinder::DB::Schema::msjobp;
__PACKAGE__->cwm_conf( {
     max_deep => 2,
} );


package TapTinder::DB::Schema::mslog;
__PACKAGE__->cwm_conf( {
     max_deep => 1,
} );


package TapTinder::DB::Schema::msstatus;
__PACKAGE__->cwm_conf( {
    col_type => {
        'name' => 'G',
    },
} );


package TapTinder::DB::Schema::msproc_log;
__PACKAGE__->cwm_conf( {
     max_deep => 1,
} );


package TapTinder::DB::Schema::rauthor;
__PACKAGE__->cwm_conf( {
    col_type => {
        'rep_login' => 'S',
        'email' => 'S',
    },
} );


package TapTinder::DB::Schema::rcparent;
__PACKAGE__->cwm_conf( {
     max_deep => 1,
} );


package TapTinder::DB::Schema::rref_rcommit;
# ToDo SQL::Translator...
__PACKAGE__->set_primary_key('rref_id', 'rcommit_id');
__PACKAGE__->add_unique_constraint(
    'primary' => [ qw/ rref_id rcommit_id / ],
);

__PACKAGE__->cwm_conf( {
     max_deep => 1,
} );


package TapTinder::DB::Schema::sha;
__PACKAGE__->cwm_conf( {
    col_type => {
        'sha' => 'S',
    },
} );


package TapTinder::DB::Schema::rfile;
__PACKAGE__->cwm_conf( {
    col_type => {
        'sub_path' => 'G',
    },
} );


package TapTinder::DB::Schema::rtest;
__PACKAGE__->cwm_conf( {
    col_type => {
        'number' => 'G',
    },
} );


package TapTinder::DB::Schema::user;
__PACKAGE__->cwm_conf( {
    auth => {
        'passswd' => 'R',
    },
} );


1;
