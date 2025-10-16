#!/usr/bin/env bash

export CC=nvcc
export CXX=nvcc

exec "$@"
