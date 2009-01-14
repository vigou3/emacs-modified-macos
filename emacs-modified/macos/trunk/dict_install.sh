#! /bin/sh

. ./Makeconf

PREFIX=$VOLUME/$NAME-$VERSION/Emacs.app/Contents
PATH=$PATH:${PREFIX}/MacOS/bin

for i in fr en de; do
    cd aspell-$i
    ASPELL=${PREFIX}/MacOS/bin/aspell ./configure
    make clean
    make
    make install \
	datadir=${PREFIX}/Resources/aspell \
	dictdir=${PREFIX}/Resources/aspell
    cd ..
done
