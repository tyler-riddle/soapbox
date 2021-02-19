package Soapbox::Moose;

use Soapbox::Perl;
use Import::Into;

use Const::Fast;

use base 'Soapbox::Perl';

const our @MOOSE_IMPORTS => (
    [qw(Moose)],
    [qw(MooseX::StrictConstructor)],
);

sub make_imports {
    my ($package) = @_;
    return(@Soapbox::Perl::COMMON_IMPORTS, @MOOSE_IMPORTS);
}

1;
