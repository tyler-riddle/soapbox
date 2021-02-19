package Soapbox::Encode::Master;

use Soapbox::Moose;
use Moose::Util::TypeConstraints;

use Soapbox::Media;
use Soapbox::Type;

coerce 'Soapbox::Encode::Master'
    => from 'HashRef'
    => via { Soapbox::Encode::Master->new(%$_) };

coerce 'Soapbox::Encode::Master'
    => from 'Str'
    => via { Soapbox::Encode::Master->new(source => $_) };

has source => (
    is => 'ro',
    does => 'Soapbox::Role::Media',
    required => 1,
);

has poster => (
    is => 'ro',
    isa => 'Soapbox::Type::File',
    coerce => 1,
);

has episode => (
    is => 'ro',
    isa => 'Soapbox::Episode',
);

around BUILDARGS => sub {
    my ($orig, $class, %args) = @_;

    if (exists $args{source} && ref($args{source}) eq '') {
        $args{source} = media($args{source});
    }

    return $class->$orig(%args);
};

__PACKAGE__->meta->make_immutable;
