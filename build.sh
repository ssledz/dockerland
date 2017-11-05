#!/bin/bash

dirs=(java)

for d in ${dirs[@]}; do
  (cd $d; ./build.sh)
done
