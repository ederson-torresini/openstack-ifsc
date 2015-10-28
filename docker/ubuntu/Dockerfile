FROM ubuntu:latest
MAINTAINER Ederson Torresini <boidacarapreta@gmail.com>

RUN export LANG=C && \
    export LANGUAGE=C && \
    export LC_ALL=C && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y sudo openssh-server curl supervisor && \
    groupadd ubuntu && \
    useradd -g ubuntu -G sudo -d /home/ubuntu -m -s /bin/bash ubuntu && \
    install -o ubuntu -m 0700 -d /home/ubuntu/.ssh && \
    echo 'ubuntu ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

ADD sshd_config /etc/ssh/
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.conf /etc/supervisor/conf.d/
ADD curl.conf /etc/supervisor/conf.d/

EXPOSE 22
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
