package Soapbox::Instance::App;

use Soapbox::Moose;

use Getopt::Long;

use Soapbox;
use Soapbox::Instance;

has instance => (
    is => 'ro',
    isa => 'Soapbox::Instance',
    required => 1,
);

sub run {
    my ($self) = @_;
    die "subclass ", ref($self), " must overload run method";
}

sub main {
    my ($package, @args) = @_;
    my %getopt_config = $package->_getopt_config;

    Getopt::Long::Configure(keys %getopt_config);

    my %opts = $package->_parse_argv();
    my $instance = Soapbox->load($opts{id});

    $ENV{SOAPBOX_INSTANCE_ID} = $instance->id;

    return $package->new(instance => $instance, @args)->run(%opts);
}

sub _make_arg_spec {
    my ($package) = @_;
    return ('id' => ['id=s', $ENV{SOAPBOX_INSTANCE_ID}]);
}

sub _getopt_config {
    my ($package) = @_;
    return ();
}

sub _make_getopt_spec {
    my ($package, %arg_spec) = @_;
    my (%getopt_spec, %accumulator);

    foreach my $name (keys %arg_spec) {
        my $spec = $arg_spec{$name};
        my $default;

        if (ref($spec)) {
            ($spec, $default) = @$spec;
        }

        if (defined $default) {
            $accumulator{$name} = $default;
        }

        $getopt_spec{$spec} = \$accumulator{$name};
    }

    return (\%accumulator, %getopt_spec);
}

sub _parse_argv {
    my ($package) = @_;
    my %arg_spec = $package->_make_arg_spec;
    my ($accumulator, %getopt_spec) = $package->_make_getopt_spec(%arg_spec);

    GetOptions(%getopt_spec) or die "invalid arguments";
    $package->_validate_argv(%$accumulator);

    return %$accumulator;
}

sub _validate_argv {
    my ($package, %opts) = @_;

    die "id is a required argument" unless defined $opts{id};

    return 1;
}

__PACKAGE__->meta->make_immutable;
