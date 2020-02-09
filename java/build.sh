#!/bin/bash

dirs=(jdk-1.8 jre-1.8)

for d in "${dirs[@]}"; do
  (cd $d; [ -e build.sh ] && ./build.sh)
done
