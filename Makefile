# Makefile for GNU Emacs.app Modified

# Copyright (C) 2010 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs.app Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a disk image to distribute a single
# architecture or universal version of GNU Emacs. For a universal
# build, two separate builds (i386 and ppc) are needed.
#
# The code of this Makefile is based on a file created by Remko
# Troncon (http://el-tramo.be/about).

# Set most variables in Makeconf
include ./Makeconf

TMPDIR=${CURDIR}/tmpdir
TMPDMG=${CURDIR}/tmpdmg.dmg
EMACSDIR=${TMPDIR}/Emacs.app
PREFIX=${EMACSDIR}/Contents
EMACS=${PREFIX}/MacOS/Emacs

RSYNC=rsync -n -avu --exclude="*~"

TARGET="10.4"
CFLAGS="-arch ${ARCH}"
LDFLAGS="-arch ${ARCH}"

# To override ESS variables defined in Makeconf
DESTDIR=${PREFIX}/Resources
LISPDIR=${DESTDIR}/site-lisp/ess
ETCDIR=${DESTDIR}/etc/ess
DOCDIR=${DESTDIR}/doc/ess

ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}

# The MacOS, MacOS/bin/ and MacOS/libexec/ contain binary files,
# scripts and symlinks. The binaries need to go through lipo, whereas
# the scripts and symlinks need only to be copied. (Needed for
# universal builds only.)
BINARIES=`find ${CURDIR}/emacs-${EMACSVERSION}/nextstep/Emacs.app/Contents/MacOS \
	-type f | xargs file | grep Mach-O | cut -d : -f 1 | cut -d / -f 11-12`
SCRIPTS=`find ${CURDIR}/emacs-${EMACSVERSION}/nextstep/Emacs.app/Contents/MacOS \
	-type f | xargs file | grep script | cut -d : -f 1 | cut -d / -f 11-12`
SYMLINKS=`find ${CURDIR}/emacs-${EMACSVERSION}/nextstep/Emacs.app/Contents/MacOS/bin \
	-type l | cut -d / -f 11-12`

all : emacs.app emacs ess auctex dmg

.PHONY : emacs.app emacs dir ess auctex dmg www clean

emacs.app :
	@echo ----- Building Emacs.app...
	if [ ! -d ${TMPDIR} ]; then mkdir ${TMPDIR}; fi
	cd emacs-${EMACSVERSION} && \
		env LC_ALL=C LANG=C CFLAGS=${CFLAGS} LDFLAGS=${LDFLAGS} \
		MACOSX_DEPLOYMENT_TARGET=${TARGET} \
		./configure --with-ns
	${MAKE} -C emacs-${EMACSVERSION} clean
	env MACOSX_DEPLOYMENT_TARGET=${TARGET} \
		${MAKE} -C emacs-${EMACSVERSION} install

emacs : dir ess auctex dmg

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	ditto -rsrc ${CURDIR}/emacs-${EMACSVERSION}/nextstep/Emacs.app/ \
		${EMACSDIR}
ifeq (${UNIVERSAL},1)
	ditto -rsrc ${CURDIR}/Emacs.app-${OTHERARCH}/Contents/MacOS/ \
		${PREFIX}/MacOS-${OTHERARCH}
	mv ${PREFIX}/MacOS ${PREFIX}/MacOS-${ARCH}
	mkdir -p ${PREFIX}/MacOS/bin ${PREFIX}/MacOS/libexec
	cd ${PREFIX} && echo ${BINARIES} | xargs -n1 -I % \
		lipo -create MacOS-${ARCH}/%              \
	        	     MacOS-${OTHERARCH}/%         \
		     -output MacOS/%
	cd ${PREFIX} && echo ${SCRIPTS} | xargs -n1 -I % \
		cp -p MacOS-i386/% MacOS/%
	cd ${PREFIX} && echo ${SYMLINKS} | xargs -n1 -I % \
		cp -R MacOS-i386/% MacOS/%
	rm -rf ${PREFIX}/MacOS-*
