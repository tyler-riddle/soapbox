package Soapbox::Broadcast::App::OBS;

use Soapbox::Moose;

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

const our $OBS_BIN => 'obs';

sub run {
    my ($self) = @_;
    my $conf_dir = file($self->instance->root, '/etc/soapbox-obs');

    $ENV{OBS_CONFIG_PATH} = $conf_dir;
    CORE::exec($OBS_BIN, @ARGV);
    die "exec(): $!";
}

__PACKAGE__->meta->make_immutable;
