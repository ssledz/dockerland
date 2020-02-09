#!/bin/bash

echo 'volume/kafka-ssl:latest'
[[ ! -e secrets ]] && ./gen-certs.sh || echo 'secrets exists'
[[ $? -ne 0 ]] && echo Error && exit 1
docker build -t ssledz/volume/kafka-ssl:latest .
