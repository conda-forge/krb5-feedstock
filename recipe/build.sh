#!/bin/bash

pushd src
  autoreconf -i
  ./configure --prefix=${PREFIX}  \
              --host=${HOST}
  make -j${CPU_COUNT} ${VERBOSE_AT}
  if [ "${PY_VER}" == "2.7" ]; then
    make check
  fi
  make install
popd
