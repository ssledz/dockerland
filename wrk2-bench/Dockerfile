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
COPY --from=builder /go/build/wrk2/wrk /usr/bin/
WORKDIR /
ENV LANG C.UTF-8
CMD ["/usr/bin/wrk", "--help"]
