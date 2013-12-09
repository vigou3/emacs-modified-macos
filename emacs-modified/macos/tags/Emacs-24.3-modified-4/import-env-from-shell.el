;;; import-env-from-shell.el --- Make Emacs use the environment set up by the user's shell

;; Copyright (C) 2013 Vincent Goulet

;; Author: Vincent Goulet

;; This file is a modified version of exec-path-from-shell.el by
;; Steve Purcell <steve@sanityinc.com> 
;; URL: https://github.com/purcell/exec-path-from-shell

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

(defgroup import-env-from-shell nil
  "Make Emacs use shell-defined values for $PATH etc."
  :prefix "import-env-from-shell-"
  :group 'environment)

(defcustom import-env-from-shell-variables
  '("PATH" "MANPATH" "LANG")
  "List of environment variables which are copied from the shell."
  :group 'import-env-from-shell)

(defun import-env-from-shell-getenv (name)
  "Get the environment variable NAME from the user's shell.

Execute $SHELL as interactive login shell, have it output the
variable of NAME and return this output as string."
  (with-temp-buffer
    (call-process (getenv "SHELL") nil (current-buffer) nil
                  "--login" "-i" "-c" (concat "echo __RESULT=$" name))
    (when (re-search-backward "__RESULT=\\(.*\\)" nil t)
      (match-string 1))))

(defun import-env-from-shell-copy-env (name)
  "Set the environment variable $NAME from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  Return the value
of the environment variable."
  (interactive "sCopy value of which environment variable from shell? ")
  (prog1
      (setenv name (import-env-from-shell-getenv name))
    (when (string-equal "PATH" name)
      (setq eshell-path-env (getenv "PATH")
            exec-path (split-string (getenv "PATH") path-separator)))))

(defun import-env-from-shell-initialize ()
  "Initialize environment from the user's shell.

The values of all the environment variables named in
`import-env-from-shell-variables' are set from the corresponding
values used in the user's shell."
  (interactive)
  (mapc 'import-env-from-shell-copy-env import-env-from-shell-variables))

(import-env-from-shell-initialize)

(provide 'import-env-from-shell)
