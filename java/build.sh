#!/bin/bash

dirs=(java-1.8)

for d in ${dirs[@]}; do
  (cd $d; ./build.sh)
done
