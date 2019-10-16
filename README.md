## nicklansley/allav Docker Image
This project builds an image that provides a complete self-contained library of the very best open-source audio, video, and text encoders, decoders and convertors using an "all batteries included" approach. This means that you can do just about anything these applications will let you because all libraries are compiled into the binary. 

From basic MPEG video to the latest HEVC and VP9 standards, from basic GSM audio to advanced Vorbis, AAC and lossless WAV compression (with MP3 right in the middle!) this should be everything
you need to get your multimedia encoded or converted to a format you wish.

I'll leave you to research and master all the command-line options available (especially for FFMPEG which has a huge range of options - <a href="https://ffmpeg.org/ffmpeg.html">click here to learn more</a>. 

allav is pronounced "orl-ay-vee"

Currently, the two installed applications are:
* <b>FFMPEG  </b><i>v4.2.1 "Ada"</i> - powerful program that can convert just about any media file to just about any other format!
* <b>LAME  </b><i>v3.99.5</i> - popular MP3 encoder to create the very best MP3s.

Both applications are compiled from source code so a first run of the Dockerfile will take a few minutes
while all this happens. I chose the Ubuntu v19.04.3 LTS (Bionic) Linux image as it has the all the needed libraries in apt, and compatible with the source libraries and compilers used.

To pull and build the image using Docker (as it is in Docker Hub):
<pre>docker pull nicklansley/allav:latest</pre>

Otherwise you will need to build it by opening a terminal window in the root of this repository and running this command:
<pre>docker build -t allav .</pre>
The build will take a while because a serious amount of compiling of source code takes place, especially
for FFMPEG. Pulling a ready-made image from Docker Hub is there for a reason...! 

### A note on the Fraunhofer IIS FDK AAC Encoding library
The library <b>libfdk-aac</b> is not enabled in the 'docker pull' image, as this Fraunhofer IIS FDK AAC Encoding library
is not allowed to be distributed as a binary part of FFMPEG due to GPL licensing. However, if you uncomment two lines
highlighted in Dockerfile in this repository, this library will be compiled into your own FFMPEG application when you run the above <b><i>docker build</i></b> command without any legal issues.
* <a href="http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AA">Click here to read more about Fraunhofer IIS FDK AAC Encoding library and understand licensing terms</a>.

### How to use this docker image to convert your audio/video files
Using 'docker run' you attach a volume of any name to a host directory where your media file is stored and then run either FFMPEG or LAME on the file in the attached volume name. 

In the examples below, a directory called '/av' is created within the container, which maps to the current directory on your host computer (in this case I am using Windows Powershell and ${PWD} is a variable describing the current working directory). 
You then tell FFMPEG or LAME where the input file is and where the output will be saved by using the file path in the format '/av/myfile'. 

Take a look at these examples (you are welcome to test
with the video file 'nicklansley-allav-testfile.mp4' included in this repository):

1 > Use FFMPEG to extract the audio from the video file into a WAV file:
<pre>docker run -v ${PWD}:/av/ allav ffmpeg -i /av/nicklansley-allav-testfile.mp4 /av/audiofromvideo.wav</pre>
2 > Use LAME to convert the WAV file to MP3 format:
<pre>docker run -v ${PWD}:/av/ allav lame -h -V 0  /av/audiofromvideo.wav /av/audiofromvideo.mp3</pre>
3 > Here I use FFMPEG to convert an MP4 file in my Windows Downloads folder to Windows WMV format:
<pre>docker run -v C:\Users\nick\Downloads:/av/ allav ffmpeg -i /av/nicklansley-allav-testfile.mp4 /av/nicklansley-allav-testfile.wmv</pre>
4 > Here I use FFMPEG to extract image frames from the video file at 1 second intervals (in terms of file realtime playback) and save them as incremental PNG image files:
<pre>docker run -v C:\Users\nick\Downloads:/av/ allav ffmpeg -i /av/nicklansley-allav-testfile.mp4 -r 1 -f image2 image-%2d.png</pre>

