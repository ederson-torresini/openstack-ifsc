FROM centos:latest
MAINTAINER Ederson Torresini <boidacarapreta@gmail.com>

RUN export LANG=C && \
    export LANGUAGE=C && \
    export LC_ALL=C && \
    yum install -y sudo bash openssh-server curl python-setuptools && \
    easy_install supervisor && \
    groupadd centos && \
    useradd -g centos -d /home/centos -m -s /bin/bash centos && \
    install -o centos -m 0700 -d /home/centos/.ssh && \
    echo 'centos ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/centos && \
    chmod 0440 /etc/sudoers.d/centos && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

ADD sshd_config /etc/ssh/
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd-keygen.conf /etc/supervisor/conf.d/
ADD sshd.conf /etc/supervisor/conf.d/
ADD curl.conf /etc/supervisor/conf.d/

EXPOSE 22
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
