package Soapbox::Encode::Profile::ffmpeg;

use Soapbox::Moose;
use MooseX::Marshal;

use IPC::Run 'run';

extends 'Soapbox::Encode::Profile';

const our $FFMPEG_BINARY => 'ffmpeg';

schema_package (
    'Soapbox::Encode::Profile::ffmpeg::Metadata',

    album => {
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

    synopsis => {
        is => 'ro',
        isa => 'Str',
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
    default => 'mp4',
);

our %PROFILES = (
    'ffmpeg-avc' => [qw(-acodec:0 aac -vcodec:0 libx264 -f mp4)],
    'ffmpeg-hevc' => [qw(-acodec:0 aac -vcodec:0 libx265 -f mp4)],
);

sub _add_global_profiles {
    my ($package) = @_;

    foreach my $name (keys %PROFILES) {
        my $profile = $package->new(name => $name, format_args => $PROFILES{$name});
        Soapbox::Encode::Profiles->add($profile);
    }
}

sub encode {
    my ($self, $output, $input, $metadata) = @_;

    my @args = (
        $FFMPEG_BINARY,
        '-y',
        $self->_make_input_args($output, $input, $metadata),
        $self->_make_thumbnail_input_args($output, $input, $metadata),
        $self->_make_output_args($output, $input, $metadata),
        $self->_make_thumbnail_output_args($output, $input, $metadata),
        $output,
    );

    run(\@args);
}

sub _make_input_args {
    my ($self, $output, $input, $metadata) = @_;
    return (
        '-i', $input,
    );
}

sub _make_output_args {
    my ($self, $output, $input, $metadata) = @_;

    return (
        '-movflags', '+faststart',
        @{ $self->format_args },
        $self->_make_metadata_args($output, $input, $metadata),
    );
}

sub _make_thumbnail_input_args {
    my ($self, $output, $input, $metadata) = @_;

    return () unless defined $metadata->_image;

    return (
        '-i', $metadata->_image,
        '-map', '0',
        '-map', '1',
    );
}

sub _make_thumbnail_output_args {
    my ($self, $output, $input, $metadata) = @_;
    return () unless defined $metadata->_image;

    return (
        '-c:v:1', 'copy',
        '-disposition:v:1', 'attached_pic',
    );
}

sub make_meta_info {
    my ($self, $master) = @_;
    my $episode = $master->episode;
    my %meta;

    $meta{_image} = $master->poster if defined $master->poster;

    if (defined $episode) {
        my $channel_name = $episode->instance->channel->name;

        $meta{album} = "$channel_name Season " . $episode->season if defined $episode->season;
        $meta{description} = $episode->description if defined $episode->description;
        $meta{title} = $episode->title if defined $episode->title;
        $meta{synopsis} = $episode->synopsis if defined $episode->synopsis;
        $meta{track} = $episode->number if defined $episode->number;
    }

    return Soapbox::Encode::Profile::ffmpeg::Metadata->new(%meta);
}

sub _make_metadata_args {
    my ($self, $output, $input, $metadata) = @_;
    my @args;

    foreach my $name (keys %$metadata) {
        next if $name =~ /^_/;
        push(@args, '-metadata', "$name=" . $metadata->{$name});
    }

    return @args;
}

__PACKAGE__->meta->make_immutable;
