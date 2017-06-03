### Makefile for GitHub page of Emacs Modified for macOS
##
## Copyright (C) 2017 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for macOS
## http://github.com/vigou3/emacs-modified-macos

## Get version strings in Makeconf
include ../Makeconf

## GitHub repository and authentication
REPOSURL=https://api.github.com/repos/vigou3/emacs-modified-macos
OAUTHTOKEN=$(shell cat ~/.github/token)

INDEX = index.md
DEFAULT = _layouts/default.html

all: files commit

files: 
	sed -E -i "" \
	    -e 's/[0-9.]+-modified-[0-9]+/${VERSION}/g' \
	    -e '/\[ESS\]/s/[0-9]+[0-9.]*/${ESSVERSION}/' \
	    -e '/\[AUCTeX\]/s/[0-9]+[0-9.]*/${AUCTEXVERSION}/' \
	    -e '/\[org\]/s/[0-9]+[0-9.]*/${ORGVERSION}/' \
	    -e '/\[polymode\]/s/[0-9]+[0-9\-]*/${POLYMODEVERSION}/' \
	    -e '/\[markdown-mode.el\]/s/[0-9]+[0-9.]*/${MARKDOWNMODEVERSION}/' \
	    -e '/\[exec-path-from-shell.el\]/s/[0-9]+[0-9.]*/${EXECPATHVERSION}/' \
	    -e '/\[psvn.el\]/s/r[0-9]+/r${PSVNVERSION}/' \
	     ${INDEX}
	sed -E -i ""  \
	    '/{{ site.github.releases_url }}/s/[0-9.]+-modified-[0-9]+/${VERSION}/g' \
	    ${DEFAULT}

commit:
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push
