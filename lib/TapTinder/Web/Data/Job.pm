package TapTinder::Web::Data::Job;

# ABSTRACT: TapTinder::Web data for jobs.

use strict;
use warnings;
use base 'TapTinder::Web::Data::Base';

=method get_jobs

Return jobs data.

=cut

sub get_jobs {
    my ( $self, $schema ) = @_;

    my $rs = $schema->resultset('jobp')->search(
		undef,
        {
            join => ['job_id', 'project_id', ],
            'select' => [qw/
				me.rorder
				me.jobp_id
				me.name
				me.descr
				me.project_id
				me.rorder
				project_id.name
				job_id.job_id
				job_id.name
				job_id.descr
				job_id.priority

            /],
            'as' => [qw/
				jobp_rorder
				jobp_id
				jobp_name
				jobp_descr
				jobp_project_id
				jobp_rorder
				project_name
				job_id
				job_name
				job_descr
				job_priority
            /],
            order_by => 'job_id.priority, job_id.job_id, me.rorder, me.jobp_id',
        }
    );
    my %data = ();
    while (my $row = $rs->next) {
    	my %rc = $row->get_columns();
    	my $job_id = delete $rc{job_id};
        if ( exists $data{$job_id} ) {
        	delete $rc{job_name};
        	delete $rc{job_descr};
        	delete $rc{job_priority};
        } else {
        	$data{$job_id} = {
        		id => $job_id,
        		name => delete $rc{job_name},
        		descr => delete $rc{job_descr},
        		priority => delete $rc{job_priority},
        		jobp => [],
        	}
        }
        push @{ $data{$job_id}{jobp} }, \%rc;
    }
    return \%data;
}

=method get_wconf_jobs

Return wconf_jobs data.

=cut

sub get_wconf_jobs {
	my ( $self, $schema ) = @_;

	my $rs = $schema->resultset('wconf_job')->search( undef, {
		join => => [
			{ 'rep_id' => 'project_id' },
			'machine_id',
		],
		select => [qw/
			me.job_id
			me.rep_id
			me.machine_id
			machine_id.name
			rep_id.project_id
			project_id.name
		/],
		as => [qw/
			job_id
			rep_id
			machine_id
			machine_name
			project_id
			project_name
		/],
	} );
	my %data;
	while ( my $row = $rs->next ) {
		my %rc = $row->get_columns();
		next unless $rc{job_id};

		my $db_key = join ';', $rc{machine_id}, $rc{job_id}, $rc{rep_id};
		$data{db}{ $db_key } = 1;

		$data{rep_detail}{ $rc{rep_id} }{ $rc{machine_id} } = {
			project_id => $rc{project_id},
			project_name => $rc{project_name},
		} unless exists $data{rep_detail}{ $rc{rep_id} }{ $rc{machine_id} };
	}
	return \%data;
}

=method get_reps

Return reps data.

=cut

sub get_reps {
	my ( $self, $schema ) = @_;

	my $rs = $schema->resultset('rep')->search(
		{ 'me.active' => 1 },
		{
			join => 'project_id',
			select => [qw/ me.rep_id me.name me.github_url me.repo_url me.project_id project_id.name /],
			as     => [qw/ id        name    github_url    repo_url    project_id    project_name    /],
		}
	);
	return $self->rs2data_by_id( $rs );
}

=method get_machines

Return machines data.

=cut

sub get_machines {
	my ( $self, $schema ) = @_;

	my $rs = $schema->resultset('machine')->search(
		{ 'me.disabled' => 0 },
		{
			select => [qw/ me.machine_id me.name /],
			as     => [qw/ id            name    /],
		}
	);
	return $self->rs2data_by_id( $rs );
}

=method wconfjob_data

Return jobs, wconfs and machines data all in one.

=cut

sub wconfjob_data {
    my ( $self, $schema ) = @_;
    return {
		jobs     => $self->get_jobs($schema),
		wconfs   => $self->get_wconf_jobs($schema),
		machines => $self->get_machines($schema),
		reps     => $self->get_reps($schema),
	};
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

1;
