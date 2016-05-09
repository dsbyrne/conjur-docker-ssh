FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y openssh-server curl supervisor

RUN mkdir /var/run/sshd

ARG conjurize
RUN echo "$conjurize" | sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22

ENTRYPOINT ["supervisord"]