#!/bin/bash -eu
set -v

apt-get install -y flex bison curl patch cmake

git clone https://github.com/diffblue/cbmc
cd cbmc
git submodule update --init
cmake -DWITH_JBMC=OFF -S . -Bbuild
cmake --build build
