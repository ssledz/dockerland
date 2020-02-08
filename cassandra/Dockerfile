FROM cassandra:3.11.3

RUN set -xe && \
  apt-get update && \
  apt-get install -y netcat && \
  apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /cassandra-init-extra
COPY init /cassandra-init

CMD ["/bin/bash", "/cassandra-init/init.sh"]