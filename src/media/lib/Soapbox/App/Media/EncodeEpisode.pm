package Soapbox::App::Media::EncodeEpisode;

use Soapbox::Moose;

use Getopt::Long;

use Soapbox;
use Soapbox::Type;

sub main {
    my %opts = parse_argv();
    my $soapbox = Soapbox->load($opts{root});

    foreach my $episode_id (@ARGV) {
        my $episode = $soapbox->get_episode($episode_id);

        die "No such episode: $episode_id" unless $episode;

        my %master_args = (episode => $episode);
        my $episode_root = dir($soapbox->root, 'var/episode/', $episode->as_id);
        my $master_avi = file($episode_root, 'master.avi');
        my $master_wav = file($episode_root, 'master.wav');
        my $poster_jpg = file($episode_root, 'poster.jpg');

        die "$episode_root: no master.avi or master.wav" unless -e $master_avi || -e $master_wav;
        die "$episode_root: only one of master.avi or master.wav can be present, not both" if -e $master_avi && -e $master_wav;

        if (-e $master_avi) {
            $master_args{source} = $master_avi->stringify;
        } elsif (-e $master_wav) {
            $master_args{source} = $master_wav->stringify;
        } else {
            die "unhandled master file type";
        }

        $master_args{poster} = $poster_jpg->stringify if -e $poster_jpg;
        my @to_encode = make_encode_args($episode, $opts{outdir});
        my $encoder = Soapbox::Encoder->new(master => \%master_args);
        $encoder->encode(@to_encode);
    }
}

sub parse_argv {
    my %options;

    GetOptions(
        "root=s" => \$options{root},
        "outdir=s" => \$options{outdir},
    );

    die "root is a required argument" unless defined $options{root};
    die "outdir is a required argument" unless defined $options{outdir};

    return %options;
}

sub make_encode_args {
    my ($episode, $outdir) = @_;
    my $publish = $episode->instance->publish;
    my $formats = $publish->formats;
    my $file_prefix = $episode->file_prefix;
    my @args;

    $outdir = '.' unless defined $outdir;

    return () unless defined $formats;

    foreach my $label (keys %$formats) {
        my $filename = file($outdir, $file_prefix);
        my $format = $formats->{$label};

        if (ref($format) eq '') {
            $format = { profile => $format };
        }

        if (defined $format->{suffix}) {
            $filename .= '.' . $format->{suffix};
        }

        if (defined $format->{extension}) {
            $filename .= '.' . $format->{extension};
        } else {
            $filename .= '.' . Soapbox::Encode::Profiles->get($format->{profile})->extension;
        }

        push(@args, $filename, $format->{profile});
    }

    return @args;
}

__PACKAGE__->meta->make_immutable;
