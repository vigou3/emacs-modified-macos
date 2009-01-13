#! /bin/sh

. ./Makeconf

PREFIX=/Users/vincent/emacs-modified/trunk/$NAME-$VERSION/Emacs.app/Contents

cd aspell-0*
./configure --with-emacs=${PREFIX}/MacOS/Emacs \
    --prefix=${PREFIX} --bindir=${PREFIX}/MacOS/bin \
    --disable-shared --enable-static \
    --datarootdir=${PREFIX}/Resources \
    --enable-pkgdatadir=${PREFIX}/Resources/aspell \
    --enable-pkglibdir=${PREFIX}/Resources/aspell \
    --with-libiconv-prefix=/usr --enable-compile-in-filters \
    --disable-nls --disable-dependency-tracking
make 
make libdir=/tmp/aspell includedir=/tmp/aspell install
rm -rf /tmp/aspell

# ./configure --exec-prefix="/Users/vincent/emacs-modified/trunk/Emacs.app/Contents/MacOS" --prefix="/Users/vincent/emacs-modified/trunk/Emacs.app/Contents/Resources/aspell" --libdir="/Users/vincent/emacs-modified/trunk/Emacs.app/Contents/Resources/aspell" --datarootdir="/Users/vincent/emacs-modified/trunk/Emacs.app/Contents/Resources" --enable-compile-in-filters --disable-dependency-tracking --disable-nls
