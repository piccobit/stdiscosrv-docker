# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine:3.8@sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528

LABEL description="Docker image for running your own Syncthing Discovery Server."
LABEL maintainer="HD Stich <hd.stich.io>"

ENV STDISCOSRV_VERSION=v1.1.0
ENV STDISCOSRV_BINARY=stdiscosrv-linux-amd64-${STDISCOSRV_VERSION}

RUN apk add --update libc6-compat libstdc++ \
   && apk upgrade \
   && apk add --no-cache ca-certificates

RUN addgroup -g 1000 stdiscosrv \
    && adduser -D -G stdiscosrv -u 1000 stdiscosrv \
    && mkdir -p /etc/stdiscosrv \
    && chown stdiscosrv:stdiscosrv /etc/stdiscosrv

ADD https://github.com/syncthing/discosrv/releases/download/${STDISCOSRV_VERSION}/${STDISCOSRV_BINARY}.tar.gz /tmp

RUN tar -xf /tmp/${STDISCOSRV_BINARY}.tar.gz -C /tmp \
    && mv /tmp/${STDISCOSRV_BINARY}/stdiscosrv /bin/stdiscosrv \
    && rm -rf /tmp/${STDISCOSRV_BINARY} \
    && rm -rf /tmp/${STDISCOSRV_BINARY}.tar.gz

VOLUME /etc/stdiscosrv

EXPOSE 8443
EXPOSE 19200

WORKDIR /etc/stdiscosrv

USER stdiscosrv

CMD ["stdiscosrv"]
