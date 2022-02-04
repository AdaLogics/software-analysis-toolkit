FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y

ENV WORK=/work
RUN mkdir -p $WORK && chmod a+rwx $WORK

ENV WORKFLOWS=/workflows
COPY workflows $WORKFLOWS
