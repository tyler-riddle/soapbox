#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use File::Basename 'dirname';
use Module::Build;

use constant PERL_DEPS_FILE => dirname($0) . '/modules.txt';

main();

sub make_requires {
    open(my $fh, PERL_DEPS_FILE) or die "open(): $!";
    my %deps;

    while(<$fh>) {
        # skip comments and only whitespace
        next if /^\s*#?\s*$/;
        chomp;
        my @parts = split(/\s+/);
        $deps{$parts[0]} = $parts[1];
    }

    return \%deps;
}

sub make_dist_version {
    my $source = dirname($0) . '/../../etc/version';
    open(my $fh, $source) or die "open($source): $!";
    my $version = <$fh> || die "read line: $!";
    $version =~ s/^\s+//g;
    $version =~ s/\s+$//g;
    return $version;
}

sub main {
    my $requires = make_requires();

    my $build = Module::Build->new(
        module_name => 'Soapbox::Media',
        dist_version => make_dist_version(),
        license => 'perl',
        requires => make_requires(),
    );

    return $build->create_build_script;
}
