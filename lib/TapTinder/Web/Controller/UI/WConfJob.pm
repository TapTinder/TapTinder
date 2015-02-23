package TapTinder::Web::Controller::UI::WConfJob;

# ABSTRACT: TapTinder::Web build results controller.

use base qw/
	TapTinder::Web::ControllerBase
	TapTinder::Web::Data::Job
/;

use strict;
use warnings;

use Clone 'clone';

=head1 DESCRIPTION

Catalyst controller for TapTinder::Web::UI to manipulate wconfjob.

=method wconfjob_data2table

=cut

sub one_machine_wconfjob_data2table_part {
	my ( $self, $on, $machine_id, $reps, $rep_ids_sorted, $jobs, $wconfs ) = @_;

	my @table;

	# Table first row.
	my $th = [
		{
			type => 'th',
			short => 'job name / repo',
			long => 'Name of the job / Git repository'
		}
	];
	foreach my $rep_id ( @$rep_ids_sorted ) {
		my $data = $reps->{ $rep_id };
		push @$th, {
			type => 'th',
			short => "$data->{project_name} $data->{name}"// "rep_id:$data->{id}",
			long => "$data->{name} $data->{repo_url} (rep_id:$data->{id})",
		};
	}
	push @table, $th;

	# Table data.
	foreach my $job_id ( sort keys %$jobs ) {
		my $job = $jobs->{$job_id};
		my $reps_row = [];

		push @$reps_row, {
			short => $job->{name} // "job_id:$job->{id}",
			long => ($job->{descr} // $job->{name}) . " (job_id:$job_id)",
		};

		foreach my $rep_id ( @$rep_ids_sorted ) {
			my $checked;
			if ( defined $on ) {
				$checked = ( $on->{"$machine_id;$job_id;$rep_id"} ? 1 : 0 );
			} else {
				$checked = ( exists $wconfs->{db}{"$machine_id;$job_id;$rep_id"} ? 1 : 0 );
			}
			push @{ $reps_row }, {
				id => "$machine_id;$job_id;$rep_id",
				checked => $checked,
			}
		}
		push @table, $reps_row;
	}

	return @table;
}

sub wconfjob_data2table {
	my ( $self, $data, $on ) = @_;

	my $machines = $data->{machines};
	my $reps = $data->{reps};
	my $rep_ids_sorted = [ sort keys %$reps ];
	my $jobs = $data->{jobs};
	my $wconfs = $data->{wconfs};

	my $table = [];
	my @machine_ids_sorted = ( sort keys %$machines );
	foreach my $machine_id ( @machine_ids_sorted ) {
		my $mdata = $machines->{ $machine_id };
		push @$table, [ {
			colspan => $#$rep_ids_sorted + 2,
			type => 'th',
			short => $mdata->{name} // "machine_id:$mdata->{id}",
			long => "$mdata->{name} (machine_id:$mdata->{id})",
		} ];
		push @$table, $self->one_machine_wconfjob_data2table_part(
			$on, $machine_id, $reps, $rep_ids_sorted, $jobs, $wconfs
		);
	}

	return $table;
}

=method process_form

=cut

sub preprocess_form {
	my ( $self, $db_data, $params ) = @_;

	delete $params->{submit};

	my $on = {};
	my $add = {};
	foreach my $pkey ( keys %$params ) {
		my $pval = $params->{$pkey};
		my ( $err_msg, $machine_id, $job_id, $rep_id ) = $self->preprocess_ids_input_name( $pkey );
		return ( $err_msg, undef ) if $err_msg;

		my $db_key = "$machine_id;$job_id;$rep_id";
		$on->{ $db_key } = 1;
		$add->{ $db_key } = 1 unless $db_data->{ $db_key };
	}
	my $rm = {};
	foreach my $db_key ( keys %$db_data ) {
		$rm->{$db_key} = 1 unless $on->{$db_key};
	}

	return ( undef, $on, $add, $rm );
}

sub save_changes {
	my ( $self, $schema, $add, $rm ) = @_;

	$self->txn_begin($schema);

	foreach my $db_key ( keys %$add ) {
		my ( $machine_id, $job_id, $rep_id ) = split( ';', $db_key );
		$schema->resultset('wconf_job')->create({
			rep_id => $rep_id,
			job_id => $job_id,
			machine_id => $machine_id,
		});
	}

	foreach my $db_key ( keys %$rm ) {
		my ( $machine_id, $job_id, $rep_id ) = split( ';', $db_key );
		$schema->resultset('wconf_job')->search({
			'me.job_id' => $job_id,
			'me.rep_id' => $rep_id,
			'me.machine_id' => $machine_id,
		})->delete_all;
	}

	$self->txn_end($schema);
	return undef;
}

sub process_form {
	my ( $self, $schema, $data, $params ) = @_;

	my ( $err_msg, $on, $add, $rm ) = $self->preprocess_form(
		$data->{wconfs}{db},
		$params
	);
	return ($err_msg,undef) if $err_msg;

	$err_msg = $self->save_changes( $schema, $add, $rm );
	return ($err_msg,$on) if $err_msg;

	return (
		$self->ok_message("Saved OK."),
		$on
	);
}


sub index_setup : PathPart('ui/wconfjob') Chained('/') CaptureArgs(0) { }

=method index

Base index method.

=cut

sub index : PathPart('') Chained('index_setup') Args(0) {
    my ( $self, $c ) = @_;

	my $schema = $c->model('WebDB')->schema;
	my $data = $self->wconfjob_data( $schema );

	my $on;
	if ( $c->request->method eq 'POST' ) {
		( my $msg, $on ) = $self->process_form( $schema, $data, $c->request->params );
		$c->stash->{message} = $msg;
	}

	my $table = $self->wconfjob_data2table( $data, $on );
    $c->stash->{table} = $table;

    #$self->dumper( $c, $data );
    #$self->dumper( $c, $c->stash->{message} );
    #$self->dumper( $c, $table );
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

__PACKAGE__->meta->make_immutable;

1;
