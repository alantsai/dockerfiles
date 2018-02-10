FROM microsoft/aspnet:4.7.1-windowsservercore-ltsc2016

SHELL ["cmd", "/S", "/C"]

HEALTHCHECK --interval=20s --timeout=20s --retries=6 CMD powershell -file ./Tentacle/healthcheck-tentacle.ps1

EXPOSE 10933

VOLUME ["C:/Applications", "C:/TentacleHome"]

ADD Scripts/*.ps1 /
ADD Tentacle/Scripts/*.ps1 /Tentacle/
ADD source/ /Installers

ARG TentacleVersion
ARG BUILD_DATE
ARG VCS_REF
ENV TentacleVersion ${TentacleVersion}

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="Octopus Deploy Tentacle base on microsoft/aspnet" \
      org.label-schema.description="Octopus Deploy Tentacle base on microsoft/aspnet for easy test" \
      org.label-schema.url="https://github.com/alantsai/dockerfiles/tree/master/src/Octopus-Tentacle" \
      org.label-schema.vcs-url="https://github.com/alantsai/dockerfiles.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.version="v-octopus_tentacle-3.16.3-aspnet_4.7.1_windowsservercore_ltsc2016" \
      org.label-schema.vendor="Alan Tsai" \
      org.label-schema.docker.cmd="docker run --publish 10931:10933 --tty --interactive --env \"ListeningPort=10931\" --env \"ServerApiKey=API-L9WIFOCOWABUNGAQO6JMZIGWV6HI\" --env \"TargetEnvironment=Test\" --env \"TargetRole=app-server\" --env \"ServerUrl=https://octopus.example.com\"  --env \"PublicHostNameConfiguration=PublicIp\" alantsai/octopus-tentacle" \
      # org.label-schema.docker.help="docker run -it --rm alantsai/youtubedl help" \
      org.label-schema.schema-version="1.0.0-rc1"

RUN powershell -File ./install-base.ps1 -Msi "Octopus.Tentacle" -Verbose && powershell -File ./Tentacle/install-tentacle.ps1 -Verbose
ENTRYPOINT powershell -File ./Tentacle/configure-tentacle.ps1 -Verbose  && powershell -File ./Tentacle/run-tentacle.ps1 -Verbose
