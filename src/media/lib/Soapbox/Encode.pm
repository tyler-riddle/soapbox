package Soapbox::Encode;

use Soapbox::Perl;

use Soapbox::Encode::Master;
use Soapbox::Encode::Profiles;
use Soapbox::Media;

Soapbox::Encode::Profiles->load(qw(
    Soapbox::Encode::Profile::ffmpeg
    Soapbox::Encode::Profile::flac
    Soapbox::Encode::Profile::ImageMagick
    Soapbox::Encode::Profile::LAME
    Soapbox::Encode::Profile::speex
    Soapbox::Encode::Profile::vorbis
));

1;
