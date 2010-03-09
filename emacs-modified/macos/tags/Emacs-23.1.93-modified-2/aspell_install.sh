#! /bin/sh

. ./Makeconf

PREFIX=$VOLUME/$NAME-$VERSION/Emacs.app/Contents

cd aspell-0*
./configure --with-emacs=${PREFIX}/MacOS/Emacs \
    --prefix=${PREFIX} --bindir=${PREFIX}/MacOS/bin \
    --disable-shared --enable-static \
    --datarootdir=${PREFIX}/Resources \
    --enable-pkgdatadir=${PREFIX}/Resources/aspell \
    --enable-pkglibdir=${PREFIX}/Resources/aspell \
    --with-libiconv-prefix=/usr --enable-compile-in-filters \
    --disable-nls --disable-dependency-tracking
make clean
make
make libdir=/tmp/aspell includedir=/tmp/aspell install
rm -rf /tmp/aspell
