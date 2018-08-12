### -*-Makefile-*- for GitLab page of Emacs Modified for macOS
##
## Copyright (C) 2018 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for macOS
## https://gitlab.com/vigou3/emacs-modified-macos


## Get version strings from Makeconf
REPOSURL = $(shell git show master:Makeconf \
	| grep ^REPOSURL \
	| cut -d = -f 2)
VERSION = $(shell git show master:Makeconf \
	| grep ^VERSION \
	| cut -d = -f 2)
DISTNAME = $(shell git show master:Makeconf \
	| grep ^DISTNAME \
	| cut -d = -f 2)
ESSVERSION = $(shell git show master:Makeconf \
	| grep ^ESSVERSION \
	| cut -d = -f 2)
AUCTEXVERSION = $(shell git show master:Makeconf \
	| grep ^AUCTEXVERSION \
	| cut -d = -f 2)
ORGVERSION = $(shell git show master:Makeconf \
	| grep ^ORGVERSION \
	| cut -d = -f 2)
POLYMODEVERSION = $(shell git show master:Makeconf \
	| grep ^POLYMODEVERSION \
	| cut -d = -f 2)
MARKDOWNMODEVERSION = $(shell git show master:Makeconf \
	| grep ^MARKDOWNMODEVERSION \
	| cut -d = -f 2)
EXECPATHVERSION = $(shell git show master:Makeconf \
	| grep ^EXECPATHVERSION \
	| cut -d = -f 2)
PSVNVERSION = $(shell git show master:Makeconf \
	| grep ^PSVNVERSION \
	| cut -d = -f 2)

## GitLab repository and authentication
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Automatic variable
TAGNAME = v${VERSION}

all: files commit

files: 
	$(eval url=$(subst /,\/,$(patsubst %/,%,${REPOSURL})))
	$(eval file_id=$(shell curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	                             --silent \
	                             ${APIURL}/repository/tags/${TAGNAME} \
	                        | grep -o "/uploads/[a-z0-9]*/" \
	                        | cut -d/ -f3))
	cd content && \
	  sed -E -i "" \
	      -e 's/[0-9.]+-modified-[0-9]+/${VERSION}/g' \
	      -e '/\[ESS\]/s/[0-9]+[0-9.]*/${ESSVERSION}/' \
	      -e '/\[AUCTeX\]/s/[0-9]+[0-9.]*/${AUCTEXVERSION}/' \
	      -e '/\[org\]/s/[0-9]+[0-9.]*/${ORGVERSION}/' \
	      -e '/\[polymode\]/s/[0-9]+[0-9\-]*/${POLYMODEVERSION}/' \
	      -e '/\[markdown-mode.el\]/s/[0-9]+[0-9.]*/${MARKDOWNMODEVERSION}/' \
	      -e '/\[exec-path-from-shell.el\]/s/[0-9]+[0-9.]*/${EXECPATHVERSION}/' \
	      -e '/\[psvn.el\]/s/r[0-9]+/r${PSVNVERSION}/' \
	       _index.md
	cd layouts/partials && \
	  sed -E -i ""  \
	  awk 'BEGIN { FS = "/"; OFS = "/" } \
	       /${url}\/uploads/ { $$7 = "${file_id}"; \
	                           sub(/.*\.dmg/, "${DISTNAME}.dmg", $$8) } \
	       /${url}\/tags/ { $$7 = "${TAGNAME}" } 1' \
	       site-header.html > tmpfile && \
	  mv tmpfile site-header.html

commit:
	git commit content/_index.md layouts/partials/site-header.html \
	    -m "Updated web page for version ${VERSION}"
	git push
