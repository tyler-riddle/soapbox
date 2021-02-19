package Soapbox::Type;

use Soapbox::Moose;
use Moose::Util::TypeConstraints;
use Moose::Exporter;

use DateTime;
use DateTime::Format::HTTP;
use Email::Address;
use Path::Class;
use Scalar::Util qw(looks_like_number);
use URI::URL;

Moose::Exporter->setup_import_methods(
    as_is => [qw( Path::Class::dir Path::Class::file )],
);

use constant DESCRIPTION_LEN => 130;

subtype 'Soapbox::Type::DateTime'
    => as 'DateTime'
    => where { $_->time_zone->name eq 'UTC' }
    => message { 'Timezone must be UTC' };

coerce 'Soapbox::Type::DateTime'
    => from 'Str'
    => via { DateTime::Format::HTTP->parse_datetime($_) };

subtype 'Soapbox::Type::Directory'
    => as 'Path::Class::Dir';

coerce 'Soapbox::Type::Directory'
    => from 'Str'
    => via { dir($_) };

subtype 'Soapbox::Type::Email'
    => as 'Email::Address';

coerce 'Soapbox::Type::Email'
    => from 'Str'
    => via {
        my @found = Email::Address->parse($_);
        die "no email address found" if @found < 1;
        die "more than one email address found" if @found > 1;
        return $found[0];
    };

subtype 'Soapbox::Type::File'
    => as 'Path::Class::File';

coerce 'Soapbox::Type::File'
    => from 'Str'
    => via { file($_) };

subtype 'Soapbox::Type::Info::Description'
    => as 'Str'
    => where {
        my $length = length($_);
        die "string length too long: $length" unless $length <= DESCRIPTION_LEN };

subtype 'Soapbox::Type::Str'
    => as 'Str';

subtype 'Soapbox::Type::URL'
    => as 'URI::URL';

coerce 'Soapbox::Type::URL'
    => from 'Str'
    => via { URI::URL->new($_) };
1;
