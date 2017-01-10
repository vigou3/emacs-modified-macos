### -*-Makefile-*- for GitHub page of GNU Emacs Modified for macOS
##
## Copyright (C) 2014-2017 Vincent Goulet
##
## The code of this Makefile is based on a file created by Remko
## Troncon (http://el-tramo.be/about).
##
## Author: Vincent Goulet
##
## This file is part of GNU Emacs Modified for macOS
## http://github.com/vigou3/emacs-modified-macos

## Set most variables in Makeconf
include ./Makeconf

## Build directory et al.
TMPDIR=${CURDIR}/tmpdir
TMPDMG=${CURDIR}/tmpdmg.dmg
EMACSDIR=${TMPDIR}/Emacs.app

## Emacs specific info
PREFIX=${EMACSDIR}/Contents
EMACS=${PREFIX}/MacOS/Emacs
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file

## Override of ESS variables
DESTDIR=${PREFIX}/Resources
SITELISP=${DESTDIR}/site-lisp
#LISPDIR=${DESTDIR}/site-lisp
ETCDIR=${DESTDIR}/etc
DOCDIR=${DESTDIR}/doc
INFODIR=${DESTDIR}/info

## Directories of extensions
ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}
ORG=org-${ORGVERSION}

all : get-packages emacs release

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
	cp -p default.el ${SITELISP}/
	cp -p site-start.el ${SITELISP}/
	sed -e '/^(defconst/s/<DISTVERSION>/${DISTVERSION}/' \
	    version-modified.el.in > version-modified.el
	cp -p version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	cp -p framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	cp -p Emacs.icns ${DESTDIR}/

ess :
	@echo ----- Making ESS...
	${MAKE} EMACS=${EMACS} DOWNLOAD=curl -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	@echo ----- Done making ESS

auctex :
	@echo ----- Making AUCTeX...
	cd ${AUCTEX} && ./configure --datarootdir=${DESTDIR} \
		--without-texmf-dir \
		--with-lispdir=${SITELISP} \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	@echo ----- Done making AUCTeX

org :
	@echo ----- Making org...
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && cp -p ${ORG}/doc/*.pdf ${DOCDIR}/org/
	@echo ----- Done making org

polymode :
	@echo ----- Copying and byte compiling polymode files...
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	cp -p polymode/*.el polymode/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	cp -p polymode/readme.md ${DOCDIR}/polymode
	cp -p polymode/modes/readme.md ${DOCDIR}/polymode/developing.md
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying and byte compiling markdown-mode.el...
	cp -p markdown-mode/markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

execpath :
	@echo ----- Copying and byte compiling exec-path-from-shell.el...
	cp -p exec-path-from-shell/exec-path-from-shell.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/exec-path-from-shell.el
	@echo ----- Done installing exec-path-from-shell.el

psvn :
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el emacs-svn/psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done installing psvn.el

dmg :
	@echo ----- Signing the application...
	codesign --force --sign "Developer ID Application: Vincent Goulet" \
		${EMACSDIR}

	@echo ----- Creating disk image...
	if [ -e ${TMPDMG} ]; then rm ${TMPDMG}; fi
	hdiutil create ${TMPDMG} \
		-size 200m \
	 	-format UDRW \
		-fs HFS+ \
		-srcfolder ${TMPDIR} \
		-volname ${DISTNAME} \
		-quiet

	@echo ----- Mounting disk image...
	hdiutil attach ${TMPDMG} -noautoopen -quiet

	@echo ----- Populating top level image directory...
	sed -e 's/<ESSVERSION>/${ESSVERSION}/'          \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/' \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<EXECPATHVERSION>/${EXECPATHVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/' \
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

create-release :
	@echo ----- Creating release on GitHub...
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	git commit -a -m "Version ${VERSION}" && git push
	@echo '{"tag_name": "v${VERSION}",' > relnotes.in
	@echo ' "name": "GNU Emacs Modified for macOS ${VERSION}",' >> relnotes.in
	@echo '"body": "' >> relnotes.in
	@awk '/${VERSION}/{flag=1; next} /^Version/{flag=0} flag' NEWS \
	     | tail +3 | tail -r | tail +3 | tail -r | sed 's|$$|\\n|' >> relnotes.in
	@echo '", "draft": false, "prerelease": false}' >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload : 
	@echo ----- Getting upload URL from GitHub...
	$(eval upload_url=$(shell curl -s ${REPOSURL}/releases/latest \
	 			  | grep "^  \"upload_url\""  \
	 			  | cut -d \" -f 4            \
	 			  | cut -d { -f 1))
	@echo ${upload_url}
	@echo ----- Uploading the disk image to GitHub...
	curl -H 'Content-Type: application/zip' \
	     -H 'Authorization: token ${OAUTHTOKEN}' \
	     --upload-file ${DISTNAME}.dmg \
             -s -i "${upload_url}?&name=${DISTNAME}.dmg"
	@echo ----- Done uploading the disk image

publish :
	@echo ----- Publishing the web page...
	${MAKE} -C doc

get-emacs :
	@echo ----- Fetching Emacs...
	rm -rf ${DMGFILE}
	curl -O -L http://emacsformacosx.com/emacs-builds/${DMGFILE}

get-ess :
	@echo ----- Fetching and unpacking ESS...
	rm -rf ${ESS}
	curl -O http://ess.r-project.org/downloads/ess/${ESS}.zip && unzip ${ESS}.zip

get-auctex :
	@echo ----- Fetching and unpacking AUCTeX...
	rm -rf ${AUCTEX}
	curl -O http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip && unzip ${AUCTEX}.zip

get-org :
	@echo ----- Fetching and unpacking org...
	rm -rf ${ORG}
	curl -O http://orgmode.org/${ORG}.zip && unzip ${ORG}.zip

get-polymode :
	@echo ----- Preparing polymode
	git submodule update --remote markdown-mode

get-markdownmode :
	@echo ----- Preparing markdown-mode
	git submodule update --remote markdown-mode

get-execpath :
	@echo ----- Preparing exec-path-from-shell
	git submodule update --remote exec-path-from-shell

get-psvn :
	@echo ----- Preparing psvn.el
	svn update emacs-svn

clean :
	rm ${DISTNAME}.dmg
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean
