## nicklansley/allav Docker Image
This project builds an image that provides a complete self-contained library of the very 
best open-source audio and video converters with an "all batteries included" approach so you can do just about anything
these libraries will let you! I'll leave you to research and master all the command-line options available, esepcially
 for ffmpeg(!). 

Currently, the two installed applications are:
* <b>ffmpeg  </b><i>v4.2.1 "Ada"</i> - powerful program that can convert just about any mdeia file to just about any other format!
* <b>lame  </b><i>v3.99.5</i> - popular MP3 encoder to create the very best MP3s.

Both applications are compiled from source code so a first run of the Dockerfile will take a few minutes
while all this happens. I chose the latest Debian linux image as it is fully stable and compatible with the 
source libraries and compilers used.

To pull and build the image:
<pre>docker pull nicklansley/allav</pre>
<pre>docker build -t allav .</pre>
Use the included video file nicklansley-allav-testfile.mp4 to show that a container built from the image is working (examples 
tested in Windows 10 PowerShell where ${PWD} is current directory).
1. Extract the audio from the video file into a WAV file:
<pre>docker run -v ${PWD}:/av/ allav ffmpeg -i /av/nicklansley-allav-testfile.mp4 /av/audiofromvideo.wav</pre>
2. Convert the WAV file to MP3:
<pre>docker run -v ${PWD}:/av/ allav lame -h -V 0   /av/audiofromvideo.wav /av/audiofromvideo.mp3</pre>

