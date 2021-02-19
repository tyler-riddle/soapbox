package Soapbox::Encode::Profile::vorbis;

use Soapbox::Moose;
use MooseX::Marshal;

use IPC::Run 'run';

extends 'Soapbox::Encode::Profile';

use constant VORBIS_QUALITY => 5;

has '+extension' => ( default => 'ogg' );

sub _add_global_profiles {
    my ($package) = @_;

    my $profile = Soapbox::Encode::Profile::vorbis->new(name => 'oggenc');

    Soapbox::Encode::Profiles->add($profile);
}

sub encode {
    my ($self, $output, $input, $metadata) = @_;
    my @metadata_args;

    my @decode = (
        'ffmpeg',
        '-loglevel', 'quiet',
        '-i', $input,
        '-acodec', 'pcm_s16le',
        '-ac', '2',
        '-ar', '48000',
        '-f', 'wav',
        '-',
    );

    my @encode = (
        'oggenc', '--discard-comments',
        '-q', VORBIS_QUALITY,
        '-o', $output,
        '-',
    );

    run(\@decode, '|', \@encode) or die "encode failed";
}

__PACKAGE__->meta->make_immutable;
