FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DUCKSTATION_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=DuckStation

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/duckstation-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/stenzek/duckstation/releases/latest" \
    | awk -F '(": "|")' '/browser.*x64.AppImage/ {print $3}') && \
  curl -o \
    /tmp/duck.app -L \
    "${DOWNLOAD_URL}" && \
  cd /tmp && \
  chmod +x duck.app && \
  ./duck.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/duckstation && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
