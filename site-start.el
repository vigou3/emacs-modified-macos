;;; site-start.el --- Customizations for GNU Emacs on OS X

;; Copyright (C) 2015 Vincent Goulet

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
;;; Environment setting
;;;
;; By default, environment variables PATH, MANPATH and LANG are
;; imported from the shell at startup. If needed, more variables may
;; be imported by listing them in 'import-env-from-shell-variables'
;; variable. You may also Customize this variable.
;;
;; Customizations should probably go in a user's .emacs file, so just
;; consider the code below as an example of how to do it.
;(setq import-env-from-shell-variables
;      (nconc '("BIBINPUTS") import-env-from-shell-variables))

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
;; Following the "source is real" philosophy put forward by ESS, one
;; should not save the workspace at the end of an R session. Hence,
;; the option is disabled here.
(setq-default inferior-R-args "--no-save ")

;; Automagically delete trailing whitespace when saving R script
;; files. One can add other commands in the ess-mode-hook below.
(add-hook 'ess-mode-hook
	  '(lambda()
	     (add-hook 'write-file-functions
		       (lambda ()
                         (ess-nuke-trailing-whitespace)))
	     (setq ess-nuke-trailing-whitespace-p t)))

;; Load ESS.
(require 'ess-site)

;;;
;;; AUCTeX
;;;
;; Turn on RefTeX for LaTeX documents. Put further RefTeX
;; customizations in your .emacs file.
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (turn-on-reftex)
	    (setq reftex-plug-into-AUCTeX t)))

;; Minimal OS X-friendly configuration of AUCTeX. Use 'open' to view
;; the resulting PDF. Until Preview learns to refresh automatically on
;; file updates, Skim (http://skim-app.sourceforge.net) is a nice PDF
;; viewer.
(setq TeX-view-program-selection
      '(((output-dvi style-pstricks)
	 "dvips and PDF Viewer")
	(output-dvi "PDF Viewer")
	(output-pdf "PDF Viewer")
	(output-html "Safari")))
(setq TeX-view-program-list
      '(("dvips and PDF Viewer" "%(o?)dvips %d -o && open %f")
	("PDF Viewer" "open %o")
	("Safari" "open %o")))

;; Add standard Sweave file extensions to the list of files recognized
;; by AUCTeX.
(setq TeX-file-extensions
      '("Rnw" "rnw" "Snw" "snw" "tex" "sty" "cls" "ltx" "texi" "texinfo" "dtx"))

;; Defensive hack to find latex in case the PATH environment variable
;; was not correctly altered at TeX Live installation. Contributed by
;; Rodney Sparapani <rsparapa@mcw.edu>.
(require 'executable)
(if (and (not (executable-find "latex")) (file-exists-p "/usr/texbin"))
    (setq LaTeX-command-style
	  '(("" "/usr/texbin/%(PDF)%(latex) %S%(PDFout)"))))

;; Load AUCTeX and preview-latex.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

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
(add-hook 'svn-log-edit-mode-hook 'turn-off-auto-fill) ; useful option
(require 'psvn)
