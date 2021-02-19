package Soapbox::Encode::Profiles;

use Soapbox::Moose;
use Moose::Util::TypeConstraints;
use MooseX::Singleton;
use MooseX::StrictConstructor;
use v5.10;

use Module::Load '';

use Soapbox::Encode::Profile;

coerce 'Soapbox::Encode::Profile'
    => from 'Str'
    => via { get($_) };

has _profiles_by_name => (
    is => 'ro',
    isa => 'HashRef[Soapbox::Encode::Profile]',
    builder => '_build__profiles_by_name',
);

sub _build__profiles_by_name {
    my ($self) = @_;
    return { };
}

sub load {
    my ($package, @profile_packages) = @_;

    foreach my $name (@profile_packages) {
        Module::Load::load($name);
        $name->_add_global_profiles;
    }
}

sub get {
    my ($package, $name) = @_;
    my $by_name = $package->instance->_profiles_by_name;
    die "unknown profile name: $name" unless exists $by_name->{$name};
    return $by_name->{$name};
}

sub add {
    my ($package, $profile) = @_;
    my $name = $profile->name;
    $package->instance->_profiles_by_name->{$name} = $profile;
}

__PACKAGE__->meta->make_immutable;
