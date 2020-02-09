#!/bin/bash
set -x

case "$1" in
build)
  cd /var/local
  pdflatex $2.tex
  biber $2
  pdflatex $2.tex
  ;;
make)
  cd /var/local
  shift
  make "$@"
  ;;
*)
  exec "$@"
  ;;
esac
