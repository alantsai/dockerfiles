FROM alpine:3.7

ENV YOUTUBE_DL_VERSION=2017.12.14 
ENV YOUTUBE_DL_DOWNLOAD_BASE_URL=https://github.com/rg3/youtube-dl/releases/download/${YOUTUBE_DL_VERSION}
ENV YOUTUBE_DL_DOWNLOAD_EXE_URL=${YOUTUBE_DL_DOWNLOAD_BASE_URL}/youtube-dl 
ENV YOUTUBE_DL_DOWNLOAD_SIG_URL=${YOUTUBE_DL_DOWNLOAD_BASE_URL}/youtube-dl.sig

RUN set -x \
 && apk add --no-cache ca-certificates curl ffmpeg python gnupg bash \
    # Install youtube-dl
    # https://github.com/rg3/youtube-dl
 && curl -Lo /usr/local/bin/youtube-dl ${YOUTUBE_DL_DOWNLOAD_EXE_URL} \
 && curl -Lo youtube-dl.sig  ${YOUTUBE_DL_DOWNLOAD_SIG_URL} \
 && gpg --keyserver keyserver.ubuntu.com --recv-keys '7D33D762FD6C35130481347FDB4B54CBA4826A18' \
 && gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' \
 && gpg --verify youtube-dl.sig /usr/local/bin/youtube-dl \
 && chmod a+rx /usr/local/bin/youtube-dl \
    # Clean-up
 && rm youtube-dl.sig \
 && apk del curl gnupg \
    # Create directory to hold downloads.
 && mkdir /downloads \
 && chmod a+rw /downloads \
    # Basic check it works.
 && youtube-dl --version

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

WORKDIR /downloads

VOLUME ["/downloads"]

COPY start-youtubedl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-youtubedl.sh

ENTRYPOINT ["/usr/local/bin/start-youtubedl.sh"]

CMD [ "help" ]