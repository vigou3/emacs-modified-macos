#! /bin/sh

. ./Makeconf

PREFIX=$VOLUME/$NAME-$VERSION/Emacs.app/Contents

cd ess-*

## Edit ESS Makeconf file for our purposes
cp -p Makeconf Makeconf.orig
sed -i "" '/^DESTDIR/s|/usr/local|'${PREFIX}'/Resources|' Makeconf
sed -i "" '/^EMACS/s|emacs|'${PREFIX}'/MacOS/Emacs|' Makeconf
sed -i "" '/^LISPDIR/s/share\/emacs\/site-lisp/site-lisp\/ess/' Makeconf
sed -i "" '/^ETCDIR/s/share\/emacs\///' Makeconf
sed -i "" '/^DOCDIR/s/share\///' Makeconf

## Fix bug in doc/Makefile
cp -p doc/Makefile doc/Makefile.orig
sed -i "" 's/$(INSTALLDIR) $(DOCDIR)/$(INSTALLDIR) $(DOCDIR) $(DOCDIR)\/html $(DOCDIR)\/refcard/' doc/Makefile

## Don't install dvi version of the doc since this format in
## unreadable anyway on OS X
sed -i "" '/^all/s/dvi //' doc/Makefile
sed -i "" '/$(INSTALL)/{s/ess.dvi //;s/readme.dvi //;}' doc/Makefile

## Build and install
make clean
make all
make install
