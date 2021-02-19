package Soapbox::Broadcast::App::nginx;

use Soapbox::Moose;

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

const our $NGINX_BIN => 'nginx';

sub _getopt_config {
    my ($package) = @_;
    return (pass_through => 1);
}

sub run {
    my ($self) = @_;
    my $conf_file = file($self->instance->root, '/etc/nginx.conf');

    chdir($self->instance->root);
    CORE::exec(
        $NGINX_BIN,
        '-c', $conf_file,
        @ARGV
    );
    die "exec(): $!";
}

__PACKAGE__->meta->make_immutable;
