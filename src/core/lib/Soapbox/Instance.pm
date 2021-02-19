package Soapbox::Instance;

use Soapbox::Moose;

use YAML 'LoadFile';

use Soapbox::Archive;
use Soapbox::Channel;
use Soapbox::Episode;
use Soapbox::Platform;
use Soapbox::Publish;
use Soapbox::Type;

const our $APPLICATION_NAME => 'soapbox';

has root => (
    is => 'ro',
    isa => 'Soapbox::Type::Directory',
    required => 1,
    coerce => 1,
);

has id => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has archive => (
    is => 'ro',
    isa => 'Soapbox::Archive',
    lazy => 1,
    builder => '_build_archive',
);

has channel => (
    is => 'ro',
    isa => 'Soapbox::Channel',
    lazy => 1,
    builder => '_build_channel',
);

has episodes => (
    is => 'ro',
    isa => 'ArrayRef[Soapbox::Episode]',
    lazy => 1,
    builder => '_build_episodes',
);

has _episode_by_id => (
    is => 'ro',
    isa => 'HashRef[Soapbox::Episode]',
    lazy => 1,
    builder => '_build__episode_by_id',
);

has platforms => (
    is => 'ro',
    isa => 'ArrayRef[Soapbox::Platform]',
    lazy => 1,
    builder => '_build_platforms',
);

has _platform_by_name => (
    is => 'ro',
    isa => 'HashRef[Soapbox::Platform]',
    lazy => 1,
    builder => '_build__platform_by_name',
);

has publish => (
    is => 'ro',
    isa => 'Soapbox::Publish',
    lazy => 1,
    builder => '_build_publish',
);

sub BUILD { }

sub _load_channel {
    my ($self) = @_;
    return LoadFile(file($self->root, 'etc/channel.yaml'));
}

sub _build_channel {
    my ($self) = @_;
    return $self->_make_channel($self->_load_channel);
}

sub _make_channel {
    my ($self, @args) = @_;
    return Soapbox::Channel->new(@args);
}

sub _load_episodes {
    my ($self) = @_;
    return LoadFile(file($self->root, 'etc/episodes.yaml'));
}

sub _make_episode {
    my ($self, @args) = @_;
    return Soapbox::Episode->new(@args);
}

sub _build_episodes {
    my ($self) = @_;
    return [ map { $self->_make_episode(%$_, instance => $self) } @{ $self->_load_episodes } ];
}

sub _build__episode_by_id {
    my ($self) = @_;
    my %by_id;

    foreach my $episode (@{ $self->episodes }) {
        $by_id{$episode->as_id} = $episode;
    }

    return \%by_id;
}

sub _load_archive {
    my ($self) = @_;
    return LoadFile(file($self->root, 'etc/archive.yaml'));
}

sub _make_archive {
    my ($self, @args) = @_;
    return Soapbox::Archive->new(@args);
}

sub _build_archive {
    my ($self) = @_;
    return $self->_make_archive({ %{$self->_load_archive}, instance => $self });
}

sub _load_platforms {
    my ($self) = @_;
    return LoadFile(file($self->root, 'etc/platforms.yaml'));
}

sub _make_platform {
    my ($self, @args) = @_;
    return Soapbox::Platform->new(@args);
}

sub _build_platforms {
    my ($self) = @_;
    return [ map { $self->_make_platform(%$_, instance => $self) } @{ $self->_load_platforms } ];
}

sub _build__platform_by_name {
    my ($self) = @_;
    my %by_name;

    foreach my $platform (@{ $self->platforms }) {
        $by_name{$platform->name} = $platform;
    }

    return \%by_name;
}

sub _load_publish {
    my ($self) = @_;
    return LoadFile(file($self->root, 'etc/publish.yaml'));
}

sub _make_publish {
    my ($self, @args) = @_;
    return Soapbox::Publish->new(@args);
}

sub _build_publish {
    my ($self) = @_;
    return $self->_make_publish($self->_load_publish);
}

sub get_episode {
    my ($self, $id) = @_;
    return $self->_episode_by_id->{$id};
}

sub get_platform {
    my ($self, $name) = @_;
    return $self->_platform_by_name->{$name};
}

sub private_config_path {
    my ($self) = @_;

    die "HOME environment variable is not set" unless defined $ENV{HOME};

    return dir($ENV{HOME}, '.config', $APPLICATION_NAME, 'private', $self->id);
}

__PACKAGE__->meta->make_immutable;
