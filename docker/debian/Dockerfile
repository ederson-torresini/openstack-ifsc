FROM debian:testing
MAINTAINER Ederson Torresini <boidacarapreta@gmail.com>

ENV LANG C
ENV LANGUAGE C
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y sudo bash openssh-server curl supervisor && \
    groupadd debian && \
    useradd -g debian -G sudo -d /home/debian -m -s /bin/bash debian && \
    install -o debian -m 0700 -d /home/debian/.ssh && \
    echo 'debian ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/debian && \
    chmod 0440 /etc/sudoers.d/debian && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD curl.conf /etc/supervisor/conf.d/
ADD sshd.conf /etc/supervisor/conf.d/

EXPOSE 22
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
