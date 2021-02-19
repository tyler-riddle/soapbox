package MooseX::Marshal;

use Moose;
use Moose::Exporter;
use v5.10;

use Class::Inspector;
use Import::Into;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

use MooseX::Marshal::Type;

Moose::Exporter->setup_import_methods(
    with_caller => [qw(schema marshaled)],
    as_is => [qw(schema_package)],
);

sub marshaled {
    my ($caller, $name, %args) = @_;
    return __PACKAGE__->_add_marshaled(Class::MOP::Class->initialize($caller), $name, %args);
}

sub _add_marshaled {
    my ($package, $target, $name, %args) = @_;

    if (exists $args{type} && exists $args{isa}) {
        die "attribute '$name': specify only type or isa, not both";
    }

    if (exists $args{type}) {
        $args{isa} = __PACKAGE__ . '::Type::' . delete $args{type};
    }

    if (exists $args{isa} && ! exists $args{coerce}) {
        my $constraint = find_type_constraint($args{isa});

        if (defined $constraint) {
            $args{coerce} = $constraint->has_coercion;
        }
    }

    return $target->add_attribute($name, %args);
}

sub schema {
    my ($caller, %full_schema) = @_;
    return __PACKAGE__->_add_schema(
        Class::MOP::Class->initialize($caller),
        %full_schema,
    );
}

sub _add_schema {
    my ($package, $target, %full_schema) = @_;

    foreach my $name (keys %full_schema) {
        my %schema = %{ $full_schema{$name} };

        if (exists $schema{schema}) {
            my $new_class;

            if (exists $schema{isa}) {
                $new_class = $package->_make_class($schema{isa}, %{ $schema{schema} });
            } else {
                $new_class = $package->_make_anon_class(%{ $schema{schema} });
                $schema{isa} = $new_class->name;
            }

            $new_class->make_immutable;
        }

        delete $schema{schema};

        $package->_add_marshaled($target, $name, %schema);
    }

    return;
}

sub _make_class {
    my ($package, $target_package, %schema) = @_;

    Moose->import::into($target_package);
    MooseX::StrictConstructor->import::into($target_package);

    my $new_class = Class::MOP::Class->initialize($target_package);
    $package->_add_schema($new_class, %schema);

    coerce $new_class->name
        => from 'HashRef'
        # FIXME how should this use the MOP constructor?
        => via { $new_class->name->new(%$_) };

    return $new_class;
}

sub _make_anon_class {
    my ($package, %schema) = @_;
    state $anon_num = 0;
    my $target_package = __PACKAGE__ . "::ANON::" . $anon_num++;

    return $package->_make_class($target_package, %schema);
}

sub schema_package {
    my ($target_package, %schema) = @_;
    return __PACKAGE__->_make_class($target_package, %schema);
}

__PACKAGE__->meta->make_immutable;
