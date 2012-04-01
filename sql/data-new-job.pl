use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec;
use Cwd 'abs_path';


return sub {
    my ( $schema, $delete_all, $data ) = @_;


    my $project_name = 'Parrot';
    my $project_rs = $schema->resultset('project')->single({
        'me.name' => $project_name,
    });
    my $project_id = $project_rs->id;
    print "Project $project_name id $project_id\n";


    my $master_rref_rs = $schema->resultset('rref')->search(
        {
            'me.name' => 'master',
            'rep_id.project_id' => $project_id,
            'rep_id.active' => 1,
        },
        {
            join => { 'rcommit_id' => 'rep_id', },
        }
    );
    my $master_rref_row = $master_rref_rs->next;
    unless ( $master_rref_row ) {
        print "Cant't find 'master' branch/rref for project id $project_id.\n";
        return 0;
    }
    my $master_rref_id = $master_rref_row->id;
    print "Master rref_id $master_rref_id\n";


    my $job_priority = undef;
    unless ( defined $job_priority ) {
        my $rs = $schema->resultset('job')->search();
        my $max_priority = $rs->get_column('priority')->max;
        $job_priority = $max_priority + 1;
        print "new job priority: $job_priority\n";
    }


    # table: job
    my $job_rs = $schema->resultset('job')->create({
        'client_min_ver' => 257,
        'priority' => $job_priority,
        'name' => 'Parrot trun',
        'descr' => 'Parrot make test (upload Test::Harness::Archive).',
    });
    my $job_id = $job_rs->id;
    print "job_id $job_id\n";


    # table: jobp
    my $jobp_rs = $schema->resultset('jobp')->create({
        'job_id' => $job_id,
        'project_id' => $project_id,
        'rorder' => 1,
        'name' => 'sole',
        'descr' => undef,
        'max_age' => 3*24,
        'depends_on_id' => undef,
        'extends' => 0,
    });
    my $jobp_id = $jobp_rs->id;
    print "jobp_id $jobp_id\n";


    # table: jobp_cmd
    $schema->resultset('jobp_cmd')->populate([
        [ qw/ jobp_id rorder cmd_id params / ],

        [  $jobp_id, 1, 1, undef ],
        [  $jobp_id, 2, 2, undef ],
        [  $jobp_id, 3, 4, undef ],
        [  $jobp_id, 4, 5, undef ],
        [  $jobp_id, 5, 6, undef ], # trun
    ]);

    return 1;
};
