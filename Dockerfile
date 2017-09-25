FROM whw3/golang:1.9-alpine as builder

ENV CADDY_VERSION v0.10.9

RUN apk-install git

WORKDIR /go/src
RUN mkdir -p github.com/mholt \
    && cd github.com/mholt \
    && git clone https://github.com/mholt/caddy.git \
    && go get -u github.com/caddyserver/builds
COPY plugins.go /go/src/github.com/mholt/caddy/caddy/caddymain/plugins.go

RUN cd github.com/mholt/caddy/caddy \
    && go get -u ./... \
    && git checkout -q ${CADDY_VERSION} \
    && go run build.go goos=linux

FROM whw3/alpine:latest

WORKDIR /srv
# ensure www-data user exists
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -H -h /srv -G www-data www-data && exit 0 ; exit 1
# 82 is the standard uid/gid for "www-data" in Alpine
RUN apk-install ca-certificates libcap
COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy \
    && /usr/bin/caddy -version
EXPOSE 80 443 2015
ENTRYPOINT ["/init"]
COPY rootfs /
