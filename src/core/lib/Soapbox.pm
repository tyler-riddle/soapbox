package Soapbox;

use Soapbox::Perl;

use Cwd 'abs_path';
use File::Basename 'basename';
use Module::Load '';
use YAML 'LoadFile';

use Soapbox::Type;

use constant DEFAULT_CONFIG => (
    instance_class => 'Soapbox::Instance',
);

sub load {
    my ($package, $id) = @_;
    my $directory = dir($ENV{SOAPBOX_ROOT}, 'channel', $id);
    my %config = DEFAULT_CONFIG;
    my $soapbox_conf_file = $directory . '/etc/instance.yaml';

    $config{id} = $id;

    if (-e $soapbox_conf_file) {
        my $loaded = LoadFile($soapbox_conf_file);
        foreach my $key (keys %$loaded) {
            $config{$key} = $loaded->{$key};
        }
    }

    return $package->_make_instance($directory, %config);
}

sub _make_instance {
    my ($package, $directory, %config) = @_;
    my $instance_class = $config{instance_class};
    my $channel_lib_dir = $directory . '/lib';
    our %ADDED_LIB_DIRS;

    if (! $ADDED_LIB_DIRS{$channel_lib_dir}) {
        unshift(@INC, $channel_lib_dir);
        $ADDED_LIB_DIRS{$channel_lib_dir} = 1;
    }

    Module::Load::load $instance_class;
    return $instance_class->new(root => $directory, id => $config{id});
}

1;
