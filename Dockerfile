FROM phusion/baseimage:0.9.16
MAINTAINER Yoshiofthewire <Yoshi@urlxl.com>
#Based on the work of gfjardim <gfjardim@gmail.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# Set correct environment variables
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]


#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
ADD hdhomerun.conf /etc/
ADD install.sh /
RUN bash /install.sh


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

VOLUME /hdhomerun
EXPOSE 65001/udp 65002

