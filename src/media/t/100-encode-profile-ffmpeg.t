use Soapbox::Perl;

use Test::More;

use Soapbox::Type;

require_ok 'Soapbox::Encode::Profile::ffmpeg';

my $ffmpeg_program = $Soapbox::Encode::Profile::ffmpeg::FFMPEG_BINARY;
isnt(undef, 'ffmpeg_binary', "ffmpeg program is defined");

my $ffmpeg_path = find_exe_in_path($ffmpeg_program);
if (defined $ffmpeg_path) {
    diag("ffmpeg binary found at $ffmpeg_path");
} else {
    diag("no ffmpeg binary found - can't do further testing");
    done_testing();
    exit(0);
}

done_testing();

sub find_exe_in_path {
    my ($program) = @_;

    foreach my $path (split(':', $ENV{PATH})) {
        my $maybe_file = file($path, $program);

        return $maybe_file if -x $maybe_file;
    }

    return undef;
}
