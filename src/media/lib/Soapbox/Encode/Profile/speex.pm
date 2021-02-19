package Soapbox::Encode::Profile::speex;

use Soapbox::Moose;
use MooseX::Marshal;

use IPC::Run 'run';

extends 'Soapbox::Encode::Profile';

has '+extension' => ( default => 'spx' );

use constant SPEEX_QUALITY => 8;
use constant SPEEX_COMPLEXITY => 10;

schema_package (
    'Soapbox::Encode::Profile::speex::Metadata',

    title => {
        is => 'ro',
        isa => 'Str',
    },

    author => {
        is => 'ro',
        isa => 'Str',
    },
);

sub _add_global_profiles {
    my ($package) = @_;

    my $profile = Soapbox::Encode::Profile::speex->new(name => 'speexenc-ultra-wideband');

    Soapbox::Encode::Profiles->add($profile);
}

sub make_meta_info {
    my ($self, $master) = @_;
    my $episode = $master->episode;
    my %metadata;

    return Soapbox::Encode::Profile::speex::Metadata->new(%metadata) unless defined $master;

    if (defined $episode) {
        my $channel = $episode->instance->channel;

        $metadata{title} = $episode->title if defined $episode->title;

        if (defined $channel) {
            $metadata{author} = $channel->name if defined $channel->name;
        }
    }

    return Soapbox::Encode::Profile::speex::Metadata->new(%metadata);
}

sub encode {
    my ($self, $output, $input, $metadata) = @_;
    my @metadata_args;

    if (defined $metadata) {
        push(@metadata_args, '--title', $metadata->title) if defined $metadata->title;
        push(@metadata_args, '--author', $metadata->author) if defined $metadata->author;
    }

    my @decode = (
        'ffmpeg',
        '-loglevel', 'quiet',
        '-i', $input,
        '-af', 'lowpass=f=12000',
        '-acodec', 'pcm_s16le',
        '-ac', '2',
        '-ar', '32000',
        '-f', 's16le',
        '-',
    );

    my @encode = (
        'speexenc',
        '--ultra-wideband',
        '--quality', SPEEX_QUALITY,
        '--comp', SPEEX_COMPLEXITY,
        '--le',
        '--16bit',
        '--stereo',
        '--rate', '32000',
        @metadata_args,
        '-', $output,
    );

    run(\@decode, '|', \@encode) or die "encode failed";
}

__PACKAGE__->meta->make_immutable;
