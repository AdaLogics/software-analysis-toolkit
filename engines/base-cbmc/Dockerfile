FROM adalogics.com/software-analysis-toolkit/base-clang

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y

COPY build_cbmc.sh $WORK/
RUN $WORK/build_cbmc.sh
