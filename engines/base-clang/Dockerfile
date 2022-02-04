# Install basic Ubuntu dependencies
FROM adalogics.com/software-analysis-toolkit/base
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libc6-dev binutils && \
    apt-get autoremove -y

# Now install basic setup.
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y \
        binutils-dev \
        build-essential \
        curl \
        git \
        jq \
        libc6-dev-i386 \
        subversion \
        zip flex bison autoconf

# Install our pythons
RUN apt-get install python -y
RUN apt-get install clang-12 -y

# Create symbolic links for the tools that we will often use.
RUN ln -s /usr/bin/clang-12 /usr/bin/clang
RUN ln -s /usr/bin/clang++-12 /usr/bin/clang++
RUN ln -s /usr/bin/llvm-profdata-12 /usr/bin/llvm-profdata
RUN ln -s /usr/bin/llvm-cov-12 /usr/bin/llvm-cov

# Install the bsdmainutils for tools like hexdump
RUN apt-get install bsdmainutils cmake -y

# Install VIM for easy editing
RUN apt-get update
RUN apt-get install vim -y

