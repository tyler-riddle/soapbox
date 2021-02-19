package Soapbox::Website::Generate::EpisodeIndex;

use Soapbox::Moose;

use Soapbox::Type;

with 'Soapbox::Role::PackageTemplate';

sub make_heap {
    my ($self, %heap) = @_;

    $heap{URI} = URI->new;

    return \%heap;
}

__PACKAGE__->meta->make_immutable;
