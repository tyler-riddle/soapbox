package Soapbox::App::Publish::GenerateRSS;

use Soapbox::Moose;

with 'Soapbox::Role::PackageTemplate';

# sub _make_heap {
#     my ($self) = @_;
#     my $episodes = FDG::Episodes->new;

#     return {
#         show => FDG::Show->load,
#         episodes => [ grep { $_->published } reverse($episodes->get_episodes) ],
#     };
# }

__PACKAGE__->meta->make_immutable;
