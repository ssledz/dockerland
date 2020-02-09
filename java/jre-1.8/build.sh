#!/bin/bash

dirs=(alpine)

for d in "${dirs[@]}"; do
  (cd $d; [ -e build.sh ] && ./build.sh)
done