endif
	cp -p site-start.el ${PREFIX}/Resources/site-lisp/
	cp -p psvn.el ${PREFIX}/Resources/site-lisp/
	cp -p fixpath.el ${PREFIX}/Resources/site-lisp/
	cp -p framepop.el ${PREFIX}/Resources/site-lisp/
	cp -p Emacs.icns ${PREFIX}/Resources/
	cp -p emacs-document.icns ${PREFIX}/Resources/

auctex :
	@echo ----- Making AUCTeX...
	cd ${AUCTEX} && ./configure --datarootdir=${PREFIX}/Resources \
		--without-texmf-dir \
		--with-lispdir=${PREFIX}/Resources/site-lisp \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	@echo ----- Done making AUCTeX

ess :
	@echo ----- Making ESS...
	${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} LISPDIR=${LISPDIR} \
	        ETCDIR=${ETCDIR} DOCDIR=${DOCDIR} -C ${ESS} install
	@echo ----- Done making ESS

dmg :
	@echo ----- Creating disk image...
	if [ -e ${TMPDMG} ]; then rm ${TMPDMG}; fi
	hdiutil create ${TMPDMG} \
		-size 130m \
	 	-format UDRW \
		-fs HFS+ \
		-srcfolder ${TMPDIR} \
		-volname ${DISTNAME} \
		-quiet

	@echo ----- Mounting disk image...
	hdiutil attach ${TMPDMG} -noautoopen -quiet

	@echo ----- Populating top level image directory...
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/'          \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    README.txt.in > README.txt
	cp -p README.txt ${VOLUME}/${DISTNAME}/
	cp -p NEWS ${VOLUME}/${DISTNAME}/
	ln -s /Applications ${VOLUME}/${DISTNAME}/Applications

	@echo ----- Unmounting and compressing disk image...
	hdiutil detach ${VOLUME}/${DISTNAME} -quiet
	if [ -e ${DISTNAME}.dmg ]; then rm ${DISTNAME}.dmg; fi
	hdiutil convert ${TMPDMG} \
		-format UDZO \
		-imagekey zlib-level=9 \
		-o ${DISTNAME}.dmg -quiet

	rm -rf ${TMPDIR} ${TMPDMG}
	@echo ----- Done building the disk image

www :
	@echo ----- Updating web site...
	cp -p ${DISTNAME}.dmg ${WWWLIVE}/htdocs/pub/emacs/
	cp -p NEWS ${WWWLIVE}/htdocs/pub/emacs/NEWS-mac
	cd ${WWWSRC} && svn update
	cd ${WWWSRC}/htdocs/s/emacs/ &&                       \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/g'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/g' \
		    -e 's/<VERSION>/${VERSION}/g'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    mac.html.in > mac.html
	cp -p ${WWWSRC}/htdocs/s/emacs/mac.html ${WWWLIVE}/htdocs/s/emacs/
	cd ${WWWSRC}/htdocs/en/s/emacs/ &&                    \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/g'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/g' \
		    -e 's/<VERSION>/${VERSION}/g'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    mac.html.in > mac.html
	cp -p ${WWWSRC}/htdocs/en/s/emacs/mac.html ${WWWLIVE}/htdocs/en/s/emacs/
	cd ${WWWLIVE} && ls -lRa > ${WWWSRC}/ls-lRa
	cd ${WWWSRC} && svn ci -m "Update for Emacs Modified for OS X version ${VERSION}"
	svn ci -m "Version ${VERSION}"
	svn cp ${REPOS}/trunk ${REPOS}/tags/${DISTNAME} -m "Tag version ${VERSION}"
	@echo ----- Done updating web site

clean :
	rm ${DISTNAME}.dmg
	cd emacs-${EMACSVERSION} && ${MAKE} clean
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean