FROM alpine:3.13.2@sha256:a75afd8b57e7f34e4dad8d65e2c7ba2e1975c795ce1ee22fa34f8cf46f96a3be

ENV JTS3_SERVER_MOD_VERSION=6.5.7
RUN echo "## Downloading ${JTS3_SERVER_MOD_VERSION} ##" && \
  apk add --no-cache libarchive-tools && \
  wget -qO- "https://www.stefan1200.de/downloads/JTS3ServerMod_HostingEdition_${JTS3_SERVER_MOD_VERSION}.zip" | bsdtar -xf- && \
  rm -R /JTS3ServerMod_HostingEdition/JTS3ServerMod-Windows* /JTS3ServerMod_HostingEdition/documents/ /JTS3ServerMod_HostingEdition/tools/ /JTS3ServerMod_HostingEdition/webinterface/


FROM openjdk:8u212-jre-alpine3.9@sha256:b2ad93b079b1495488cc01375de799c402d45086015a120c105ea00e1be0fd52
MAINTAINER EvilBlood (https://github.com/EvilBlood)
ENV JTS3_SERVER_MOD_VERSION=6.5.7

WORKDIR /JTS3ServerMod_HostingEdition
COPY --from=0 /JTS3ServerMod_HostingEdition .
VOLUME /JTS3ServerMod_HostingEdition/config /JTS3ServerMod_HostingEdition/plugins /JTS3ServerMod_HostingEdition/log

COPY docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["-mx30M"]

ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="JTS3ServerMod_HostingEdition" \
      org.label-schema.version="${JTS3_SERVER_MOD_VERSION}" \
      org.label-schema.description="JTS3ServerMod is a Teamspeak 3 server bot written in Java language" \
      org.label-schema.url="https://www.stefan1200.de/forum/index.php?topic=85.0" \
      org.label-schema.usage="https://www.stefan1200.de/documentation/jts3servermod_mysql/readme.html" \
      org.label-schema.vcs-url="https://github.com/EvilBlood/docker-JTS3ServerMod" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vendor="EvilBlood"
