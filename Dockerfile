FROM debian:bookworm-slim
LABEL maintainer="Yoshiofthewire <Yoshi@urlxl.com>"
# Based on the work of gfjardim <gfjardim@gmail.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
ENV HOME="/root" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="UTC"

#########################################
##         SETUP DIRECTORIES           ##
#########################################
RUN mkdir -p /opt/hdhomerun /hdhomerun

#########################################
##         COPY FILES                  ##
#########################################
COPY hdhomerun.conf /etc/hdhomerun.conf
COPY hdhomerun_record_x64 /opt/hdhomerun/hdhomerun_record_x64
COPY hdhomerun_wrapper.sh /opt/hdhomerun/hdhomerun_wrapper.sh
COPY entrypoint.sh /entrypoint.sh
COPY install.sh /install.sh

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
RUN bash /install.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################
VOLUME /hdhomerun
EXPOSE 65001/udp 65002

ENTRYPOINT ["/entrypoint.sh"]
