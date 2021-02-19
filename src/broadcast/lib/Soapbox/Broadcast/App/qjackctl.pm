package Soapbox::Broadcast::App::qjackctl;

use Soapbox::Moose;

use Getopt::Long qw(:config pass_through);

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

const our $QJACKCTL_BIN => 'qjackctl';

sub run {
    my ($self) = @_;
    my $instance_id = $self->instance->id;
    my $patchbay_file = file('etc/qjackctl-patchbay.xml');
    my @extra_args;

    $ENV{QJACKCTL_CONFIG_ORG} = "Soapbox::Broadcast";
    $ENV{QJACKCTL_CONFIG_APP} = "$instance_id(qjackctl)";

    push(@extra_args, '--active-patchbay', $patchbay_file);

    chdir($self->instance->root);
    CORE::exec($QJACKCTL_BIN, @extra_args, @ARGV);
    die "exec(): $!";
}

__PACKAGE__->meta->make_immutable;
