# this file is intended to be sourced not executed

if [ -e "$(dirname ${BASH_SOURCE})/.soapbox" ]; then
    # the DPAN tooling needs improvement
    export SOAPBOX_ROOT="$(dirname $(realpath $BASH_SOURCE))"
    export SOAPBOX_BIN="$SOAPBOX_ROOT/bin"
    export SOAPBOX_SBIN="$SOAPBOX_ROOT/sbin"
    export SOAPBOX_LIB="$SOAPBOX_ROOT/lib"
    export SOAPBOX_ETC="$SOAPBOX_ROOT/etc"
    export SOAPBOX_MAN="$SOAPBOX_OPT/man:$SOAPBOX_OPT/share/man"
    export SOAPBOX_OPT="$SOAPBOX_ROOT/opt"
    export SOAPBOX_CHANNEL="$SOAPBOX_ROOT/channel"
    export SOAPBOX_SRC="$SOAPBOX_ROOT/src"
    export SOAPBOX_VAR="$SOAPBOX_ROOT/var"
    export SOAPBOX_LD_LIBRARY_PATH="$SOAPBOX_OPT/lib"
    export SOAPBOX_PKG_CONFIG_PATH="$SOAPBOX_OPT/lib/pkgconfig"
    export SOAPBOX_PERL_LOCAL_ROOT="$SOAPBOX_OPT/lib/soapbox/perl"

    export SOAPBOX_CONTRIB="$SOAPBOX_ROOT/contrib"
    export SOAPBOX_DPAN="$SOAPBOX_CONTRIB/dpan"

    export SOAPBOX_PATH="$SOAPBOX_BIN:$SOAPBOX_SBIN:$SOAPBOX_OPT/bin:$SOAPBOX_OPT/sbin"
    export SOAPBOX_MANPATH="$SOAPBOX_OPT/man:$SOAPBOX_OPT/share/man"

    for dir in ${SOAPBOX_ROOT}/src/*; do
        [ -d "$dir" ] || continue
        SOAPBOX_PERL_LIB="${SOAPBOX_PERL_LIB}:${dir}/lib"
        SOAPBOX_PATH="${SOAPBOX_PATH}:$dir/bin"
    done

    export SOAPBOX_PERL_LIB

    export PATH="$SOAPBOX_PATH:$SOAPBOX_ROOT/contrib/bin:$PATH"
    export MANPATH="$SOAPBOX_MAN:$MANPATH"
    export PERL5LIB="$SOAPBOX_PERL_LIB:$PERL5INC"
    export LD_LIBRARY_PATH="$SOAPBOX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
    export PKG_CONFIG_PATH="$SOAPBOX_PKG_CONFIG_PATH:$PKG_CONFIG_PATH"
else
    echo "Soapbox can only run out of the repository for now"
fi

# export SOAPBOX_PERL_LIBDIR="$SOAPBOX_ROOT/lib"
# export SOAPBOX_VARDIR="$SOAPBOX_ROOT/var/"
# export SOAPBOX_LOGDIR="$SOAPBOX_VARDIR/log"
# export SOAPBOX_SECDIR="$HOME/.config/fullduplexgeeks"
# export SOAPBOX_OPT="$SOAPBOX_ROOT/opt"
# export SOAPBOX_SHAREDIR="$SOAPBOX_ROOT/share"

# export SOAPBOX_LD_LIBRARY_PATH="$SOAPBOX_OPT/lib"
# export SOAPBOX_PKG_CONFIG_PATH="$SOAPBOX_OPT/lib/pkgconfig"
# export SOAPBOX_LV2_PATH="$SOAPBOX_OPT/lv2"
# export SOAPBOX_VST_PATH="$SOAPBOX_OPT/vst"
# export SOAPBOX_MAN="$SOAPBOX_OPT/man:$SOAPBOX_OPT/share/man"
# export SOAPBOX_VIRTENV_PATH="$SOAPBOX_OPT/lib/virtualenv/"

# export SOAPBOX_SUPERVISOR_PID_FILE="$SOAPBOX_VARDIR/tmp/supervisor.pid"
# export SOAPBOX_SUPERVISOR_CONF_FILE="$SOAPBOX_ETC/supervisor.conf"
# export SOAPBOX_SUPERVISOR_LOG_FILE="$SOAPBOX_LOGDIR/supervisor.log"

# export SOAPBOX_BROADCAST_MEDIA="$SOAPBOX_SHAREDIR/broadcast/media"

# export PATH="$SOAPBOX_PATH:$PATH"
# export MANPATH="$SOAPBOX_MAN:$MANPATH"
# export PERL5LIB="$SOAPBOX_PERL_LIBDIR:$PERL5INC"
# export LD_LIBRARY_PATH="$SOAPBOX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
# export PKG_CONFIG_PATH="$SOAPBOX_PKG_CONFIG_PATH:$PKG_CONFIG_PATH"
# export LV2_PATH="$SOAPBOX_LV2_PATH:$LV2_PATH"
# export VST3_PATH="$SOAPBOX_VST_PATH:$VST_PATH"
