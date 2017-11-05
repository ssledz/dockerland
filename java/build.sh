#!/bin/bash

dirs=(jdk-1.8)

for d in ${dirs[@]}; do
  (cd $d; ./build.sh)
done
