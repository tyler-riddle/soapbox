package Soapbox::Encode::Profile::ImageMagick;

use Soapbox::Moose;

use Image::Magick;

with 'Soapbox::Role::Encode::Profile';

has '+extension' => (default => '');

sub _add_global_profiles {
    my ($package) = @_;
    my $profile = Soapbox::Encode::Profile::ImageMagick->new(name => 'imagemagick');

    Soapbox::Encode::Profiles->add($profile);
}

sub encode {
    my ($self, $output, $input, $metadata) = @_;
    my $image = Image::Magick->new;

    $image->Read($input);
    $image->Write($output);

    return;
}

__PACKAGE__->meta->make_immutable;
