package Soapbox::Encode::Profile::flac;

use Soapbox::Moose;
use MooseX::Marshal;

use IPC::Run 'run';

extends 'Soapbox::Encode::Profile';

has '+extension' => ( default => 'flac' );

sub _add_global_profiles {
    my ($package) = @_;

    my $profile = Soapbox::Encode::Profile::flac->new(name => 'flac');

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
        'flac',
        '--verify',
        '--replay-gain',
        '-o', $output,
        @metadata_args,
        '-',
    );

    run(\@decode, '|', \@encode) or die "encode failed";
}

__PACKAGE__->meta->make_immutable;
