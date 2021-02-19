package Soapbox::Website::Generate::Episode;

use Soapbox::Moose;

use Soapbox::Type;

with 'Soapbox::Role::PackageTemplate';

sub make_heap {
    my ($self, %heap) = @_;
    my $episode = $heap{episode};
    my $archive_entries = $heap{archive};
    my $archive_url = $episode->instance->archive->url;
    my %by_label;

    foreach my $entry (@$archive_entries) {
        my $label = $entry->{label};
        $by_label{$label} = $entry;
        $entry->{location} = URI->new_abs($entry->{location}, $archive_url);
    }

    $heap{by_label} = \%by_label;

    my @platforms = grep { $_->platform ne Soapbox::Archive::ARCHIVE_PLATFORM_NAME() } @{ $archive_entries };
    my @archive = grep { $_->platform eq Soapbox::Archive::ARCHIVE_PLATFORM_NAME() } @{ $archive_entries };

    $heap{platforms} = \@platforms if @platforms;
    $heap{archive} = \@archive if @archive;

    return \%heap;
}

__PACKAGE__->meta->make_immutable;
