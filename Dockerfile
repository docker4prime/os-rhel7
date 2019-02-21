# docker file for os-rhel7 image ith systemd enabled
# escape=`


# ====================================
# build production image (final stage)
# ====================================
# base image
FROM centos:centos7
MAINTAINER Fidy Andrianaivo (fidy@andrianaivo.org)
LABEL Description="RHEL7 base image"

# APP core dependencies
ARG REQUIRED_OS_PACKAGES="ansible cronie curl git htop net-tools openssh-clients openssh-server python2-pip rsync sudo"
ARG OPTIONAL_OS_PACKAGES

# APP environments
ARG APP_NAME="os-rhel7"
ENV APP_NAME ${APP_NAME}

# SYS environments
# -- timezone
ARG TZ="Europe/Vienna"
ENV TZ ${TZ}
# -- proxy
ARG HTTPS_PROXY=""
ENV http_proxy=${HTTPS_PROXY}
ENV https_proxy=${HTTPS_PROXY}

# copy files to root FS
COPY files/ /

# copy test files
COPY tests/ /tests/

# install os packages & setup system
RUN echo "export http_proxy=${HTTPS_PROXY}" >> /etc/profile \
    && echo "export https_proxy=${HTTPS_PROXY}" >> /etc/profile \
    && yum install -y epel-release \
    && yum update -y \
    && yum install -y ${REQUIRED_OS_PACKAGES} ${OPTIONAL_OS_PACKAGES} \
    && yum clean all \
    && systemctl enable sshd \
    && chmod 700 /root/.ssh \
    && chmod 600 /root/.ssh/id_ecdsa \
    && chmod 644 /root/.ssh/authorized_keys \
    && chmod 644 /root/.ssh/config

# expose proxy ports
EXPOSE 22

# use init as start command
CMD [ "/sbin/init" ]


# eof
