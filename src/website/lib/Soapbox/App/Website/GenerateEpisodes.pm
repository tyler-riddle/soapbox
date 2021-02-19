package Soapbox::App::Website::GenerateEpisodes;

use Soapbox::Moose;

use File::Slurp 'write_file';
use Getopt::Long;

use Soapbox;
use Soapbox::Type;
use Soapbox::Website::Generate::Episode;

sub main {
    my ($package) = @_;
    my %opts = $package->parse_argv;
    my $soapbox = Soapbox->load($opts{root});

    foreach my $episode (@{ $soapbox->episodes }) {
        my $episode_id = $episode->as_id;
        my @archives = values %{ $soapbox->archive->episodes->{$episode_id} };
        my $episode_template = Soapbox::Website::Generate::Episode->new;
        my $filename = file($opts{outdir}, $episode->file_prefix . '.md');

        write_file($filename, $episode_template->render(
            episode => $episode,
            archive => \@archives,
        )) or die "write_file($filename): $!";
    }
}

sub parse_argv {
    my %options;

    GetOptions(
        "root=s" => \$options{root},
        "outdir" => 'outdir=s',
    );

    die "root is a required argument" unless defined $options{root};
    die "outdir is a required argument" unless defined $options{outdir};

    return %options;
}

__PACKAGE__->meta->make_immutable;
