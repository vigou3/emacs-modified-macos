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
DEFAULT = default.html

all : files commit

files : 
	sed -e 's/<ESSVERSION>/${ESSVERSION}/'       \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/'     \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<EXECPATHVERSION>/${EXECPATHVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/'     \
	    -e 's/<VERSION>/${VERSION}/g'             \
	    ${INDEX}.in > ${INDEX}
	sed -e 's/<VERSION>/${VERSION}/g'     \
	    -e 's/<DISTNAME>/${DISTNAME}/'      \
	    _layouts/${DEFAULT}.in > _layouts/${DEFAULT}

commit :
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push
