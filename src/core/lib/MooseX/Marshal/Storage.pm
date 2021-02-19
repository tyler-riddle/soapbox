package MooseX::Marshal::Storage;

use Moose::Exporter;
use Moose::Role;
use MooseX::Marshal;

use YAML qw(LoadFile);

Moose::Exporter->setup_import_methods(
    as_is => [qw(schema_package)],
);

has path => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_path',
);

has _loaded => (
    is => 'ro',
    lazy => 1,
    builder => '_build__loaded',
);

sub _build__loaded {
    my ($self) = @_;
    my @loaded = LoadFile($self->path);
    return $self->_map__loaded($loaded[0]);
}

sub _map__loaded {
    my ($self, $loaded) = @_;
    return $loaded;
}

1;
