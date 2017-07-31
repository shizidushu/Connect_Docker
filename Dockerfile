FROM ubuntu:precise
MAINTAINER  Sean Lopp <sean@rstudio.com>


RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    gdebi-core \
    vim \
    wget


# install R apt
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo "deb https://cran.rstudio.com/bin/linux/ubuntu precise/" >> /etc/apt/sources.list.d/cran-rstudio.list

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get install r-base

# Install Connect
ARG CONNECT_BINARY_URL
RUN wget -O /rstudio-connect.deb $CONNECT_BINARY_URL  && \
    gdebi rstudio-connect.deb && \
    rm /rstudio-connect

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && chmod +x /usr/local/bin/dumb-init

# because licensing
RUN mkdir /var/lib/rstudio-connect

# Start in /connect (which is commonly mounted in) to make it easier to use
# this instance.
WORKDIR /connect
