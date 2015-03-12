package TapTinder::Worker::RepRefresh;

# ABSTRACT: TapTinder::Worker::RepRefresh class for updating repository data.

use strict;
use warnings;

use base qw/
	TapTinder::Worker
	TapTinder::Web::Data::Project
	TapTinder::Web::Data::Rep
/;

use DateTime;

use Git::Repository;
use Git::Repository::LogRaw;
use TapTinder::DB;
use Carp qw(carp croak verbose);

=head1 DESCRIPTION

Base of worker to update repository data.

=head2 new

Constructor.

=cut

sub new {
	my ( $class, %args ) = @_;

	my $self = $class->SUPER::new( %args );
	$self->{schema} = $args{schema} || croak "Parameter 'schema' is missing.";
	$self->{project_name} = $args{project_name};
	$self->{steps} = $self->prepare_steps(
		$args{project_name},
		$args{steps_str}
	);
	return $self;
}

sub prepare_steps {
	my ( $self, $project_name, $steps_str ) = @_;

	my $steps = {
		pull => 1,
		commits => 1,
		refs => 1,
	};
	return $steps unless defined $steps_str;

	option_fatal_err("Project name is mandatory if steps were selected.") unless $project_name;

	my @steps_opt = split( /\s*,\s*/, $steps_str );
	option_fatal_err("Error in --step value '$steps_str'.") unless scalar @steps_opt;
	foreach my $step_key ( keys %$steps ) {
		$steps->{$step_key} = 0 ;
	}
	foreach my $step_key ( @steps_opt ) {
		option_fatal_err("Unknown step '$step_key' name.") unless exists $steps->{ $step_key };
		$steps->{ $step_key } = 1;
	}
	return $steps;
}

sub get_db_refs {
	my ( $self, $rep_id ) = @_;

	my $all_rref_rs = $self->{schema}->resultset('rref')->search({
		'rcommit_id.rep_id' => $rep_id,
	}, {
		join => { 'rcommit_id' => 'sha_id', },
		select => [ 'me.rref_id', 'me.active', 'me.fullname', 'sha_id.sha', ],
		as => [ 'rref_id', 'active', 'fullname', 'sha', ],
	});
	my $db_refs = {};
	while ( my $row = $all_rref_rs->next ) {
		$db_refs->{ $row->get_column('fullname') } = { $row->get_columns };
	}
	return $db_refs;
}

sub update_rref_rcommit {
	my ( $self, $rref_rcommit_rs, $rcparents, $rcommits_time, $rep_id, $rref_id, $rref_rcommit_id ) = @_;
	my $vl = $self->{vl};

	print "Updating rref_rcommits for rref_id $rref_id (rcommit_id $rref_rcommit_id).\n"  if $vl >= 4;

	my $num = 0;
	my $new_list = {};
	my $act_rcommit = $rref_rcommit_id;
	SEARCH_RREF: while (1) {

		if ( ref $act_rcommit ) {
			#print "act_rcommit "; print $self->dmp( $act_rcommit );

			# Find max committer_time.
			my $max_rcommit_id = undef;
			my $max_ts = 0;
			foreach my $rcommit_id ( keys %$act_rcommit ) {
				my $commit_ts = $rcommits_time->{ $rcommit_id };
				if ( $commit_ts > $max_ts ) {
					$max_ts = $commit_ts;
					$max_rcommit_id = $rcommit_id;
				}
			}
			$new_list->{ $max_rcommit_id } = 1;
			delete $act_rcommit->{ $max_rcommit_id };

			if ( ref $rcparents->{ $max_rcommit_id } ) {
				foreach my $tmp_rcommit_id ( @{$rcparents->{$max_rcommit_id}} ) {
					next if exists $new_list->{ $tmp_rcommit_id };
					next if exists $act_rcommit->{ $tmp_rcommit_id };
					$act_rcommit->{ $tmp_rcommit_id } = 1;
				}

			} else {
				my $tmp_rcommit_id = $rcparents->{ $max_rcommit_id };
				if (    (defined $tmp_rcommit_id)
					 && (not exists $new_list->{$tmp_rcommit_id})
					 && (not exists $act_rcommit->{$tmp_rcommit_id})
				   )
				{
					$act_rcommit->{ $tmp_rcommit_id } = 1;
				}
			}

			last SEARCH_RREF unless scalar keys %$act_rcommit;

		} else {
			last SEARCH_RREF unless defined $act_rcommit;
			my $rcommit_id = $act_rcommit;

			$new_list->{ $rcommit_id } = 1;
			if ( ref $rcparents->{ $rcommit_id } ) {
				$act_rcommit = {};
				for my $key ( @{ $rcparents->{$rcommit_id} } ) {
					$act_rcommit->{ $key } = 1;
				}
			} else {
				last SEARCH_RREF unless exists $rcparents->{ $rcommit_id };
				$act_rcommit = $rcparents->{ $rcommit_id };
			}
		}
		$num++;

		last if $num >= 100;


	}
	#print $self->dmp( $new_list );

	my $this_rref_rcommits_rs = $rref_rcommit_rs->search({
		'rref_id' => $rref_id,
		'rcommit_id.rep_id' => $rep_id,
	}, {
		'join' => 'rcommit_id',
		'select' => [ 'me.rcommit_id', ],
		'as' => [ 'rcommit_id', ],
	});

	my $act_data = {};
	while ( my $rref_rcommit_row = $this_rref_rcommits_rs->next ) {
		my $rcommit_id = $rref_rcommit_row->get_column('rcommit_id');
		unless ( exists $new_list->{$rcommit_id} ) {
			#$rref_rcommit_rs->find( $rref_id, $rcommit_id )->delete;
			$rref_rcommit_rs->search({
				rref_id => $rref_id,
				rcommit_id => $rcommit_id,
			})->delete;
		} else {
			delete $new_list->{ $rcommit_id };
		}
	}
	#print $self->dmp( $new_list );

	foreach my $rcommit_id ( keys %$new_list ) {
		$rref_rcommit_rs->create({
			rref_id => $rref_id,
			rcommit_id => $rcommit_id,
		});
	}

	return 1;
}

