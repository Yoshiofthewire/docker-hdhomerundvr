FROM phusion/ubuntu-lucid-32:latest
MAINTAINER Yoshiofthewire <Yoshi@urlxl.com>
#Based on the work of needo <needo@superhero.org>
#Based on the work of Eric Schultz <eric@startuperic.com>
#Based on the Limetech Plex Docker


# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Install hdhomerun dvr
ADD hdhomerun.conf /etc/
ADD install.sh /
RUN bash /install.sh

VOLUME /hdhomerun

EXPOSE 65001/udp 65002

# Use baseimage-docker's init system
CMD ["/etc/service/hdhomerun_record/run"]