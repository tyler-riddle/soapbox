package Soapbox::App::Broadcast::FeedRTMP;

use Soapbox::Moose;

use File::Path 'make_path';
use YAML 'LoadFile';

use Soapbox::Type;

extends 'Soapbox::Instance::App';

sub _make_arg_spec {
    my ($package) = @_;
    return (
        $package->SUPER::_make_arg_spec,
        'name' => 'name=s',
        'input' => 'input=s',
    );
}

sub _validate_argv {
    my ($package, %opts) = @_;

    $package->SUPER::_validate_argv(%opts);

    die "name is a required argument" unless defined $opts{name};
    die "input is a required argument" unless defined $opts{input};

    return;
}

sub run {
    my ($self, %opts) = @_;
    my $private_config_dir = dir($self->instance->private_config_path, 'feed-rtmp');
    my $config_file = file($private_config_dir, $opts{name} . '.yaml');
    my $config = LoadFile($config_file);

    CORE::exec(
        'ffmpeg',
        '-loglevel',  'warning',
        '-f', 'flv',
        '-i', $opts{input},
        '-c', 'copy',
        '-f', 'flv',
        $config->{url},
    );

    die "exec(): failed";
}

__PACKAGE__->meta->make_immutable;
