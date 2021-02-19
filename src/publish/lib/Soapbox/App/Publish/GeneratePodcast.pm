package Soapbox::App::Publish::GeneratePodcast;

use Soapbox::Moose;

use Getopt::Long;
use URI;

use Soapbox;
use Soapbox::Type;

with 'Soapbox::Role::PackageTemplate';

sub main {
    my ($self) = @_;
    my %opts = $self->parse_argv();
    print $self->render(%opts) or die "print(): $!";
}

sub parse_argv {
    my ($package) = @_;
    my %opts;

    GetOptions('root=s' => \$opts{root});
    die "root is a required argument" unless defined $opts{root};

    return %opts;
}

sub make_heap {
    my ($self, %opts) = @_;
    my $soapbox = Soapbox->load($opts{root});
    my $archive = $soapbox->archive;
    my @with_mp3;
    my %media_locations;

    foreach my $episode (grep { $_->published } reverse(@{ $soapbox->episodes })) {
        my $episode_archives = $archive->episodes->{$episode->as_id};
        foreach my $entry_label (keys %$episode_archives) {
            my $archive_entry = $episode_archives->{$entry_label};

            if ($archive_entry->{label} eq 'mp3') {
                push(@with_mp3, $episode);
                $media_locations{$episode->as_id} = $archive_entry->{location};
            }
        }
    }

    return {
        URI => URI->new,
        channel => $soapbox->channel,
        episodes => \@with_mp3,
        media_locations => \%media_locations,
    };
}

__PACKAGE__->meta->make_immutable;
