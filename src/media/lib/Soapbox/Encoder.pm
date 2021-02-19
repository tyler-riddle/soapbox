package Soapbox::Encoder;

use Soapbox::Moose;
use MooseX::StrictConstructor;

use Soapbox::Encode;
use Soapbox::Type;

has master => (
    is => 'ro',
    isa => 'Soapbox::Encode::Master',
    required => 1,
    coerce => 1,
);

sub encode {
    my ($self, @files) = @_;

    die "must provide file and profile pairs" if @files % 2;

    while(@files) {
        my $path = shift(@files);
        my $profile_name = shift(@files);
        my $profile = Soapbox::Encode::Profiles->get($profile_name);

        $profile->encode_master($path, $self->master);
    }
}

1;
