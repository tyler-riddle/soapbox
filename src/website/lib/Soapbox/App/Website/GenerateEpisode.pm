package Soapbox::App::Website::GenerateEpisode;

use Soapbox::Moose;

use Getopt::Long;

use Soapbox;
use Soapbox::Website::Generate::Episode;

sub main {
    my ($package) = @_;
    my %opts = $package->parse_argv;
    my $soapbox = Soapbox->load($opts{root});
    my $episode = $soapbox->get_episode($opts{episode});
    my $episode_id = $episode->as_id;
    my @archives = values %{ $soapbox->archive->episodes->{$episode_id} };
    my $episode_template = Soapbox::Website::Generate::Episode->new;

    print $episode_template->render(
        episode => $episode,
        archive => \@archives,
    );
}

sub parse_argv {
    my ($package) = @_;
    my %opts;

    GetOptions(
        'root=s' => \$opts{root},
        "episode" => 'episode=s',
    );

    die "root is a required argument" unless defined $opts{root};
    die "episode is a required argument" unless defined $opts{episode};

    return %opts;
}

__PACKAGE__->meta->make_immutable;
