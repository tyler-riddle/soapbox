package Soapbox::App::Broadcast::FeedHLS;

use Soapbox::Moose;

extends 'Soapbox::Instance::App';

sub _make_arg_spec {
    my ($package) = @_;
    return (
        $package->SUPER::_make_arg_spec,
        'input' => 'input=s',
        'playlist' => 'playlist=s',
        'content' => 'content=s',
    );
}

sub _validate_argv {
    my ($package, %opts) = @_;

    $package->SUPER::_validate_argv(%opts);

    die "input is a required argument" unless defined $opts{input};
    die "playlist is a required argument" unless defined $opts{playlist};
    die "content is a required argument" unless defined $opts{content};

    return;
}

sub run {
    my ($self, %opts) = @_;

    CORE::exec(
        'ffmpeg',
        '-i', $opts{input},
        '-c', 'copy',
        '-f', 'hls',
        '-hls_flags', '+independent_segments',
        '-hls_time', 6,
        '-hls_list_size', 50,
        '-hls_flags', '+delete_segments',
        '-strftime', 1,
        '-hls_segment_filename', $opts{content},
        $opts{playlist},
    );

    die "exec() failed: $!";
}

__PACKAGE__->meta->make_immutable;
