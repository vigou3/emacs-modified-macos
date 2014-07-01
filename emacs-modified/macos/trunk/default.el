;;; default.el --- Default configuration for GNU Emacs on OS X
;;; Used mainly to load custom extensions.
;;; (Loaded *after* any user and site configuration files)

;; Copyright (C) 2014 Vincent Goulet

;; Author: Vincent Goulet

;; This file is part of GNU Emacs.app Modified
;; http://vgoulet.act.ulaval.ca/emacs

;; GNU Emacs.app Modified is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;;
;;; Version number of Emacs Modified
;;;
;; Define variable and function 'emacs-modified-version'
(require 'version-modified)


;;;
;;; Import the shell environment
;;;
;; Emacs does not always properly catch the system and user paths and
;; other environment variable at launch on OS X. Forcibly import some
;; environment variables here; see 'import-env-from-shell-variables'
;; for the list. You can customize this variable in site-start.el or
;; the user's config file.
(require 'import-env-from-shell)


;;;
;;; ESS
;;;
;; Load ESS and activate the nifty feature showing function arguments
;; in the minibuffer until the call is closed with ')'.
(require 'ess-site)


;;;
;;; AUCTeX
;;;
;; Load AUCTeX and preview-latex.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; Defensive hack to find latex in case the PATH environment variable
;; was not correctly altered at TeX Live installation. Contributed by
;; Rodney Sparapani <rsparapa@mcw.edu>.
(require 'executable)
(if (and (not (executable-find "latex")) (file-exists-p "/usr/texbin"))
    (setq LaTeX-command-style
	  '(("" "/usr/texbin/%(PDF)%(latex) %S%(PDFout)"))))


;;;
;;; polymode
;;;
;; Activation of the R specific bundle and basic configuration.
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
(add-to-list 'auto-mode-alist '("\\.rapport" . poly-rapport-mode))
(add-to-list 'auto-mode-alist '("\\.Rhtml" . poly-html+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rbrew" . poly-brew+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rcpp" . poly-r+c++-mode))
(add-to-list 'auto-mode-alist '("\\.cppR" . poly-c++r-mode))
(require 'poly-R)


;;;
;;; SVN
;;;
;; Support for the Subversion version control system. Use 'M-x
;; svn-status RET' on a directory under version control to update,
;; commit changes, revert files, etc., all within Emacs.
(add-to-list 'vc-handled-backends 'SVN)
(require 'psvn)
