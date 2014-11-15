#! perl

use strict;
use warnings;
use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use Getopt::Long;
use Pod::Usage;

use File::Spec::Functions;
use YAML;
use DBI;
use Digest::MD5 qw(md5);

my $help = 0;
my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $server_conf_fpath = catfile($conf_dir, 'web_db.yml');

# part A) new passwd
my $machine_id = undef;
my $machine_name = undef;
my $client_new_passwd = undef;

# part B) client conf file
my $client_conf_fpath = undef;
my $client_section_name = undef;

# part C) own client's passwd list
my $client_passwd_list_fpath = undef;

my $options_ok = GetOptions(
    'help|h|?' => \$help,
    'server_conf_fpath=s' => \$server_conf_fpath,

    # part A)
    'machine_id|mid=i' => \$machine_id,
    'machine_name|mn=s' => \$machine_name,
    'passwd|p=s' => \$client_new_passwd,

    # part B)
    'client_conf_fpath:s' => \$client_conf_fpath,
    'client_section_name|csn=s' => \$client_section_name,

    # part C)
    'client_passwd_list:s' => \$client_passwd_list_fpath,
);


# default values
# part B)
if ( defined $client_conf_fpath && !$client_conf_fpath ) {
    $client_conf_fpath = catfile( $RealBin, '..', '..', 'client-conf', 'client-conf.yml' );
    if ( !$client_section_name ) {
        $client_section_name = 'prod';
    }
}

# part C)
if ( defined $client_passwd_list_fpath && !$client_passwd_list_fpath ) {
    $client_passwd_list_fpath = catfile( $RealBin, '..', 'conf', 'client-passwds.yml' );
}


# part mismatch, no empty values exists
my $part_a = 0;
$part_a = 1 if $machine_id || $machine_name || $client_new_passwd;

my $part_b = 0;
$part_b = 1 if $client_conf_fpath || $client_section_name;

my $part_c = 0;
$part_c = 1 if $client_passwd_list_fpath;

my $part_sum = $part_a + $part_b + $part_c;
if ( $part_sum > 1 ) {
    croak "Config mismatch. Try to use only one part of config options.\n";
}

pod2usage(1) if $help || !$options_ok || !$part_sum;


my @client_passwds = ();

# part A)
if ( $part_a ) {
    croak "You can't set both machine_id and machine_name." if $machine_id && $machine_name;
    croak "Option machine_id or machine_name is mandatory here.\n" if !$machine_id && !$machine_name;
    croak "Option client_new_passwd is mandatory here.\n" if !$client_new_passwd;
    if ( $machine_id ) {
        push @client_passwds, { id => $machine_id, passwd => $client_new_passwd };
    # machine_name
    } else {
        push @client_passwds, { name => $machine_name, passwd => $client_new_passwd };
    }

}

if ( $part_b ) {
    # load client data from configuration file
    croak "Can't find client configuration file '$client_conf_fpath'.\n" unless -f $client_conf_fpath;
    my ( $all_client_conf ) = YAML::LoadFile( $client_conf_fpath );
    unless ( exists $all_client_conf->{$client_section_name} ) {
        croak "Project '$client_section_name' configuration section not found inside client config file '$client_conf_fpath'."
    }
    my $client_conf = $all_client_conf->{$client_section_name};
    push @client_passwds, {
        id => $client_conf->{machine_id},
        passwd => $client_conf->{machine_passwd},
    };
}


if ( $part_c ) {
    croak "Can't find clients passwords configuration file '$client_passwd_list_fpath'.\n" unless -f $client_passwd_list_fpath;
    my ( $client_passwd_list ) = YAML::LoadFile( $client_passwd_list_fpath );
    my $num = 1;
    foreach my $client_conf ( @$client_passwd_list ) {
        #use Data::Dumper; croak Dumper( $conf );
        croak "Can't find machine_id key definition for client number $num.\n" unless $client_conf->{machine_id};
        croak "Can't find machine_passwd key definition for client number $num.\n" unless $client_conf->{machine_passwd};
        push @client_passwds, {
            id => $client_conf->{machine_id},
            passwd => $client_conf->{machine_passwd},
        };
        $num++;
    }
}

croak "Can't find server configuration file '$server_conf_fpath'.\n" unless -f $server_conf_fpath;
my ( $server_conf ) = YAML::LoadFile( $server_conf_fpath );
croak "Configuration for database loaded from '$server_conf_fpath' is empty.\n" unless $server_conf->{db};

my $dbh = DBI->connect(
    $server_conf->{db}->{dbi_dsn},
    $server_conf->{db}->{user},
    $server_conf->{db}->{pass},
    { RaiseError => 1, AutoCommit => 0 }
) or croak $DBI::errstr;


# Not optimized yet. New SQL and Prepare each time.
foreach my $conf ( @client_passwds ) {
    my $client_new_passwd_digest = substr( md5($conf->{passwd}), -8 );
    my @bv = ( $client_new_passwd_digest );
    my $sql = 'UPDATE machine SET passwd=? WHERE ';
    my $info_msg = "Password set for ";
    if ( exists $conf->{id} ) {
        $info_msg .= 'machine.machine_id=' . $conf->{id};
        $sql .= 'machine_id=?';
        push @bv, $conf->{id};
    } elsif ( $conf->{name} ) {
        $info_msg .= 'machine.name=' . $conf->{name};
        $sql .= 'name=?';
        push @bv, $conf->{name};
    } else {
        croak "Nor ID or Name  found.\n";
    }
    $info_msg .= ".\n";
    my $sth = $dbh->prepare($sql);
    $sth->execute( @bv );
    # TODO
    #print $DBI::errstr;

    $dbh->commit;

    print $info_msg;
}

$dbh->disconnect;

__END__

=head1 NAME

set_client_passwd - Set client password inside server database.

=head1 SYNOPSIS

perl set_client_passwd.pl [options]

Examples:

perl set_client_passwd.pl --machine_id=6 --passwd=hsd233h

perl set_client_passwd.pl --client_conf_fpath
perl set_client_passwd.pl --client_conf_fpath=../../client-conf/client-conf.yml

perl set_client_passwd.pl --client_passwd_list
perl set_client_passwd.pl --client_passwd_list=../conf/client-passwds.yml

Options:
   --help
   --server_conf_fpath

   # part A - Set client password manualy.
   --machine_id
   --machine_name
   --passwd

   # part B - Loads client configuration file and sets client (machine) password to database.
   --client_conf_fpath
   --config_section_name ... Configuration section name. Default 'prod'.

   # part C - Set clients passwords using own configuration file.
   --client_passwd_list - yaml file with passwds for clients

=head1 DESCRIPTION

B<This program> will set password ...

=cut
