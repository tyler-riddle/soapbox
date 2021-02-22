set(SOAPBOX_DISTFILES ${SOAPBOX_CONTRIB}/distfiles)
set(SOAPBOX_PATCHES ${SOAPBOX_CONTRIB})

set(SOAPBOX_CONTRIB_APT_INSTALL apt --yes install)

create_targets(contrib)

include(${SOAPBOX_CONTRIB}/cmake/perl.cmake)

list(
    APPEND SOAPBOX_CONTRIB_IMAGEMAGICK_PACKAGES

    libdb-dev libexpat1-dev pkg-config libxml2-dev libbz2-dev libfftw3-dev libfontconfig1-dev
    libfreetype6-dev libgomp1 libjpeg-dev  liblzma-dev libpng-dev libtiff5-dev libwebp-dev libwebpmux3
    libx11-dev libxext-dev libxml2-dev
)

add_custom_target(
    contrib-imagemagick-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_IMAGEMAGICK_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-imagemagick-install-packages)

ExternalProject_Add(
    contrib-imagemagick
    DEPENDS contrib-perl

    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL http://deb.debian.org/debian/pool/main/i/imagemagick/imagemagick_6.9.11.60+dfsg.orig.tar.xz
    URL_HASH SHA256=472fb516df842ee9c819ed80099c188463b9e961303511c36ae24d0eaa8959c4

    BUILD_IN_SOURCE ON
    CONFIGURE_COMMAND soapbox-contrib-imagemagick-configure ./configure --prefix=${CMAKE_INSTALL_PREFIX} --with-perl
    BUILD_COMMAND $(MAKE)
    # no easily identified test command found
    TEST_COMMAND  ""
    INSTALL_COMMAND $(MAKE) install
)

# Debian packages: libdb-dev
list(
    APPEND SOAPBOX_CONTRIB_IKIWIKI_PERL_MODULES
    CGI CGI::FormBuilder CGI::Session Date::Parse DB_File File::MimeInfo Mail::Sendmail
    Text::Markdown Text::Markdown::Discount HTML::Parser HTML::Scrubber HTML::Template
    HTML::TreeBuilder LWPx::ParanoidAgent RPC::XML YAML::XS XML::Feed XML::Simple XML::Twig
    URI YAML::XS

    # http://www.cpantesters.org/distro/U/URI-Fetch.html
    URI::Fetch@0.10
)

add_custom_target(
    contrib-ikiwiki-install-modules

    DEPENDS contrib-perl-bootstrap2
    COMMAND ${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_CONTRIB_IKIWIKI_PERL_MODULES}
)

ExternalProject_Add(
    contrib-ikiwiki
    DEPENDS contrib-perl contrib-ikiwiki-install-modules contrib-imagemagick

    STEP_TARGETS test
    TEST_BEFORE_INSTALL ON
    TEST_EXCLUDE_FROM_MAIN ON

    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL http://deb.debian.org/debian/pool/main/i/ikiwiki/ikiwiki_3.20200202.3.orig.tar.xz
    URL_HASH SHA256=594f13bcee8959356376a42eed6c5a8e295d325724b1c09f9395404e3262796a

    BUILD_IN_SOURCE ON
    CONFIGURE_COMMAND perl Makefile.PL
    BUILD_COMMAND $(MAKE) PREFIX=${CMAKE_INSTALL_PREFIX} SYSCONFDIR=${CMAKE_INSTALL_PREFIX}/etc/ikiwiki/
    TEST_COMMAND $(MAKE) PREFIX=${CMAKE_INSTALL_PREFIX} SYSCONFDIR=${CMAKE_INSTALL_PREFIX}/etc/ikiwiki/ test
    INSTALL_COMMAND $(MAKE) PREFIX=${CMAKE_INSTALL_PREFIX} SYSCONFDIR=${CMAKE_INSTALL_PREFIX}/etc/ikiwiki/ install
)

add_dependencies(contrib-test contrib-ikiwiki-test)

