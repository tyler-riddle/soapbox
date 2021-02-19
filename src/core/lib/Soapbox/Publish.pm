package Soapbox::Publish;

use Soapbox::Moose;
use MooseX::Marshal;

marshaled formats => (
    is => 'ro',
    isa => 'HashRef',
);

__PACKAGE__->meta->make_immutable;
