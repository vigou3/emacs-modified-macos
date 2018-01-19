### -*-Makefile-*- to build Emacs Modified for macOS
##
## Copyright (C) 2014-2017 Vincent Goulet
##
## The code of this Makefile is based on a file created by Remko
## Troncon (http://el-tramo.be/about).
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for macOS
## https://vigou3.github.io/emacs-modified-macos

## Emacs Modified for macOS is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3, or
## (at your option) any later version.
##
## GNU Emacs is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with GNU Emacs; see the file COPYING.  If not, write to the
## Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
## Boston, MA 02110-1301, USA.

## Set most variables in Makeconf
include ./Makeconf

## Build directory et al.
TMPDIR = ${CURDIR}/tmpdir
TMPDMG = ${CURDIR}/tmpdmg.dmg
EMACSDIR = ${TMPDIR}/Emacs.app

## Emacs specific info
PREFIX = ${EMACSDIR}/Contents
EMACS = ${PREFIX}/MacOS/Emacs
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file

## Override of ESS variables
DESTDIR = ${PREFIX}/Resources
SITELISP = ${DESTDIR}/site-lisp
#LISPDIR = ${DESTDIR}/site-lisp
ETCDIR = ${DESTDIR}/etc
DOCDIR = ${DESTDIR}/doc
INFODIR = ${DESTDIR}/info

## Base name of extensions
ESS = ess-${ESSVERSION}
AUCTEX = auctex-${AUCTEXVERSION}
ORG = org-${ORGVERSION}
POLYMODE = polymode-master

## Toolset
CP = cp -p
RM = rm -r

all : get-packages emacs

get-packages : get-emacs get-ess get-auctex get-org get-polymode get-markdownmode get-execpath get-psvn

emacs : dir ess auctex org polymode markdownmode execpath psvn dmg

release : create-release upload publish

.PHONY : emacs dir ess auctex org polymode psvn dmg release create-release upload publish clean

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	hdiutil attach ${DMGFILE} -noautoopen -quiet
	ditto -rsrc ${VOLUME}/Emacs/Emacs.app ${EMACSDIR}
	hdiutil detach ${VOLUME}/Emacs -quiet
	${CP} default.el ${SITELISP}/
	${CP} site-start.el ${SITELISP}/
	sed -E -i "" \
	    '/^\(defconst/s/(emacs-modified-version '"'"')[0-9]+/\1${DISTVERSION}/' \
	    version-modified.el && \
	  ${CP} version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	${CP} framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	${CP} Emacs.icns ${DESTDIR}/

ess :
	@echo ----- Making ESS...
	if [ -d ${ESS} ]; then rm -rf ${ESS}; fi
	unzip ${ESS}.zip
	${MAKE} EMACS=${EMACS} DOWNLOAD=curl -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	rm -rf ${ESS}
	@echo ----- Done making ESS

auctex :
	@echo ----- Making AUCTeX...
	if [ -d ${AUCTEX} ]; then rm -rf ${AUCTEX}; fi
	unzip ${AUCTEX}.zip
	cd ${AUCTEX} && ./configure --datarootdir=${DESTDIR} \
		--without-texmf-dir \
		--with-lispdir=${SITELISP} \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	rm -rf ${AUCTEX}
	@echo ----- Done making AUCTeX

