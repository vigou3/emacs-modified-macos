#! /bin/sh

. ./Makeconf

PREFIX=/Users/vincent/emacs-modified/trunk/$NAME-$VERSION/Emacs.app/Contents

cd auctex-*
./configure --datarootdir=${PREFIX}/Resources --without-texmf-dir \
    --with-lispdir=${PREFIX}/Resources/site-lisp \
    --with-emacs=${PREFIX}/MacOS/Emacs
make
make install
