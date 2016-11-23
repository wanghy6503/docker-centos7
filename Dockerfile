FROM centos:7
MAINTAINER Anthony Wang "wanghy6503@gmail.com"

ENV ROOT_PASSWD EDIT_ME

ADD etc/profile.d/set_bash_environment.sh /etc/profile.d/
ADD etc/profile.d/mot.sh /etc/profile.d/

RUN chmod ogu+x /etc/profile.d/mot.sh

#config env.
RUN yum -y update && true
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install epel-release 
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN yum -y install wget tar unzip net-tools telnet openssh-server openssh-clients supervisor hostname
RUN yum reinstall -y glibc-common
RUN yum -y clean all
RUN localedef -i zh_TW -f UTF-8 zh_TW.UTF8
RUN rm -fr /var/log/*
RUN mkdir /var/log/supervisord

ENV LANG zh_TW.UTF-8

#timezone
ENV TIMEZONE Asia/Taipei
RUN echo ZONE="$TIMEZONE" > /etc/sysconfig/clock && \
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

#config sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key

RUN sed -r -i 's#logfile=/var/log/supervisor/supervisord.log#logfile=/var/log/supervisord.log#' /etc/supervisord.conf
RUN sed -r -i 's#files = supervisord.d/\*.ini#files = supervisord.d/\*.conf#' /etc/supervisord.conf
RUN sed -r -i 's#;childlogdir=/tmp#childlogdir=/var/log/supervisord#g' /etc/supervisord.conf
RUN sed -r -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

#change root password
RUN echo root:$ROOT_PASSWD | chpasswd

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#config supervisord
ADD /supervisord.conf /etc/
RUN mkdir /docker-entrypoint.d /logs /docker-entrypoint-ext.d
ADD supervisor_conf/* /etc/supervisord.d/
ADD entrypoint_sh/* /docker-entrypoint.d/
ADD docker-entrypoint.sh /

RUN chmod gou+x /docker-entrypoint.sh

VOLUME ["/docker-entrypoint-ext.d", "/logs"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD echo 'System starting up' && tail -f /var/log/supervisord.log
