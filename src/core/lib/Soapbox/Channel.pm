package Soapbox::Channel;

use Soapbox::Moose;
use Moose::Util::TypeConstraints;
use MooseX::Marshal;

use Soapbox::Type;

schema_package (
    'Soapbox::Channel::Website',

    homepage => {
        is => 'ro',
        isa => 'Soapbox::Type::URL',
    },

    episodes => {
        is => 'ro',
        isa => 'Soapbox::Type::URL',
    },
);

marshaled name => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

marshaled description => (
    is => 'ro',
    isa => 'Soapbox::Type::Info::Description',
);

marshaled website => (
    is => 'ro',
    isa => 'Soapbox::Channel::Website',
    coerce => 1,
);

marshaled email => (
    is => 'ro',
    isa => 'Soapbox::Type::Email',
);

marshaled poster => (
    is => 'ro',
    isa => 'Soapbox::Type::URL',
);

__PACKAGE__->meta->make_immutable;
