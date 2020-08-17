#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./src/config
set -x

export CPPFLAGS="${CPPFLAGS/-DNDEBUG/} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

if [[ ${HOST} =~ .*linux.* ]]; then
  export LDFLAGS="$LDFLAGS -Wl,--disable-new-dtags"
fi

# https://github.com/conda-forge/bison-feedstock/issues/7
export M4="${BUILD_PREFIX}/bin/m4"

if [[ "$target_platform" == osx-* ]]; then
    # This can't be deduced when cross-compiling
    export krb5_cv_attr_constructor_destructor=yes
fi

pushd src
  autoreconf -i
  ./configure --prefix=${PREFIX}          \
              --host=${HOST}              \
              --build=${BUILD}            \
              --with-tcl=${PREFIX}        \
              --without-readline          \
              --with-libedit              \
              --with-crypto-impl=openssl  \
              --without-system-verto

  make -j${CPU_COUNT} ${VERBOSE_AT}
  make install
popd
