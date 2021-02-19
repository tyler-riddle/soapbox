package Soapbox::Media::MP3;

use Soapbox::Moose;

use MP3::Info;

with 'Soapbox::Role::Media';

sub get_duration {
    my ($self) = @_;
    open(my $fh, $self->path) or die "open(): $!";
    my $info = get_mp3info($fh);
    return $info->{SECS};
}

__PACKAGE__->meta->make_immutable;
