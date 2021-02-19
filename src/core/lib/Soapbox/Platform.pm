package Soapbox::Platform;

use Soapbox::Moose;
use MooseX::Marshal;

use Soapbox::Type;

has instance => (
    is => 'ro',
    isa => 'Soapbox::Instance',
    required => 1,
);

marshaled name => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

marshaled display => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

marshaled media => (
    is => 'ro',
    isa => 'Soapbox::Type::URL',
);

marshaled channel => (
    is => 'ro',
    isa => 'Soapbox::Type::URL',
);

__PACKAGE__->meta->make_immutable;
