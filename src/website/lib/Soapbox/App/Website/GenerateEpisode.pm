package Soapbox::App::Website::GenerateEpisode;

use Soapbox::Moose;

use Soapbox;
use Soapbox::Website::Generate::Episode;

extends 'Soapbox::Instance::App';

sub _make_arg_spec {
    my ($package) = @_;
    return (
        $package->SUPER::_make_arg_spec,
        'episode' => ['episode=s', $ENV{SOAPBOX_EPISODE_ID}],
    );
}

sub _validate_argv {
    my ($package, %opts) = @_;

    $package->SUPER::_validate_argv(%opts);

    die "episode is a required argument" unless defined $opts{episode};

    return;
}

sub get_archives {
    my ($self, $episode) = @_;
    my $archive = $self->instance->archive;

    return () unless $archive->episodes;
    return values %{ $self->instance->archive->episodes->{$episode->as_id} };
}

sub run {
    my ($self, %opts) = @_;
    my $episode = $self->instance->get_episode($opts{episode});
    my $episode_id = $episode->as_id;
    my @archives = $self->get_archives($episode);
    my $episode_template = Soapbox::Website::Generate::Episode->new;

    print $episode_template->render(
        episode => $episode,
        archive => \@archives,
    );
}

__PACKAGE__->meta->make_immutable;
