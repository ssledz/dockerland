#!/bin/bash

readonly ready_port=${READY_PORT:-1234}
readonly init_state=/tmp/init

set -x

cqls() {
  ls -v /cassandra-init/*.cql /cassandra-init-extra/*.cql
}

touch "$init_state"

for f in $(cqls); do
  until cqlsh -f "$f" && echo "$f" >>"$init_state"; do
    echo "cqlsh: Cassandra is unavailable to initialize $f - will retry later"
    sleep 2
  done &
done

cnt=$(cqls | wc -l)
while true; do
  sleep 2
  if [[ $(cat "$init_state" | wc -l) == "$cnt" ]]; then
    echo 'Initialized'
    while true; do
      nc -lp "$ready_port"
      echo 'pong'
    done
    break
  else
    echo "cassandra not ready - will retry later"
  fi
done &

exec /docker-entrypoint.sh "$@"
