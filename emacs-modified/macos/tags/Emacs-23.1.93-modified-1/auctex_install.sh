#! /bin/sh

. ./Makeconf

PREFIX=$VOLUME/$NAME-$VERSION/Emacs.app/Contents

cd auctex-*
./configure --datarootdir=${PREFIX}/Resources --without-texmf-dir \
    --with-lispdir=${PREFIX}/Resources/site-lisp \
    --with-emacs=${PREFIX}/MacOS/Emacs
make clean
make
make install
