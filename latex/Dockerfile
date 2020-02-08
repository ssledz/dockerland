FROM ubuntu:bionic

MAINTAINER ssledz <slawomir.sledz@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN set -xe && \
  apt-get update && \
  apt-get install -y language-pack-en-base && \
  export LC_ALL=en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  apt-get install -y texlive-base texlive-lang-polish texlive-latex-extra texlive-latex-recommended biber texlive-fonts-extra make && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/pdflatex", "--version"]
