# Soapbox - A tool kit for speaking your mind on the Internet

Soapbox is a collection of tools for producing, publishing, and hosting
multimedia content to the Internet. The intent of the project is to
make it easy for content producers to get their content into the
hands of their audiences using standard Internet technology such
as static HTML websites and commercial platforms such as YouTube
and Odysee.

## Project status

This software is experimental and the only currently intended user is the author.
No promises are made for other people at this time. Changes will be made at will
and with out warning. Development is rapid and changes are huge and breaking.

Once things settle down and this software gets some tests I'll change that.

## Supported operating systems

Currently the only supported OS are Debian family GNU/Linux systems. There
is no intention for a hard dependency on either the Debian family or Linux
family of operating systems but your mileage my vary.

The author develops the software on a combination of KDE Neon LTS and standard
Debian/stable.

## Building

First source the contents of setupenv.sh in the root of this project:

  . setupenv.sh

Note: Currently setupenv.sh requires bash

Note: The build will fail unless the environment is setup correctly. There is a
check in the build process to ensure the failure happens as early as possible.

Then create a directory for the build to happen in and start it:

    mkdir build
    cd build
    cmake ..
    cmake --build . --target install-packages
    cmake --build .
    cmake --build . test

Note: You'll likely need to be root to run the install-packages target which
will install the required Debian packages automatically.

## More information

Look at the contents of the doc/ directory for more information.
