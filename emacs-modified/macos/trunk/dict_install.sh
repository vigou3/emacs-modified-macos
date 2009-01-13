#! /bin/sh

. ./Makeconf

PREFIX=/Users/vincent/emacs-modified/trunk/$NAME-$VERSION/Emacs.app/Contents
PATH=$PATH:${PREFIX}/MacOS/bin

for i in fr en de; do
    cd aspell-$i
    ASPELL=${PREFIX}/MacOS/bin/aspell ./configure
    make
    make install \
	datadir=${PREFIX}/Resources/aspell \
	dictdir=${PREFIX}/Resources/aspell
    cd ..
done
