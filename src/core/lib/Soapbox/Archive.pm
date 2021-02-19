package Soapbox::Archive;

use Soapbox::Moose;
use Moose::Util::TypeConstraints;
use MooseX::Marshal;

use Soapbox::Type;

use constant ARCHIVE_PLATFORM_NAME => 'soapbox-archive';

subtype 'Soapbox::Archive::EntryHash'
    => as 'HashRef[HashRef[Soapbox::Archive::Entry]]';

schema_package (
    'Soapbox::Archive::Entry',

    id => {
        is => 'ro',
        isa => 'Str',
        required => 1,
    },

    location => {
        is => 'ro',
        isa => 'Soapbox::Type::URL',
        required => 1,
    },

    platform => {
        is => 'ro',
        isa => 'Str',
        default => 'soapbox-archive',
    },

    label => {
        is => 'ro',
        isa => 'Str',
        required => 1,
    },
);

coerce 'Soapbox::Archive::EntryHash'
    => from 'HashRef'
    => via {
            my $hash_in = $_;
            my %hash_out;
            foreach my $episode_id (keys %$hash_in) {
                my $entries = $hash_in->{$episode_id};
                $hash_out{$episode_id} = { map { $_->{label}, Soapbox::Archive::Entry->new(%$_, id => $episode_id) } @$entries };
            }
            return \%hash_out;
        };

has instance => (
    is => 'ro',
    isa => 'Soapbox::Instance',
    required => 1,
);

has url => (
    is => 'ro',
    isa => 'Soapbox::Type::URL',
    lazy => 1,
    builder => '_build_url',
);

marshaled episodes => (
    is => 'ro',
    isa => 'Soapbox::Archive::EntryHash',
    coerce => 1,
);

sub _build_url {
    my ($self) = @_;
    return $self->instance->get_platform(ARCHIVE_PLATFORM_NAME)->media;
}

__PACKAGE__->meta->make_immutable;
