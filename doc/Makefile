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

all : 
	@echo ----- Updating the web page...
	sed -e 's/<ESSVERSION>/${ESSVERSION}/'       \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/'     \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<EXECPATHVERSION>/${EXECPATHVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/'     \
	    -e 's/<VERSION>/${VERSION}/g'             \
	    index.md.in > index.md
	sed -e 's/<VERSION>/${VERSION}/g'     \
	    -e 's/<DISTNAME>/${DISTNAME}/'      \
	    _layouts/default.html.in > _layouts/default.html
	@echo ----- Publishing the page on GitHub...
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push
	@echo ----- Done publishing