sub update {
	my ( $self, $project_name, $repo_url, $rep_id ) = @_;
	my $vl = $self->{vl};
	my $schema = $self->{schema};
	my $steps = $self->{steps};

	my $start_time = time();
	print "Starting repository update for project '$project_name'.\n" if $vl >= 2;
	print "repo_url: '$repo_url', rep_id: $rep_id\n" if $vl >= 3;

	my $base_repos_dir = $ENV{'TAPTINDER_REPOS_DIR'} || File::Spec->catdir( $FindBin::RealBin, '..', '..' );
	my $work_tree = File::Spec->catdir( $base_repos_dir, $project_name );
	my $state_fn = File::Spec->catfile( $base_repos_dir, $project_name . '-state.pl' );

	my $state;

	if ( -e $state_fn ) {
		$state = require $state_fn;
		if ( $project_name ne $state->{project_name} ) {
			print "Loaded state conf for project '$state->{project_name}', but your project name is '$project_name'" if $vl >= 3;;
		}
		print "State file loaded.\n" if $vl >= 3;

	} else {
		$state = {};
		$state->{project_name} = $project_name;
		$state->{create_time} = time();
		$self->save_state( $state, $state_fn );
		print "State file created.\n" if $vl >= 3;
	}


	my $repo = undef;
	unless ( -d $work_tree ) {
		print "Cloning '$repo_url' to '$work_tree'.\n" if $vl >= 3;
		mkdir( $work_tree) || croak "Can't create '$work_tree' direcotry: $!\n";
		Git::Repository->run(
			clone => '--mirror', $repo_url, $work_tree
		);
		$repo = Git::Repository->new( work_tree => $work_tree );

	} else {
		print "Initializing from '$work_tree'.\n" if $vl >= 3;
		$repo = Git::Repository->new(
			git_dir => $work_tree,
		);
		if ( $steps->{pull} ) {
			print "Running 'git pull'.\n" if $vl >= 2;
			my $cmd = $repo->command( 'pull' => '--all' );
			$cmd = $repo->command( 'remote' => 'update' );

			#print join( ' ', $cmd->cmdline() ) . "\n";
			#my $stdout = $cmd->stdout();
			#print $_ while (<$stdout>);
			#my $stderr = $cmd->stderr();
			#print $_ while (<$stderr>);
			#$cmd->close();
		}
	}

	my $gitrepo_obj = Git::Repository::LogRaw->new( $repo, $vl );

	print "Starting transaction.\n" if $vl >= 3;
	$schema->storage->txn_begin;

	my $all_ok = 1;

	my $rcommit_rs = $schema->resultset('rcommit')->search(
		{},
		{
			join => 'sha_id',
			'select' => [ 'me.rcommit_id', 'sha_id.sha', 'me.parent_id', 'me.parents_num', \'unix_timestamp(me.committer_time)', ],
		}
	);
	my $rcommits_sha_list = {};
	my $rcparents = {};
	my $rcommits_time = {};
	foreach my $rcommit_row ( $rcommit_rs->cursor->all ) {
		my ( $rcommit_id, $sha, $parent_id, $parents_num, $time_ts ) = @$rcommit_row;
		$rcommits_sha_list->{ $sha } = $rcommit_id;
		$rcommits_time->{ $rcommit_id } = $time_ts;
		if ( defined $parent_id ) {
			$rcparents->{ $rcommit_id } = $parent_id;
		}
	}
	# print "rcommits_time\n"; print $self->dmp( $rcommits_time );


	my $rcparent_rs = $schema->resultset('rcparent')->search( {}, {
		'select' => [ 'me.child_id', 'me.parent_id', 'me.num', ],
	} );
	foreach my $rcparent_row ( $rcparent_rs->cursor->all ) {
		my $child_id = $rcparent_row->[0];
		my $parent_id = $rcparent_row->[1];
		my $num = $rcparent_row->[2];
		# Changing sclar value to array ref.
		unless ( ref $rcparents->{ $child_id } ) {
			$rcparents->{ $child_id } = [ $rcparents->{ $child_id } ];
		}
		$rcparents->{ $child_id }->[ $num ] = $parent_id;
	}
	#print $self->dmp( $rcparents ) if $vl >= 6;


	my $commits_added_num = 0;
	my $err = [];
	if ( $steps->{commits} ) {
		print "Adding new commits.\n" if $vl >= 2;

		print "Loading log.\n" if $vl >= 3;
		my $log = $gitrepo_obj->get_log(
			$rcommits_sha_list,  # $ssh_skip_list
			all => 1,
		);
		print "Found " . (scalar @$log) . " new commit log items.\n" if $vl >= 3;
		#print $self->dmp( $log );

		my $rcommit_rs = $schema->resultset('rcommit');
		my $sha_rs = $schema->resultset('sha');
		my $rauthor_rs = $schema->resultset('rauthor');
		my $rcparent_rs = $schema->resultset('rcparent');
		my $new_rcommits_num = 0;
		LOG_COMMIT: foreach my $log_num ( 0..$#$log ) {
			my $log_commit = $log->[ $log_num ];
			#last if $log_num > $#$log / 2; # debug

			my $rcommit_sha = $log_commit->{commit};
			next if exists $rcommits_sha_list->{ $rcommit_sha };

			print "Log msg '$log_commit->{msg}'\n" if $vl >= 5;

			my $first_parent_sha = undef;
			my $first_parent_rcommit_id = undef;
			if ( defined $log_commit->{parents}->[0] ) {
			   $first_parent_sha = $log_commit->{parents}->[0];
			   unless ( exists $rcommits_sha_list->{$first_parent_sha} ) {
				  push @$err, "First parent rcommit_id not found in sha_lit for sha '$first_parent_sha'.";
				  $all_ok = 0;
				  last LOG_COMMIT;
			   }
			   $first_parent_rcommit_id = $rcommits_sha_list->{ $first_parent_sha };
			}

			my $rcommit_sha_id = $sha_rs->create({
				sha => $rcommit_sha,
			})->id;

			my $tree_sha_id = $sha_rs->find_or_create({
				sha => $log_commit->{tree},
			})->id;

			my $author_id = $rauthor_rs->find_or_create({
				rep_login => $log_commit->{author}->{name},
				email => $log_commit->{author}->{email},
				rep_id => $rep_id,
			})->id;

			my $committer_id = $rauthor_rs->find_or_create({
				rep_login => $log_commit->{committer}->{name},
				email => $log_commit->{committer}->{email},
				rep_id => $rep_id,
			})->id;


			my $parents = $log_commit->{parents};
			my $num_of_parents = scalar @$parents;
			my $rcommit_row = $rcommit_rs->create({
				rep_id => $rep_id,
				msg => $log_commit->{msg},
				sha_id => $rcommit_sha_id,
				tree_id => $tree_sha_id,
				parents_num => $num_of_parents,
				parent_id => $first_parent_rcommit_id,
				author_id => $author_id,
				author_time => DateTime->from_epoch(
					epoch => $log_commit->{author}->{gmtime},
					time_zone => 'GMT',
				),
				committer_id => $committer_id,
				committer_time => DateTime->from_epoch(
					epoch => $log_commit->{committer}->{gmtime},
					time_zone => 'GMT',
				),
			});
			my $rcommit_id = $rcommit_row->id;
			$rcommits_sha_list->{ $rcommit_sha } = $rcommit_id;
			$rcommits_time->{ $rcommit_id } = $log_commit->{author}->{gmtime};
			if ( $num_of_parents <= 1 ) {
				$rcparents->{ $rcommit_id } = $first_parent_rcommit_id;
			} else {
				$rcparents->{ $rcommit_id } = [ $first_parent_rcommit_id ];
			}


			if ( $num_of_parents >= 2 ) {
				foreach my $parent_num ( 1..$#$parents ) {
					my $parent_sha = $parents->[ $parent_num ];
					unless ( exists $rcommits_sha_list->{ $parent_sha } ) {
						push @$err, "Parent rcommit_id not found in sha_lit for sha '$parent_sha'.";
						$all_ok = 0;
						last LOG_COMMIT;
					}
					my $parent_rcommit_id = $rcommits_sha_list->{ $parent_sha };

					# skip first parent
					$rcparent_rs->create({
						child_id => $rcommit_id,
						parent_id => $parent_rcommit_id,
						num => $parent_num,
					});
					$rcparents->{ $rcommit_id }->[ $parent_num ] = $parent_rcommit_id;
				}
			}

			if ( $new_rcommits_num >= 1000 ) {

				print "Commiting transaction.\n" if $vl >= 3;
				$schema->storage->txn_commit;
				print "Already added $commits_added_num commits.\n" if $vl >= 3;

				print "Starting new transaction.\n" if $vl >= 3;
				$schema->storage->txn_begin;

				$new_rcommits_num = 0;
			}
			$new_rcommits_num++;

			$commits_added_num++;
		} # end foreach

		print "Added $commits_added_num new commits.\n" if $vl >= 3;

	} # end if
	print $self->dmp( $rcparents ) if $vl >= 6;


	my $rref_updated_num = 0;
	my $rref_removed_num = 0;
	if ( $all_ok && $steps->{refs} ) {
		print "Doing refs update.\n" if $vl >= 2;
		# Hash $db_refs is used to cache DB values. Used keys are removed during processiong
		# repository refs. Then remainning keys are used to deactivate refs in db.
		my $db_refs = $self->get_db_refs( $schema, $rep_id );
		print $self->dmp( $db_refs ) if $vl >= 5;

		my $repo_refs = $gitrepo_obj->get_refs( 'remote_ref' );
		print $self->dmp( $repo_refs ) if $vl >= 5;

		my $rcommit_rs = $schema->resultset('rcommit');
		my $rref_rs = $schema->resultset('rref');
		my $rref_rcommit_rs = $schema->resultset('rref_rcommit');
		REF_LIST: foreach my $ref_key ( keys %$repo_refs ) {
			my $ref_info = $repo_refs->{ $ref_key };
			my $ref_sha = $ref_info->{sha};
			my $ref_fullname = $ref_info->{fullname};

			# rref with this name already exists
			if ( exists $db_refs->{$ref_key} ) {
				if ( $db_refs->{$ref_key} eq $ref_sha && $db_refs->{$ref_key}->{active} ) {
					print "Ref '$ref_key' not changed.\n" if $vl >= 5;

				} else {
					my $rref_id = $db_refs->{$ref_key}->{rref_id};
					unless ( exists $rcommits_sha_list->{ $ref_sha } ) {
						push @$err, "Can't find rcommit_id for sha '$ref_sha' in sha_list.";
						$all_ok = 0;
						last REF_LIST;
					}
					my $rcommit_id = $rcommits_sha_list->{ $ref_sha };
					my $row = $rref_rs->find( $rref_id );
					$row->update({
						active => 1,
						rcommit_id => $rcommit_id,
					});
					print "Activating/updating ref '$ref_key'.\n" if $vl >= 4;
					$rref_updated_num++;
					$self->update_rref_rcommit( $rref_rcommit_rs, $rcparents, $rcommits_time, $rep_id, $rref_id, $rcommit_id );
				}
				delete $db_refs->{$ref_key};
				next REF_LIST;
			}

			unless ( exists $rcommits_sha_list->{ $ref_sha } ) {
				push @$err, "Can't find rcommit_id for sha '$ref_sha' in sha_list.";
				$all_ok = 0;
				last REF_LIST;
			}
			my $rcommit_id = $rcommits_sha_list->{ $ref_sha };
			my $new_rref_row = $rref_rs->create(
				{
					fullname => $ref_key,
					name => $ref_info->{branch_name},
					rcommit_id => $rcommit_id,
					active => 1,
				}
			);
			my $rref_id = $new_rref_row->id;
			print "Creating '$ref_key'.\n" if $vl >= 4;
			$rref_updated_num++;
			$self->update_rref_rcommit( $rref_rcommit_rs, $rcparents, $rcommits_time, $rep_id, $rref_id, $rcommit_id );
		}
		print "Updated $rref_updated_num refs.\n" if $vl >= 3;

		#print $self->dmp( $db_refs );
		foreach my $ref_key ( keys %$db_refs ) {
			next unless $db_refs->{ $ref_key }->{active};
			my $rref_id = $db_refs->{ $ref_key }->{rref_id};
			my $row = $rref_rs->find( $rref_id );
			print "Deactivating '$ref_key'.\n" if $vl >= 4;
			$row->update({active => 0});
			$rref_rcommit_rs->search({ rref_id => $rref_id })->delete;
			$rref_removed_num++;
		}

		print "Deactivated $rref_removed_num refs.\n" if $vl >= 3;

		$db_refs = $self->get_db_refs( $schema, $rep_id );
		print $self->dmp( $db_refs ) if $vl >= 5;

	} # end if


	my $some_rref_change = ( $rref_updated_num != 0 || $rref_removed_num != 0 );
	my $some_change = ( $some_rref_change || $commits_added_num != 0 );
	if ( $vl >= 2 && !$some_change ) {
		print "Nothing to do.\n";
	}

	if ( $all_ok ) {
		print "Doing commit.\n" if $vl >= 3;
		$schema->storage->txn_commit;

	} else {
		print "Doing rollback.\n" if $vl >= 2;
		if ( $vl >= 1 ) {
			print "Error mesages:\n";
			print join("\n", @$err );
			print "\n";
		}
		$schema->storage->txn_rollback;
	}

	$self->save_state( $state, $state_fn );
	my $time_diff = time() - $start_time;
	print "Updating project '$project_name' take ${time_diff}s to run.\n" if $vl >= 3;
}

sub run {
	my ( $self ) = @_;

	my $search = undef;
	if ( $self->{project_name} ) {
		$search = {
			name => $self->{project_name}
		};
	}
	my $projs = $self->project_data( $self->{schema}, undef, $search );

	foreach my $project_data ( values %$projs ) {
		my $rep_data = $self->rep_data(
				$self->{schema},
				$project_data->{id}
		);

		my $rep_id = (keys %$rep_data)[0];
		$self->update(
			$project_data->{name},
			$rep_data->{$rep_id}{github_url},
			$rep_data->{$rep_id}{id}
		);
	}
}

=head1 SEE ALSO

L<TapTinder::Worker>

=cut

1;