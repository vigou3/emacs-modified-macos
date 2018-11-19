### -*-Makefile-*- for GitLab page of Emacs Modified for macOS
##
## Copyright (C) 2018 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for macOS
## https://gitlab.com/vigou3/emacs-modified-macos


## Get variables and version strings from Makeconf in master branch
## (version strings are computed in Makeconf, hence we cannot use them
## directly here)
EMACSVERSION = $(shell git show master:Makeconf \
	| grep ^EMACSVERSION \
	| cut -d = -f 2)
EMACSPATCHLEVEL = $(shell git show master:Makeconf \
	| grep ^EMACSPATCHLEVEL \
	| cut -d = -f 2)
DISTVERSION = $(shell git show master:Makeconf \
	| grep ^DISTVERSION \
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
MARKDOWNMODEVERSION = $(shell git show master:Makeconf \
	| grep ^MARKDOWNMODEVERSION \
	| cut -d = -f 2)
EXECPATHVERSION = $(shell git show master:Makeconf \
	| grep ^EXECPATHVERSION \
	| cut -d = -f 2)
PSVNVERSION = $(shell git show master:Makeconf \
	| grep ^PSVNVERSION \
	| cut -d = -f 2)
REPOSURL = $(shell git show master:Makeconf \
	| grep ^REPOSURL \
	| cut -d = -f 2)

## GitLab repository and authentication
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Automatic variables
TAGNAME = v${VERSION}
VERSION=${EMACSVERSION}$(if ${EMACSPATCHLEVEL},-${EMACSPATCHLEVEL},)-modified-${DISTVERSION}
DISTNAME = Emacs-${VERSION}


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
