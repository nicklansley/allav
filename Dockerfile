FROM ubuntu:20.04 AS compilation_build
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
    libxvidcore-dev \
    openssl \
    libssl-dev


# Build Lame v3.100 (gz file copied from https://sourceforge.net/projects/lame/ on 12 Jan 2021)
COPY lame-3.100.tar.gz .
RUN tar -xvf lame-3.100.tar.gz
WORKDIR /lame-3.100
RUN ./configure && make && make install
RUN ldconfig


# Build FFMpeg v4.3.1
WORKDIR /
RUN wget https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.gz
RUN tar -xvf ffmpeg-4.3.1.tar.gz
WORKDIR /ffmpeg-4.3.1
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
                --enable-openssl \
                 && make && make install

RUN ldconfig


FROM debian:bullseye-slim
COPY --from=compilation_build /usr/local/bin /usr/local/bin
COPY --from=compilation_build /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
WORKDIR /usr/local/bin
VOLUME /av
WORKDIR /av

