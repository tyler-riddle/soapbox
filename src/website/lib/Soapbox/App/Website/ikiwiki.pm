package Soapbox::App::Website::ikiwiki;

use Soapbox::Moose;

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

sub run {
    my ($self, %opts) = @_;
    my $out_dir = dir($ENV{SOAPBOX_VAR}, '/cache/channel/', $self->instance->id, '/website');

    chdir($self->instance->root);

    CORE::exec(
        'ikiwiki',
        '--setup' => file($self->instance->root, 'share/website/.config.yaml'),
        '--set' => 'srcdir=' . dir($self->instance->root, 'share/website/'),
        '--set' => "destdir=$out_dir",
        '--set' => 'url=' . $self->instance->channel->website->homepage,
        @ARGV
    );

    die "Could not exec(): $!";
}

__PACKAGE__->meta->make_immutable;
