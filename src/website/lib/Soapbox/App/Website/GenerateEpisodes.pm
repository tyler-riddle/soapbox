package Soapbox::App::Website::GenerateEpisodes;

use Soapbox::Moose;

use File::Slurp 'write_file';
use Getopt::Long;

use Soapbox;
use Soapbox::Type;
use Soapbox::Website::Generate::Episode;

extends 'Soapbox::Instance::App';

sub _make_arg_spec {
    my ($package) = @_;
    return (
        $package->SUPER::_make_arg_spec,
        'outdir' => 'outdir=s',
    );
}

sub _validate_argv {
    my ($package, %opts) = @_;

    $package->SUPER::_validate_argv(%opts);

    die "outdir is a required argument" unless defined $opts{outdir};

    return;
}

sub run {
    my ($self, %opts) = @_;
    my $instance = $self->instance;

    foreach my $episode (@{ $instance->episodes }) {
        my $episode_id = $episode->as_id;
        my @archives = values %{ $instance->archive->episodes->{$episode_id} };
        my $episode_template = Soapbox::Website::Generate::Episode->new;
        my $filename = file($opts{outdir}, $episode->file_prefix . '.md');

        write_file($filename, $episode_template->render(
            episode => $episode,
            archive => \@archives,
        )) or die "write_file($filename): $!";
    }
}

__PACKAGE__->meta->make_immutable;
