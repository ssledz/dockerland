#!/bin/sh
set -x

case "$1" in
wrk)
  shift
  cd /opt/wrk/test
  /usr/bin/wrk -s /opt/wrk/scripts/do-test.lua "$@"
  ;;
*)
  exec "$@"
  ;;
esac
