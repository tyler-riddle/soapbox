package Soapbox::Role::Encode::Profile;

use Soapbox::Moose::Role;

requires qw(encode);

has name => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has extension => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

sub encode_master {
    my ($self, $path, $master) = @_;
    my $metadata = $self->make_meta_info($master);
    return $self->encode($path, $master->source, $metadata);
}

sub make_meta_info {
    my ($self, $master) = @_;
    return undef;
}

1;
