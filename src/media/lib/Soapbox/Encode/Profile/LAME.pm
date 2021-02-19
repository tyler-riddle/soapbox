package Soapbox::Encode::Profile::LAME;

use Soapbox::Moose;
use MooseX::Marshal;

use IPC::Run 'run';

extends 'Soapbox::Encode::Profile';

schema_package (
    'Soapbox::Encode::Profile::LAME::ID3',

    album => {
        is => 'ro',
        isa => 'Str',
    },

    artist => {
        is => 'ro',
        isa => 'Str',
    },

    description => {
        is => 'ro',
        isa => 'Str',
    },

    _image => {
        is => 'ro',
        isa => 'Soapbox::Type::File',
    },

    title => {
        is => 'ro',
        isa => 'Str',
    },

    track => {
        is => 'ro',
        isa => 'Int',
    },
);

has format_args => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    required => 1,
);

has '+extension' => (
    default => 'mp3',
);

our %PROFILES = (
    'lame' => [qw()],
    'lame-vbr-5' => [qw(-V 5)],
    'lame-cbr-128' => [qw(-b 128)],
);

sub _add_global_profiles {
    my ($package) = @_;

    foreach my $name (keys %PROFILES) {
        my $profile = $package->new(name => $name, format_args => $PROFILES{$name});
        Soapbox::Encode::Profiles->add($profile);
    }
}

sub encode {
    my ($self, $output, $input, $id3) = @_;
    my @encode = $self->_make_encoder_command($output, $input, $id3);
    my @decode = $self->_make_decoder_command($output, $input, $id3);

    run(\@decode, '|', \@encode) or die "encode failed";
}

sub make_meta_info {
    my ($self, $master) = @_;
    my $episode = $master->episode;
    my %meta;

    $meta{_image} = $master->poster if defined $master->poster;

    return Soapbox::Encode::Profile::LAME::ID3->new(%meta) unless defined $episode;

    my $channel = $episode->instance->channel;
    my $channel_name = $channel->name;

    $meta{album} = "$channel_name Season " . $episode->season if defined $episode->season;
    $meta{description} = $episode->description if defined $episode->description;
    $meta{title} = $episode->title if defined $episode->title;
    $meta{track} = $episode->number if defined $episode->number;

    return Soapbox::Encode::Profile::LAME::ID3->new(%meta);
}

sub _make_encoder_command {
    my ($self, $output, $input, $id3) = @_;
    my @id3_args = $self->_make_id3_args($input, $id3);

    return (
        'lame',
        '--replaygain-accurate',
        '--id3v2-only',
        @{ $self->format_args },
        $self->_make_id3_args($input, $id3),
        '-', $output,
    );
}

sub _make_id3_args {
    my ($self, $input, $id3) = @_;
    my @args;

    return () unless defined $id3;

    push(@args, '--ta', $id3->artist) if defined $id3->artist;
    push(@args, '--ti', $id3->_image) if defined $id3->_image;
    push(@args, '--tl', $id3->album) if defined $id3->album;
    push(@args, '--tn', $id3->track) if defined $id3->track;
    push(@args, '--tt', $id3->title) if defined $id3->title;

    return @args;
}

sub _make_decoder_command {
    my ($self, $output, $input, $id3) = @_;
    return (
        'ffmpeg',
        '-loglevel', 'quiet',
        '-i', $input,
        '-acodec', 'pcm_s16le',
        '-f', 'wav',
        '-',
    );
}

__PACKAGE__->meta->make_immutable;
