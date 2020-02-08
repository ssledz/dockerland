## run server
```bash
docker run -it --rm --name cassandra \
  -p 1234:1234 -p 9042:9042 \
  -v $(pwd)/cassandra-init-extra:/cassandra-init-extra \
  ssledz/cassandra
```

## connect to cassandra using cqlsh
```bash
docker exec -it cassandra cqlsh
```

## checking cassandra ready
```bash
nc -zv localhost 1234; echo $?
```