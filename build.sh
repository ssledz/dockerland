#!/bin/bash

dirs=(java latex cassandra github-pages)

for d in ${dirs[@]}; do
  (cd $d; ./build.sh)
done
