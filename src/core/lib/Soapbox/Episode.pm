package Soapbox::Episode;

use Soapbox::Moose;
use MooseX::Marshal;

has instance => (
    is => 'ro',
    isa => 'Soapbox::Instance',
    required => 1,
    weak_ref => 1,
);

marshaled title => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

marshaled file_prefix => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_file_prefix',
);

marshaled scheduled => (
    is => 'ro',
    isa => 'Soapbox::Type::DateTime',
);

marshaled season => (
    is => 'ro',
    isa => 'Int',
);

marshaled number => (
    is => 'ro',
    isa => 'Int',
    required => 1,
);

marshaled description => (
    is => 'ro',
    isa => 'Str',
);

marshaled synopsis => (
    is => 'ro',
    isa => 'Str',
);

marshaled published => (
    is => 'ro',
    type => 'Bool',
);

sub _build_file_prefix {
    my ($self) = @_;
    my $prefix = $self->title;

    $prefix =~ s/\s+/ /g;
    $prefix =~ s/ /_/g;
    $prefix =~ s/[^\w\d]//g;

    return $self->as_id . '_' . $prefix;
}

sub as_id {
    my ($self) = @_;

    if (defined $self->season) {
        return(sprintf("S%0.2dE%0.3d", $self->season, $self->number));
    }

    return $self->number;
}

sub as_string {
    my ($self) = @_;
    return $self->as_id . ' ' . $self->title;
}

__PACKAGE__->meta->make_immutable;
