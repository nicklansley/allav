FROM ubuntu:latest AS compilation_build
MAINTAINER nick@lansley.com

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y tzdata

RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y \
    wget \
    g++ \
    make \
    yasm \
    git \
    autoconf \
    libaom-dev \
    libfaac-dev \
    libfdk-aac-dev \
    libfreetype6-dev \
    libgsm1-dev \
    libmp3lame-dev \
    libnuma-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libopus-dev \
    libtheora-dev \
    libtwolame-dev \
    libvo-amrwbenc-dev \
    libvorbis-dev \
    libvpx-dev \
    libwavpack-dev \
    libx264-dev \
    libx265-dev \
    libxvidcore-dev


# Build Lame
RUN wget http://jaist.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
RUN tar -xvf lame-3.99.5.tar.gz
WORKDIR /lame-3.99.5
RUN ./configure && make && make install
RUN ldconfig


# Build FFMpeg
WORKDIR /
RUN wget https://ffmpeg.org/releases/ffmpeg-4.2.1.tar.gz
RUN tar -xvf ffmpeg-4.2.1.tar.gz
WORKDIR /ffmpeg-4.2.1
RUN ./configure --enable-gpl \
                --enable-libaom \
                --enable-libfdk-aac \
                --enable-libfreetype  \
                --enable-libgsm \
                --enable-libmp3lame \
                --enable-libopencore-amrnb \
                --enable-libopencore-amrwb \
                --enable-libopus \
                --enable-libtheora \
                --enable-libtwolame \
                --enable-libvo-amrwbenc \
                --enable-libvorbis \
                --enable-libvpx \
                --enable-libwavpack \
                --enable-libwavpack \
                --enable-libx264 \
                --enable-libx265 \
                --enable-libxvid \
                --enable-nonfree \
                --enable-version3 \
                 && make && make install

RUN ldconfig

# Empty the image of all that source code
RUN rm -rf /ffmpeg-4.2.1 && rm /ffmpeg-4.2.1.tar.gz && rm -rf /lame-3.99.5 && rm -rf /lame-3.99.5.tar.gz

FROM compilation_build

# Prepare the /av volume
VOLUME /av
WORKDIR /av