org :
	@echo ----- Making org...
	if [ -d ${ORG} ]; then rm -rf ${ORG}; fi
	unzip ${ORG}.zip
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && ${CP} ${ORG}/doc/*.pdf ${DOCDIR}/org/
	rm -rf ${ORG}
	@echo ----- Done making org

polymode :
	@echo ----- Copying and byte compiling polymode files...
	if [ -d ${POLYMODE} ]; then rm -rf ${POLYMODE}; fi
	unzip ${POLYMODE}.zip
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	${CP} ${POLYMODE}/*.el ${POLYMODE}/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	${CP} ${POLYMODE}/readme.md ${DOCDIR}/polymode
	${CP} ${POLYMODE}/modes/readme.md ${DOCDIR}/polymode/developing.md
	rm -rf ${POLYMODE}
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying and byte compiling markdown-mode.el...
	${CP} markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

execpath :
	@echo ----- Copying and byte compiling exec-path-from-shell.el...
	${CP} exec-path-from-shell.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/exec-path-from-shell.el
	@echo ----- Done installing exec-path-from-shell.el

psvn :
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done installing psvn.el

dmg :
	@echo ----- Signing the application...
	codesign --force --sign "Developer ID Application: Vincent Goulet" \
		${EMACSDIR}

	@echo ----- Creating disk image...
	if [ -e ${TMPDMG} ]; then rm ${TMPDMG}; fi
	hdiutil create ${TMPDMG} \
		-size 250m \
	 	-format UDRW \
		-fs HFS+ \
		-srcfolder ${TMPDIR} \
		-volname ${DISTNAME} \
		-quiet

	@echo ----- Mounting disk image...
	hdiutil attach ${TMPDMG} -noautoopen -quiet

	@echo ----- Populating top level image directory...
	sed -E -i "" \
	    -e 's/[0-9.]+-modified-[0-9]/${VERSION}/' \
	    -e 's/(ESS )[0-9.]+/\1${ESSVERSION}/' \
	    -e 's/(AUCTeX )[0-9.]+/\1${AUCTEXVERSION}/' \
	    -e 's/(org )[0-9.]+/\1${ORGVERSION}/' \
	    -e 's/(polymode )[0-9\-]+/\1${POLYMODEVERSION}/' \
	    -e 's/(markdown-mode.el )[0-9.]+/\1${MARKDOWNMODEVERSION}/' \
	    -e 's/(exec-path-from-shell.el )[0-9.]+/\1${EXECPATHVERSION}/' \
	    -e 's/(psvn.el )[0-9]+/\1${PSVNVERSION}/' \
	    README.txt && \
	  ${CP} README.txt ${VOLUME}/${DISTNAME}/
	${CP} NEWS ${VOLUME}/${DISTNAME}/
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

create-release :
	@echo ----- Creating release on GitHub...
	@if [ -n "$(shell git status --porcelain | grep -v '^??')" ]; then \
	     echo "uncommitted changes in repository; not creating release"; exit 2; fi
	@if [ -n "$(shell git log origin/master..HEAD)" ]; then \
	    echo "unpushed commits in repository; pushing to origin"; \
	     git push; fi
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	touch relnotes.in
	awk 'BEGIN { ORS=" "; print "{\"tag_name\": \"v${VERSION}\"," } \
	      /^$$/ { next } \
              (state==0) && /^# / { state=1; \
	                            print "\"name\": \"Emacs Modified for macOS ${VERSION}\", \"body\": \""; \
	                             next } \
	      (state==1) && /^# / { state=2; print "\","; next } \
	      state==1 { printf "%s\\n", $$0 } \
	      END { print "\"draft\": false, \"prerelease\": false}" }' \
	      NEWS >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload :
	@echo ----- Getting upload URL from GitHub...
	$(eval upload_url=$(shell curl -s ${REPOSURL}/releases/latest \
	 			  | awk -F '[ {]' '/^  \"upload_url\"/ \
	                                    { print substr($$4, 2, length) }'))
	@echo ${upload_url}
	@echo ----- Uploading the disk image to GitHub...
	curl -H 'Content-Type: application/zip' \
	     -H 'Authorization: token ${OAUTHTOKEN}' \
	     --upload-file ${DISTNAME}.dmg \
             -s -i "${upload_url}?&name=${DISTNAME}.dmg"
	@echo ----- Done uploading the disk image

publish :
	@echo ----- Publishing the web page...
	${MAKE} -C docs
	@echo ----- Done publishing

get-emacs :
	@echo ----- Fetching Emacs...
	if [ -f ${DMGFILE} ]; then rm ${DMGFILE}; fi
	curl -O -L http://emacsformacosx.com/emacs-builds/${DMGFILE}

get-ess :
	@echo ----- Fetching ESS...
	if [ -d ${ESS}.zip ]; then rm ${ESS}.zip; fi
	curl -O http://ess.r-project.org/downloads/ess/${ESS}.zip

get-auctex :
	@echo ----- Fetching AUCTeX...
	if [ -f ${AUCTEX}.zip ]; then rm ${AUCTEX}.zip; fi
	curl -O http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip

get-org :
	@echo ----- Fetching org...
	if [ -f ${ORG}.zip ]; then rm ${ORG}.zip; fi
	curl -O https://orgmode.org/${ORG}.zip

get-polymode :
	@echo ----- Fetching polymode
	if [ -f ${POLYMODE}.zip ]; then rm ${POLYMODE}.zip; fi
	curl -L -o ${POLYMODE}.zip https://github.com/vspinu/polymode/archive/master.zip

get-markdownmode :
	@echo ----- Fetching markdown-mode.el
	if [ -f markdown-mode.el ]; then rm markdown-mode.el; fi
	curl -OL https://github.com/jrblevin/markdown-mode/raw/v${MARKDOWNMODEVERSION}/markdown-mode.el

get-execpath :
	@echo ----- Fetching exec-path-from-shell.el
	if [ -f exec-path-from-shell.el ]; then rm exec-path-from-shell.el; fi
	curl -OL https://github.com/purcell/exec-path-from-shell/raw/${EXECPATHVERSION}/exec-path-from-shell.el

get-psvn :
	@echo ----- Fetching psvn.el
	if [ -f psvn.el ]; then rm psvn.el; fi
	svn cat http://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs/psvn.el > psvn.el

clean :
	${RM} ${DISTNAME}.dmg
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean
