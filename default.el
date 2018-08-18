;;; default.el --- Default configuration for Emacs Modified for macOS
;;
;; This file is used mainly to load custom extensions. It is loaded
;; *after* any user and site configuration files.
;;
;; Copyright (C) 2017 Vincent Goulet
;;
;; Author: Vincent Goulet
;;
;; This file is part of Emacs Modified for macOS
;; https://gitlab.com/vigou3/emacs-modified-macos

;; Emacs Modified for macOS is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;;
;;; Version number of Emacs Modified for macOS
;;;
;; Define variable and function 'emacs-modified-version'
(require 'version-modified)

;;;
;;; Import the shell environment
;;;
;; Import some shell environment variables into Emacs at launch. Steve
;; Purcell's exec-path-from-shell imports $PATH and $MANPATH by
;; default; $LANG is added here. You can customize
;; 'exec-env-from-shell-variables' variable in site-start.el or the
;; user's config file.
(require 'exec-path-from-shell)
(nconc exec-path-from-shell-variables '("LANG"))
(exec-path-from-shell-initialize)
