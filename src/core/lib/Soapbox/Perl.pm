package Soapbox::Perl;

use strictures 2;
use v5.10;
use Import::Into;
use namespace::autoclean;

use Const::Fast;

const our @PERL_IMPORTS => (
    [qw(strictures version 2)],
);

const our @COMMON_IMPORTS => (
    [qw(autodie :all)],
    [qw(Const::Fast)],
    [qw(feature :5.10)],
    [qw(namespace::autoclean)],
    [qw(Carp carp croak confess)]
);

sub import {
    my ($package) = @_;
    my $target = caller();
    $package->import_into($target);
    return;
}

sub import_into {
    my ($package, $target) = @_;

    foreach my $import ($package->make_imports()) {
        my ($import_package, @args) = @$import;
        $import_package->import::into($target, @args);
    }

    return;
}

sub make_imports {
    my ($package) = @_;
    return (@PERL_IMPORTS, @COMMON_IMPORTS);
}

1;
