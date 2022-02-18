FROM adalogics.com/software-analysis-toolkit/base-clang

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y python3 python3-pip rsync
RUN apt-get install -y bzr python-lxml python-html5lib
RUN pip3 install atheris coverage pyinstaller

#COPY fuzz_test.py $WORK/
COPY work/* $WORK/
