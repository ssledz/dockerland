FROM ubuntu:xenial

MAINTAINER ssledz <slawomir.sledz@gmail.com>

USER root

LABEL "java"="1.8"

ENV DEBIAN_FRONTEND noninteractive

RUN set -xe && \
  apt-get update && \
  apt-get install -y language-pack-en-base && \
  export LC_ALL=en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  apt-get install -y software-properties-common python-software-properties debconf-utils && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  apt-get install -y \
    oracle-java8-installer \
    oracle-java8-set-default \
    && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/java", "-version"]
