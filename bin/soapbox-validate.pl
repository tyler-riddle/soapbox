#!/usr/bin/env perl

# This file should work with any perl interpreter
# so it can be called by things that don't need
# to have any Soapbox project library directories
# or other resources

use strict;
use warnings;
use v5.10;
use autodie ':all';

use Getopt::Long qw(:config pass_through);

main();

sub main {
    my %opts = parse_argv();
    my @args = @ARGV;
    my @targets;

    if ($opts{jobs}) {
        push(@args, '-j', $opts{jobs});
    }

    if ($opts{wide}) {
        @targets = qw(
            test
            contrib-test
            contrib-ikiwiki-test
            soapbox-test
            soapbox-broadcast-test
            soapbox-core-test
            soapbox-publish-test
            soapbox-media-test
            soapbox-website-test
        );
    } elsif (defined $opts{target}) {
        @targets = ($opts{target});
    } else {
        @targets = ('test');
    }

    foreach my $target (@targets) {
        my $validate_path = $opts{root} . "/${target}-validate";
        CORE::system(
            'soapbox-build-debootstrap',
            @args,
            '--root', $validate_path,
            '--target', $target,
        );

        $? && die "build process did not exit cleanly"
    }
}

sub parse_argv {
    my %opts;

    GetOptions(
        # --jobs is not a valid cmake argument but -j is so -j is parsed
        # here to keep --jobs and -j from making it to cmake
        'jobs|j=i' => \$opts{jobs},
        'wide' => \$opts{wide},
        'root=s' => \$opts{root},
        'target=s' => \$opts{target},
    ) or die "invalid arguments";

    die "root is a required argument" unless defined $opts{root};

    if (defined $opts{wide} && $opts{target}) {
        die "only one of --wide or --target can be specified, not both";
    }

    return %opts;
}
