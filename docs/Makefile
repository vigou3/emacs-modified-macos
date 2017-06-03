### Makefile for GitHub page of GNU Emacs Modified for macOS
##
## Copyright (C) 2017 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of GNU Emacs for macOS Modified
## http://github.com/vigou3/emacs-modified-macos

## Get version strings in Makeconf
include ../Makeconf

INDEX = index.md
DEFAULT = _layouts/default.html

all: files commit

files: 
	awk '/\[ESS\]/ { $$3 = "${ESSVERSION}" } \
	     /\[AUCTeX\]/ { $$3 = "${AUCTEXVERSION}" } \
	     /\[org\]/ { $$3 = "${ORGVERSION}" } \
	     /\[polymode\]/ { $$3 = "${POLYMODEVERSION}" } \
	     /\[markdown-mode.el\]/ { $$3 = "${MARKDOWNMODEVERSION}" } \
	     /\[exec-path-from-shell.el\]/ { $$3 = "${EXECPATHVERSION}" } \
	     /\[psvn.el\]/ { $$3 = "${PSVNVERSION}" } \
	     /^## Latest/ { print; getline; print; getline; \
	                    print "Version ${VERSION}"; next } \
	     /^\[Release notes\]/ { FS = "/"; OFS = "/"; \
	                            $$4 = "v${VERSION}" } \
	     1' \
	     ${INDEX} > tmpfile && \
	  mv tmpfile ${INDEX}
	sed -E -i "" \
	    '/{{ site.github.releases_url }}/s/[0-9.]+-modified-[0-9]+/${VERSION}/g' \
	    ${DEFAULT}

commit:
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push
