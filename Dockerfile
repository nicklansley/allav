FROM debian:latest
MAINTAINER nick@lansley.com
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y wget g++ make yasm


RUN wget http://jaist.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
RUN tar -xvf lame-3.99.5.tar.gz
WORKDIR /lame-3.99.5
RUN ./configure && make && make install
RUN ldconfig

WORKDIR /
RUN wget https://ffmpeg.org/releases/ffmpeg-4.2.1.tar.gz
RUN tar -xvf ffmpeg-4.2.1.tar.gz
WORKDIR /ffmpeg-4.2.1
RUN ./configure && make && make install
RUN ldconfig

VOLUME /av
WORKDIR /av
#ENTRYPOINT ["lame"]

# Build:
# docker build -t allav .

# Run from command line as
#  docker run -v ${PWD}:/av/ allav ffmpeg -i /av/input.mp4 -vf scale=1280:-1 -c:v libx264 -preset veryfast -crf 24 /av/output.mp4
#  docker run -v ${PWD}:/av/ allav lame V 0 --vbr-new same as %s %d --preset extreme /av/input.wav /av/output.mp3