list(
    APPEND SOAPBOX_CONTRIB_OBS_STUDIO_PACKAGES

    # from the obs-studio apt package
    cmake gir1.2-rsvg-2.0 libasound2-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev
    libavutil-dev libcurl4-gnutls-dev libdbus-1-dev libfontconfig-dev libfreetype6-dev
    libgl1-mesa-dev libjack-jackd2-dev libjansson-dev libluajit-5.1-dev libmbedtls-dev
    libpulse-dev libqt5svg5-dev libqt5x11extras5-dev libspeexdsp-dev libswresample-dev libswscale-dev
    libudev-dev libv4l-dev libvlc-dev libx11-dev libx11-xcb-dev libx264-dev libxcb-randr0-dev libxcb-shm0-dev
    libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xinput-dev libxcomposite-dev libxinerama-dev python3-dev
    python3-docutils python3-gi-cairo qtbase5-dev swig
)

add_custom_target(
    contrib-obs-studio-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_OBS_STUDIO_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-obs-studio-install-packages)

set(SOAPBOX_CONTRIB_OBS_STUDIO_VERSION 26.1.1)
set(SOAPBOX_CONTRIB_OBS_STUDIO_HASH 19f55eac1c315a6101b024b44c858d1254e1a4a38d87d5e9c9a5274cc532a450)
set(SOAPBOX_CONTRIB_OBS_STUDIO_DOWNLOAD ${SOAPBOX_CONTRIB_OBS_STUDIO_VERSION}.tar.gz)
set(SOAPBOX_CONTRIB_OBS_STUDIO_STORE obs-studio-${SOAPBOX_CONTRIB_OBS_STUDIO_DOWNLOAD})

ExternalProject_Add(
    contrib-obs-studio

    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    DOWNLOAD_NAME ${SOAPBOX_CONTRIB_OBS_STUDIO_STORE}
    URL https://github.com/obsproject/obs-studio/archive/${SOAPBOX_CONTRIB_OBS_STUDIO_DOWNLOAD}
    URL_HASH SHA256=${SOAPBOX_CONTRIB_OBS_STUDIO_HASH}

    PATCH_COMMAND patch -p1 < ${SOAPBOX_PATCHES}/obs-studio+OBS_CONFIG_PATH.patch
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
)

set(SOAPBOX_CONTRIB_OBS_GSTREAMER_VERSION 0.3.0)
set(SOAPBOX_CONTRIB_OBS_GSTREAMER_HASH 0dc6c67391fa878598d3aed35b55240eec183a38272e7744b47fcff8ddccb491)
set(SOAPBOX_CONTRIB_OBS_GSTREAMER_DOWNLOAD v${SOAPBOX_CONTRIB_OBS_GSTREAMER_VERSION}.tar.gz)
set(SOAPBOX_CONTRIB_OBS_GSTREAMER_STORE obs-gstreamer-${SOAPBOX_CONTRIB_OBS_GSTREAMER_DOWNLOAD})
list(APPEND SOAPBOX_CONTRIB_OBS_GSTREAMER_PACKAGES meson)

add_custom_target(
    contrib-obs-gstreamer-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_OBS_STUDIO_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-obs-gstreamer-install-packages)

ExternalProject_Add(
    contrib-obs-gstreamer
    DEPENDS contrib-obs-studio

    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    DOWNLOAD_NAME ${SOAPBOX_CONTRIB_OBS_GSTREAMER_STORE}
    URL https://github.com/fzwoch/obs-gstreamer/archive/${SOAPBOX_CONTRIB_OBS_GSTREAMER_DOWNLOAD}
    URL_HASH SHA256=${SOAPBOX_CONTRIB_OBS_GSTREAMER_HASH}

    BUILD_IN_SOURCE ON
    CONFIGURE_COMMAND CFLAGS=-I${CMAKE_INSTALL_PREFIX}/include LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib meson configure
    BUILD_COMMAND CFLAGS=-I${CMAKE_INSTALL_PREFIX}/include LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib meson --buildtype=release build && CFLAGS=-I${CMAKE_INSTALL_PREFIX}/include LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib ninja -C build
    INSTALL_COMMAND cp build/obs-gstreamer.so ${CMAKE_INSTALL_PREFIX}/lib/obs-plugins/
)

add_custom_target(
    contrib-obs
    DEPENDS contrib-obs-studio contrib-obs-gstreamer
)

ExternalProject_Add(
    contrib-reaper

    URL https://www.reaper.fm/files/6.x/reaper623_linux_x86_64.tar.xz
    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL_HASH SHA256=8dc5cdccf4f21c021202260c2c0fc78ca42b29f2b14725211a078d89f3452ce9
    BUILD_IN_SOURCE ON

    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ./install-reaper.sh --install ${CMAKE_INSTALL_PREFIX}/lib
    INSTALL_COMMAND && mkdir -p ${CMAKE_INSTALL_PREFIX}/bin
    INSTALL_COMMAND && ln -f -s ${CMAKE_INSTALL_PREFIX}/lib/REAPER/reaper ${CMAKE_INSTALL_PREFIX}/bin/reaper
)

