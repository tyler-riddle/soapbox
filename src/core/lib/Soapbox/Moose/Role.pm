package Soapbox::Moose::Role;

use Soapbox::Perl;
use Import::Into;

use Const::Fast;

use base 'Soapbox::Perl';

const our @ROLE_IMPORTS => (
    [qw(Moose::Role)],
);

sub make_imports {
    my ($package) = @_;
    return(@Soapbox::Perl::COMMON_IMPORTS, @ROLE_IMPORTS);
}

1;
