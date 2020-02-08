CREATE KEYSPACE test WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1};

CREATE TABLE test.user (
    email text PRIMARY KEY,
    username text,
    age int
);