list(
    APPEND SOAPBOX_CONTRIB_QJACKCTL_PACKAGES
    libasound2-dev libjack-jackd2-dev qtbase5-dev qttools5-dev-tools libqt5x11extras5-dev libx11-dev
    jackd2
)

add_custom_target(
    contrib-qjackctl-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_QJACKCTL_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-qjackctl-install-packages)

ExternalProject_Add(
    contrib-qjackctl

    URL https://download.sourceforge.net/qjackctl/qjackctl-0.9.1.tar.gz
    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL_HASH SHA256=4fbe4c98ec5ce45efdd6a1088e2f5b208f5bcce994a8697b0bc96ecee99be254
    BUILD_IN_SOURCE ON

    PATCH_COMMAND patch -p1 < ${SOAPBOX_PATCHES}/qjackctl+QJACKCTL_CONFIG_ORG.patch
    CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
)

list(APPEND SOAPBOX_CONTRIB_NGINX_PACKAGES libssl-dev)

add_custom_target(
    contrib-nginx-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_NGINX_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-nginx-install-packages)

ExternalProject_Add(
    contrib-nginx

    URL https://nginx.org/download/nginx-1.18.0.tar.gz
    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL_HASH SHA256=4c373e7ab5bf91d34a4f11a0c9496561061ba5eee6020db272a17a7228d35f99

    BUILD_IN_SOURCE ON
    PATCH_COMMAND tar -zxvf ${SOAPBOX_CONTRIB}/nginx-rtmp-module-afd350e0d8b7820d7d2cfc3fa748217153265ce6.tar.gz
    CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX} --conf-path=/dev/null --pid-path=/dev/null --lock-path=/dev/null --error-log-path=/dev/null --http-log-path=/dev/null --add-module=nginx-rtmp-module/
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND install -D -t ${CMAKE_INSTALL_PREFIX}/sbin objs/nginx
)

list(
    APPEND SOAPBOX_CONTRIB_ZAM_PLUGINS_PACKAGES
    libx11-dev libgl-dev liblo-dev libjack-jackd2-dev ladspa-sdk libsamplerate0-dev libfftw3-dev nasm
)

add_custom_target(
    contrib-zam-plugins-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_ZAM_PLUGINS_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-zam-plugins-install-packages)

set(SOAPBOX_CONTRIB_ZAM_PLUGINS_VERSION 3.14)
set(SOAPBOX_CONTRIB_ZAM_PLUGINS_HASH 4a73a73fa03cc6d7faf2d65840349d2a33e7aaef5a13c6345f534b6c434e7b42)

ExternalProject_Add(
    contrib-dpf-08669d1

    URL https://github.com/DISTRHO/DPF/archive/08669d1.tar.gz
    DOWNLOAD_NAME dpf-08669d1.tar.gz
    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL_HASH SHA256=c4359020d1defb7ae2547b5dbdc0cf33f6e0e9cdd3ef75300533b4c4c9f1b9f4

    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

ExternalProject_Add(
    contrib-zam-plugins
    DEPENDS contrib-dpf-08669d1

    URL https://github.com/zamaudio/zam-plugins/archive/${SOAPBOX_CONTRIB_ZAM_PLUGINS_VERSION}.tar.gz
    DOWNLOAD_NAME zam-plugins-${SOAPBOX_CONTRIB_ZAM_PLUGINS_VERSION}.tar.gz
    DOWNLOAD_DIR ${SOAPBOX_DISTFILES}
    URL_HASH SHA256=${SOAPBOX_CONTRIB_ZAM_PLUGINS_HASH}

    BUILD_IN_SOURCE ON
    PATCH_COMMAND tar zxvf ${SOAPBOX_DISTFILES}/dpf-08669d1.tar.gz && ln -sf DPF-08669d1bc30c6e971fde800eade4ca40104ba8b2 dpf
    CONFIGURE_COMMAND ""
    BUILD_COMMAND PREFIX=${CMAKE_INSTALL_PREFIX} $(MAKE)
    INSTALL_COMMAND PREFIX=${CMAKE_INSTALL_PREFIX} $(MAKE) install
)
