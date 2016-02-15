set -e

VLC_REPO="https://github.com/RSATom/vlc.git"
VLC_CONTRIB_PKGCONFIG="$(pwd)/vlc/contrib/i686-w64-mingw32/lib/pkgconfig"
HOST=i686-w64-mingw32

if [ ! $JENKINS_URL ]; then
	sudo dpkg --add-architecture i386
	sudo apt-get -qq update
	sudo apt-get install -y gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools lua5.2:i386 build-essential autoconf libtool gettext p7zip-full
	sudo apt-get install tofrodos
	sudo ln -s /usr/bin/fromdos /usr/bin/dos2unix

	git clone --depth=1 $VLC_REPO vlc
fi

cd vlc

mkdir -p contrib/win32
cd contrib/win32
../bootstrap --host=$HOST
make prebuilt
rm -f ../i686-w64-mingw32/bin/moc ../i686-w64-mingw32/bin/uic ../i686-w64-mingw32/bin/rcc ../i686-w64-mingw32/bin/luac
cd ../..

./bootstrap
mkdir -p win32
cd win32
export PKG_CONFIG_LIBDIR=$VLC_CONTRIB_PKGCONFIG
../extras/package/win32/configure.sh --host=$HOST --disable-qt --disable-skins2

make -j2
make package-win32-debug-7zip
make package-win32-7zip
