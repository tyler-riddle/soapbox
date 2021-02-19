package Soapbox::App::Core::Supervisor;

use Soapbox::Moose;

use File::Basename qw(basename dirname);
use Getopt::Long qw(:config pass_through);

use Soapbox;
use Soapbox::Type;

extends 'Soapbox::Instance::App';

const our $SUPERVISOR_DAEMON => 'supervisord';
const our $SUPERVISOR_CONTROL => 'supervisorctl';

const our $SUPERVISOR_CONFIG => 'etc/supervisor.conf';
const our $SUPERVISOR_LOG => 'var/log/supervisor.log';
const our $SUPERVISOR_CHILD_LOG => 'var/log/supervisor/';
const our $SUPERVISOR_PID => 'var/run/supervisor.pid';

sub run {
    my ($self) = @_;
    my $prog_name = basename($0);

    if ($prog_name eq 'soapbox-supervisorctl') {
        return $self->be_control;
    } elsif ($prog_name eq 'soapbox-supervisord') {
        return $self->be_daemon;
    }

    die "Don't know how to handle being '$prog_name'";
}

sub be_daemon {
    my ($self) = @_;
    my @args = (
        '--configuration', $SUPERVISOR_CONFIG,
        '--logfile', $SUPERVISOR_LOG,
        '--childlogdir', $SUPERVISOR_CHILD_LOG,
        '--pidfile', $SUPERVISOR_PID,
        '--identifier', $self->instance->id,
    );

    chdir($self->instance->root);
    create_directories();

    CORE::exec(
        $SUPERVISOR_DAEMON,
        @args, @ARGV,
    );

    die "exec() failed";
}

sub be_control {
    my ($self) = @_;
    my @args = (
        '--configuration', $SUPERVISOR_CONFIG,
    );

    chdir($self->instance->root);
    create_directories();

    CORE::exec(
        $SUPERVISOR_CONTROL,
        @args, @ARGV,
    );

    die "exec() failed";
}

sub create_directories {
    my @dirs = (dirname($SUPERVISOR_LOG), $SUPERVISOR_CHILD_LOG, dirname($SUPERVISOR_PID));

    CORE::system('mkdir', '-p', @dirs);
    die "system() failed" if $?;
}

__PACKAGE__->meta->make_immutable;
