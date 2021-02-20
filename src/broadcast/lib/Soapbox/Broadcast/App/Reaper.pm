package Soapbox::Broadcast::App::Reaper;

use Soapbox::Moose;

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

const our $REAPER_BIN => 'reaper';

sub run {
    my ($self) = @_;
    my $conf_file = file($self->instance->private_config_path, 'REAPER', 'config.ini');
    my @extra_args = ('-cfgfile', $conf_file);

    chdir($self->instance->root);
    CORE::exec($REAPER_BIN, @extra_args, @ARGV);
}

__PACKAGE__->meta->make_immutable;
