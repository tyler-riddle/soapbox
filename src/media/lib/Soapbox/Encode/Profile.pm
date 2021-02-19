package Soapbox::Encode::Profile;

use Soapbox::Moose;

with 'Soapbox::Role::Encode::Profile';

sub encode {
    my ($self, $output, $input, $metadata) = @_;
    die "subclass must provide an encode method";
}

1;
