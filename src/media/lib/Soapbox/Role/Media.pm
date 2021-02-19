package Soapbox::Role::Media;

use Soapbox::Moose::Role;
use Moose::Exporter;

use Soapbox::Type;

use overload '""' => \&_as_string;

has path => (
    is => 'ro',
    isa => 'Soapbox::Type::File',
    required => 1,
    coerce => 1,
);

sub _as_string {
    my ($self) = @_;
    return $self->path;
}

1;
