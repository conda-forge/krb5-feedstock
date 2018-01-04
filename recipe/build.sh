#!/bin/bash

export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"

pushd src
  autoreconf -i
  ./configure --prefix=${PREFIX}    \
              --host=${HOST}        \
              --with-tcl=${PREFIX}  \
              --without-readline    \
              --with-libedit
  make -j${CPU_COUNT} ${VERBOSE_AT}
  if [ "${PY_VER}" == "2.7" ]; then
    make check
  fi
  make install
popd
