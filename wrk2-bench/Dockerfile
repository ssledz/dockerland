FROM alpine:3.10.2 AS builder

WORKDIR /go/build

RUN apk --update add --virtual build-dependencies alpine-sdk curl openssl-dev zlib-dev \
    && curl "https://github.com/giltene/wrk2/archive/master.zip" -L -o master.zip \
    && unzip master.zip \
    && mv wrk2-master wrk2 \
    && cd wrk2 \
    && make

FROM alpine:3.10.2
RUN apk --update add libgcc
ENV LANG C.UTF-8
COPY --from=builder /go/build/wrk2/wrk /usr/bin/
COPY json.lua /usr/local/share/lua/5.1/
COPY do-test.lua /opt/wrk/scripts/
COPY docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /
CMD ["wrk", "--help"]
ONBUILD ENTRYPOINT ["/docker-entrypoint.sh"]
ONBUILD COPY . /opt/wrk/test
