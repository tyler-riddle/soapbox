# Testing

The "test" build target will run the software tests for a subset of the
software that comes from contrib as well as the tests for Soapbox. There
are also soapbox-test and contrib-test targets that are limited in scope
to only those parts of the system.

Note: The tests on the software from contrib will not execute twice but
the tests on the Soapbox projects will run unconditionally.

Here is an example of running the tests

  . setupenv.sh
  mkdir build
  cd build
  cmake ..
  cmake --build . --target contrib-test
  cmake --build . --target soapbox-test
  # test everything
  cmake --build . --target test

# Validating

The reference platform right now is Debian/stable which is currently Buster. There
is a command line tool and associated build target that will use debootstrap to
make a clean Debian/stable build and test environment. Validation involves setting
up this environment and running the test suite.

Note: Because the validation system uses debootstrap parts of it must be run as root

Performing validation looks like this. This example runs the entire validation
process as root. The validation tool handles sourcing setupenv.sh automatically:

  mkdir -p build/validate
  sudo ./bin/soapbox-validate --root build/validate --jobs 8 && echo Validation OK
