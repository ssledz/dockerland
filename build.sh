#!/bin/bash

dirs=(java latex)

for d in ${dirs[@]}; do
  (cd $d; ./build.sh)
done
