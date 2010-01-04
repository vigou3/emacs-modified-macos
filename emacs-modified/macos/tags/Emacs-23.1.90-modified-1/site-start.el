;;; site-start.el --- Site configuration for GNU Emacs on OS X

;; Copyright (C) 2009 Vincent Goulet

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
;;; Nice options to have On by default
;;;
(mouse-wheel-mode t)			; activate mouse scrolling
(global-font-lock-mode t)		; syntax highlighting
(transient-mark-mode t)			; sane select (mark) mode
(delete-selection-mode t)		; entry deletes marked text
(show-paren-mode t)			; match parentheses
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode


;;;
;;; ESS
;;;
;; Load ESS and activate the nifty feature showing function arguments
;; in the minibuffer until the call is closed with ')'.
(require 'ess-site)
(require 'ess-eldoc)

;; Following the "source is real" philosophy put forward by ESS, one
;; should not need the command history and should not save the
;; workspace at the end of an R session. Hence, both options are
;; disabled here.
(setq-default inferior-R-args "--no-restore-history --no-save ")

;; Set code indentation following the standard in R sources.
(setq-default ess-default-style 'C++)


;;;
;;; AUCTeX
;;;
;; Load AUCTeX and preview-latex.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; Minimal OS X-friendly configuration of AUCTeX. Since there is no
;; DVI viewer for the platform, use pdftex/pdflatex by default for
;; compilation. Furthermore, use 'open' to view the resulting PDF.
;; Until Preview learns to refresh automatically on file updates, Skim
;; (http://skim-app.sourceforge.net) is a nice PDF viewer.
(setq TeX-PDF-mode t)
(setq TeX-output-view-style
      '(("^dvi$" "^xdvi$" "xdvi %dS %d")
	("^dvi$" "." "open %dS %d")
	("^pdf$" "." "open %o")
	("^html?$" "." "open %o")))

;; Add standard Sweave file extensions to the list of files recognized
;; by AUCTeX.
(setq TeX-file-extensions
      '("Snw" "Rnw" "snw" "rnw" "tex" "sty" "cls" "ltx" "texi" "texinfo" "dtx"))


;;;
;;; SVN
;;;
;; Support for the Subversion version control system. Use 'M-x
;; svn-status RET' on a directory under version control to update,
;; commit changes, revert files, etc., all within Emacs.
(add-to-list 'vc-handled-backends 'SVN)
(require 'psvn)
(add-hook 'svn-log-edit-mode-hook 'turn-off-auto-fill) ; useful option


;;;
;;; Fix path
;;;
;; Emacs does not properly catch the system and user paths at launch
;; on OS X. There are ways to solve this provided with Emacs.app
;; (mac-fix-env and ns-grabenv), but I have not been very successful
;; in using them so far. For the time being, I rely on code lifted
;; from Aquamacs.
;; (if window-system (ns-grabenv "/bin/bash"
;; 			      "source ~/.bashrc"))
(require 'fixpath)
