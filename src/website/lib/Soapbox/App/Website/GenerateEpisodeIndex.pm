package Soapbox::App::Website::GenerateEpisodeIndex;

use Soapbox::Moose;

use Soapbox::Website::Generate::EpisodeIndex;

extends 'Soapbox::Instance::App';

sub run {
    my ($self, %opts) = @_;
    my $template = Soapbox::Website::Generate::EpisodeIndex->new;

    print $template->render(
        instance => $self->instance,
    );
}

__PACKAGE__->meta->make_immutable;
