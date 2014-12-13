#!/usr/bin/env perl

use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);
use File::Spec::Functions;
use Data::Dumper;

use lib "$RealBin/../lib";

use Git::Repository;
use Git::Repository::LogRaw;

my $ver = $ARGV[0];

my $repo_name;
my $repo_url;

if ( 0 ) {
    $repo_name = 'perl6-spec';
    $repo_url = 'git://github.com/perl6/specs.git';
} elsif ( 1 ) {
    $repo_name = 'rakudo';
    $repo_url = 'git://github.com/rakudo/rakudo.git';
} else {
   $repo_name = 'tt-test-repo1';
   #$repo_name = 'tt-r2';
   $repo_url = undef;
}


my $base_dir = catdir( $FindBin::RealBin, '..', '..' );
my $work_tree = catdir( $base_dir, 'server-repos', $repo_name );
 
print "Config:\n";
print "  work_tree: $work_tree\n";
print "\n";

my $repo = undef;
unless ( -d $work_tree ) {
    print "Cloning '$repo_url' to '$work_tree'.\n";
    $repo = Git::Repository->create( 
        clone => $repo_url => $work_tree,
    );

} else {
    print "Initializing from '$work_tree'.\n";
    $repo = Git::Repository->new( 
        work_tree => $work_tree,
    );
}
print "\n";

#my $version = $repo->version();
#print "Git version: $version\n";    

#my $cmd_pull = $repo->command( 'pull' );


sub debug_cmd {
    my ( $cmd ) = @_;
    
    my @cmd_line = $cmd->cmdline();
    print "\n";
    print "cmdline: '" . join(' ', @cmd_line) . "'\n\n";

    my $out_fh = $cmd->stdout;
    while ( my $line = <$out_fh> ) {
        print $line;
    }

    my $err = $cmd->stderr(); 
    my $err_out = do { local $/; <$err> };
    print "Error:\n  $err_out\n" if $err_out;
}


my $cmd;

if ( 0 ) {
    $cmd = $repo->command( 'log' => '--reverse', '--all', '--pretty=raw', '--raw', '-c', '-t', '--root', '--abbrev=40', '--raw' );
    debug_cmd( $cmd );
    $cmd->close;
}

my $repo_obj = Git::Repository::LogRaw->new( $repo, $ver );

if ( 1 ) {
    my $log = $repo_obj->get_log();

    my $fh;
    open( $fh, '>temp/out-'.$repo_name.'.txt' ) || croak;
    print $fh Dumper( $log );
    close $fh;
}

if ( 0 ) {
    $cmd = $repo->command( 'ls-remote' => 'origin' );
    debug_cmd( $cmd );
    $cmd->close;

    $cmd = $repo->command( 'rev-list' => '--all', '--parents' );
    debug_cmd( $cmd );
    $cmd->close;
}

if ( 1 ) {
    my $refs = $repo_obj->get_refs();
    print Dumper( $refs );
} 

if ( 1 ) {
    #$cmd = $repo->command( 'for-each-ref' => 'refs/remotes' );
    $cmd = $repo->command( 'for-each-ref' );
    debug_cmd( $cmd );
    $cmd->close;
}


=pod

git pull
git log $last_rev..HEAD
git diff --name-only 412b4c3e539e119f5c7a1a6830f3fb8bd06cb332
git diff-tree 412b4c3e539e119f5c7a1a6830f3fb8bd06cb332

git log -t --root --pretty=raw --raw --abbrev=40 --all --reverse  f549796ba46ed4ef19f957ecbbc4813af4aff5bb...

git for-each-ref --perl
git ls-remote origin

=cut
