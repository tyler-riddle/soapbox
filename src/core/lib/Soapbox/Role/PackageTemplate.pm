package Soapbox::Role::PackageTemplate;

use Soapbox::Moose::Role;

use File::Slurp qw(read_file);
use Template;

use Soapbox::Type;

sub render {
    my ($self, @args) = @_;
    my $tt = Template->new or die $Template::ERROR;
    my $heap = $self->make_heap(@args);
    my $template = $self->get_template;
    my $buf;

    $tt->process(\$template, $heap, \$buf) || die $tt->error;

    return $buf;
}

sub template_filename {
    my ($package, $for_package) = @_;
    my $buf;

    if (defined $for_package) {
        $buf = $for_package;
    } else {
        $buf = $package;
    }

    if (ref($buf) ne '') {
        $buf = ref($buf);
    }

    $buf =~ s,::,/,g;
    $buf = "/$buf.tt";

    return $buf;
}

sub template_path {
    my ($package, $for_package) = @_;
    my $template_filename = $package->template_filename;

    for my $path (@INC) {
        my $maybe_file = file($path, $template_filename);
        if (-e $maybe_file) {
            return $maybe_file;
        }
    }

    return undef;
}

sub get_template {
    my ($package) = @_;
    local $/ = undef;
    my $file = $package->template_path();

    return undef unless defined $file;
    return read_file($file);
}

sub make_heap {
    my ($self, @args) = @_;
    my %heap = @args;

    return \%heap;
}

1;
