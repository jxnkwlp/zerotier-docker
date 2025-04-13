ARG ALPINE_IMAGE=alpine
ARG ALPINE_VERSION=3.21
ARG ZT_COMMIT=185a3a2c76e6bf1b1c0415871f43076638eb007c
ARG ZT_VERSION=1.14.2

FROM ${ALPINE_IMAGE}:${ALPINE_VERSION} AS builder

ARG ZT_COMMIT

COPY patches /patches
COPY scripts /scripts

RUN apk add --update alpine-sdk linux-headers openssl-dev \
  && git clone --quiet https://github.com/zerotier/ZeroTierOne.git /src \
  && git -C src reset --quiet --hard ${ZT_COMMIT} \
  && cd /src \
  && git apply /patches/* \
  && make -f make-linux.mk

COPY custom /custom

RUN cp -rf /custom/* /src/ \
    && cd /src/attic/world \
    && chmod 0755 ./build-mkplanet.sh \
    && ./build-mkplanet.sh

FROM ${ALPINE_IMAGE}:${ALPINE_VERSION} AS runner

ARG ZT_VERSION

LABEL org.opencontainers.image.title="zerotier" \
      org.opencontainers.image.version="${ZT_VERSION}" \
      org.opencontainers.image.description="ZeroTier One as Docker Image" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/zyclonite/zerotier-docker"

COPY --from=builder /src/zerotier-one /scripts/entrypoint.sh /usr/sbin/
COPY --from=builder /src/attic/world/mkplanet /usr/local/bin/mkplanet

RUN apk add --no-cache --purge --clean-protected libc6-compat libstdc++ \
  && mkdir -p /var/lib/zerotier-one \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli \
  && rm -rf /var/cache/apk/*

COPY planet.json /var/lib/zerotier-one/planet-source.json

EXPOSE 9993/udp

ENTRYPOINT ["entrypoint.sh"]

CMD ["-U"]
