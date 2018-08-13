### -*-Makefile-*- for GitLab page of Emacs Modified for macOS
##
## Copyright (C) 2018 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for macOS
## https://gitlab.com/vigou3/emacs-modified-macos


## Get variables and version strings from Makeconf, NEWS and
## README.txt files in master branch (version strings are computed in
## Makeconf, hence we cannot use them directly here)
REPOSURL = $(shell git show master:Makeconf \
	| grep ^REPOSURL \
	| cut -d = -f 2)
VERSION = $(shell git show master:NEWS \
	| awk '/^\# / { print $$3; exit }')
DISTNAME = Emacs-${VERSION}
ESSVERSION = $(shell git show master:README.txt \
	| awk '/^- ESS/ { print $$3; exit }' \
	| tr -d ";")
AUCTEXVERSION = $(shell git show master:README.txt \
	| awk '/^- AUCTeX/ { print $$3; exit }' \
	| tr -d ";")
ORGVERSION = $(shell git show master:README.txt \
	| awk '/^- org/ { print $$3; exit }' \
	| tr -d ";")
POLYMODEVERSION = $(shell git show master:README.txt \
	| awk '/^- polymode/ { print $$3; exit }' \
	| tr -d ";")
MARKDOWNMODEVERSION = $(shell git show master:README.txt \
	| awk '/^- markdown/ { print $$3; exit }' \
	| tr -d ";")
EXECPATHVERSION = $(shell git show master:README.txt \
	| awk '/^- exec-path/ { print $$3; exit }' \
	| tr -d ";")
PSVNVERSION = $(shell git show master:README.txt \
	| awk '/^- psvn/ { print $$3; exit }' \
	| tr -d ";")

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
	      -e 's/[0-9.-]+-modified-[0-9]+/${VERSION}/g' \
	      -e '/\[ESS\]/s/[0-9]+[0-9.]*/${ESSVERSION}/' \
	      -e '/\[AUCTeX\]/s/[0-9]+[0-9.]*/${AUCTEXVERSION}/' \
	      -e '/\[org\]/s/[0-9]+[0-9.]*/${ORGVERSION}/' \
	      -e '/\[polymode\]/s/[0-9]+[0-9\-]*/${POLYMODEVERSION}/' \
	      -e '/\[markdown-mode.el\]/s/[0-9]+[0-9.]*/${MARKDOWNMODEVERSION}/' \
	      -e '/\[exec-path-from-shell.el\]/s/[0-9]+[0-9.]*/${EXECPATHVERSION}/' \
	      -e '/\[psvn.el\]/s/r[0-9]+/r${PSVNVERSION}/' \
	       _index.md
	cd layouts/partials && \
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
