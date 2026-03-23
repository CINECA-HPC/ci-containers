#!/usr/bin/env bash

. /opt/intel/oneapi/setvars.sh
export CC=icx
export CXX=icpx

exec "$@"