### Which FFMPEG Libraries have been enabled?
As well as the standard libraries for video, audio and image that is native to FFMPEG, the following external
libraries have been compiled into the version used in this image. <a href="https://ffmpeg.org/ffmpeg-codecs.html">For more details - and examples of use - for each of the codecs here</a>.
<table border="1">
<tr><td>libfdk-aac</td><td>AAC audio encoder (not enabled by default due to GPL licensing reasons but uncomment highlighted lines in the Dockerfile to include this library in your own Docker image). See the <a href="https://trac.FFMPEG.org/wiki/Encode/AAC">AAC Audio Encoding Guide</a> for more information and usage examples.</td></tr>
<tr><td>libfreetype </td><td>Library to take a video file or image and render text on it - <a href="https://stackoverflow.com/questions/10914411/how-to-add-text-to-video-with-ffmpeg-without-vhook">example in this StackOverflow answer</a></td><</td></tr>
<tr><td>libmp3lame</td>MP3 audio encoder. The guide to using the MP3 Lame library in FFMPEG is here: <a href="https://trac.ffmpeg.org/wiki/Encode/MP3">https://trac.ffmpeg.org/wiki/Encode/MP3</a><td></td></tr>
<tr><td>libopus</td><td>Opus audio decoder and encoder designed for interactive speech and audio transmission over the Internet. It is designed by the IETF Codec Working Group and incorporates technology from Skype's SILK codec and Xiph.Org's CELT codec.</td></tr>
<tr><td>libtheora</td><td>Theora, the free and open video compression format from the Xiph.org Foundation</td></tr>
<tr><td>libvorbis</td><td>Ogg Vorbis is a fully open, non-proprietary, patent-and-royalty-free, general-purpose compressed audio format for mid to high quality (8kHz-48.0kHz, 16+ bit, polyphonic) audio and music at fixed and variable bitrates from 16 to 128 kbps/channel. See <a href="https://xiph.org/vorbis/">https://xiph.org/vorbis/</a> for more information</td></tr>
<tr><td>libvpx</td><td>VP8/VP9 video encoder/decoder. See the <a href="https://trac.FFMPEG.org/wiki/Encode/VP9">VP9 Video Encoding Guide</a> for more information and usage examples.</td></tr>
<tr><td>libwavpack</td><td>Looless audio compression of WAV files. From Wikipedia: "avPack compression (.WV files) can compress (and restore) 8-, 16-, 24-, and 32-bit fixed-point, and 32-bit floating point audio files in the .WAV file format. It also supports surround sound streams and high frequency sampling rates. Like other lossless compression schemes, the data reduction rate varies with the source, but it is generally between 30% and 70% for typical popular music and somewhat better than that for classical music and other sources with greater dynamic range"</td></tr>
<tr><td>libx264</td><td>H.264 video encoder. See the <a href="https://trac.FFMPEG.org/wiki/Encode/H.264">H.264 Encoding Guide</a> for more information and usage examples.</td></tr>
<tr><td>libx265</td><td>>H.265/HEVC video encoder. See the <a href="https://trac.FFMPEG.org/wiki/Encode/H.265">H.265 Encoding Guide</a> for more information and usage examples.</td></tr>
<tr><td>libgsm</td><td>From <a href="https://launchpad.net/libgsm">https://launchpad.net/libgsm</a>: "an implementation of the European GSM 06.10 provisional standard for full-rate speech transcoding, prI-ETS 300 036, which uses RPE/LTP (residual pulse excitation/long term prediction) coding at 13 kbit/s."</td></tr>
<tr><td>libopencore-amrnb</td><td>Adaptive Multi Rate Narrowband (AMR-NB) speech codec</td></tr>
<tr><td>libopencore-amrwb</td><td>Adaptive Multi Rate Narrowband (AMR-WB) speech codec</td></tr>
<tr><td>libtwolame</td><td>TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder based on tooLAME by Mike Cheng, which in turn is based upon the ISO dist10 code and portions of LAME. </td></tr>
<tr><td>libvo-amrwbenc</td><td>An encoder implementation of the Adaptive Multi
                               Rate Wideband (AMR-WB) audio codec. The library is based on a codec
                               implementation by VisualOn as part of the Stagefright framework from
                               the Google Android project.</td></tr>
<tr><td>libxvid</td><td>Xvid is an implementation of an MPEG-4 video codec</td></tr>
</table>