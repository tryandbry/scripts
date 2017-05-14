#!/bin/bash

##############
Reference: https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
Note: replaced $HOME/ffmpeg_build with  /usr/local/src/ffmpeg/build
Note: replaced $HOME/bin with /usr/local/bin
##############

#### install compilation dependencies
mount /dev/sr0 /mnt/dvd
yum install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y

mkdir -p /usr/local/src/ffmpeg/build
cd /usr/local/src/ffmpeg

#### YASM
cd /usr/local/src/ffmpeg
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="/usr/local/src/ffmpeg/build" --bindir="/usr/local/bin"
make
make install
echo

#### x264
cd /usr/local/src/ffmpeg
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="/usr/local/src/ffmpeg/build/lib/pkgconfig" ./configure --prefix="/usr/local/src/ffmpeg/build" --bindir="/usr/local/bin" --enable-static
make
make install
echo

#### x265
cd /usr/local/src/ffmpeg
hg clone https://bitbucket.org/multicoreware/x265
cd /usr/local/src/ffmpeg/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local/src/ffmpeg/build" -DENABLE_SHARED:bool=off ../../source
make
make install
echo

#### aac
cd /usr/local/src/ffmpeg
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local/src/ffmpeg/build" --disable-shared
make
make install
echo

#### lame mp3
cd /usr/local/src/ffmpeg
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="/usr/local/src/ffmpeg/build" --bindir="/usr/local/bin" --disable-shared --enable-nasm
make
make install
echo

#### opus
cd /usr/local/src/ffmpeg
git clone http://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
PKG_CONFIG_PATH="/usr/local/src/ffmpeg/build/lib/pkgconfig" ./configure --prefix="/usr/local/src/ffmpeg/build" --disable-shared
make
make install
echo

#### ogg
cd /usr/local/src/ffmpeg
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="/usr/local/src/ffmpeg/build" --disable-shared
make
make install
echo

#### vorbis
cd /usr/local/src/ffmpeg
cd /usr/local/src/ffmpeg
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="/usr/local/src/ffmpeg/build" --with-ogg="/usr/local/src/ffmpeg/build" --disable-shared
make
make install
echo

#### vpx
cd /usr/local/src/ffmpeg
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="/usr/local/src/ffmpeg/build" --disable-examples
make
make install
echo

#### ffmpeg
cd /usr/local/src/ffmpeg
curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PKG_CONFIG_PATH="/usr/local/src/ffmpeg/build/lib/pkgconfig" ./configure --prefix="/usr/local/src/ffmpeg/build" --extra-cflags="-I/usr/local/src/ffmpeg/build/include" --extra-ldflags="-L/usr/local/src/ffmpeg/build/lib -ldl" --bindir="/usr/local/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
make
make install
hash -r

