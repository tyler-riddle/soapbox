package Soapbox::Media;

use Soapbox::Moose;
use Moose::Exporter;

use Soapbox::Media::AVI;
use Soapbox::Media::MKV;
use Soapbox::Media::MP3;

Moose::Exporter->setup_import_methods(
    as_is => [qw( media )],
);

sub media {
    my ($path) = @_;
    my $extension = _get_extension($path);

    if ($extension eq 'avi') {
        return Soapbox::Media::AVI->new(path => $path);
    } elsif ($extension eq 'mp3') {
        return Soapbox::Media::MP3->new(path => $path);
    } elsif ($extension eq 'mkv') {
        return Soapbox::Media::MKV->new(path => $path);
    }

    die "unknown media file extension: $extension";
}

sub _get_extension {
    my ($path) = @_;
    $path =~ /\.+(.*)/;
    return $1;
}

__PACKAGE__->meta->make_immutable;
