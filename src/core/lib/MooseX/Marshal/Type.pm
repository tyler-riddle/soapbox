package MooseX::Marshal::Type;

use Moose;
use Moose::Util::TypeConstraints;

use Scalar::Util qw(looks_like_number);

use constant BOOL_VALUES => {
    false => 0, true => 1,
    no => 0, yes => 1,
    off => 0, on => 1,
};

subtype 'MooseX::Marshal::Type::Bool'
    => as 'Bool';

coerce 'MooseX::Marshal::Type::Bool'
    => from 'Str'
    => via {
        if (looks_like_number($_)) {
            return $_ && 1 || 0;
        }

        return BOOL_VALUES()->{lc($_)};

        die "invalid boolean value: $_";
    };

__PACKAGE__->meta->make_immutable;
