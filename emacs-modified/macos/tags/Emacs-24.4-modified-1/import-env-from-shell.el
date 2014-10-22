;;; import-env-from-shell.el --- Make Emacs use the environment set up by the user's shell

;; Copyright (C) 2013-2014 Vincent Goulet

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
  :type '(repeat (string :tag "Environment variable"))
  :group 'import-env-from-shell)

(defvar import-env-from-shell-debug nil
  "Display debug info when non-nil.")

(defun import-env-from-shell--double-quote (s)
  "Double-quote S, escaping any double-quotes already contained in it."
  (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\""))

(defun import-env-from-shell--tcsh-p (shell)
  "Return non-nil if SHELL appears to be tcsh."
  (string-match "tcsh$" shell))

(defun import-env-from-shell--login-arg (shell)
  "Return the name of the --login arg for SHELL."
  (if (import-env-from-shell--tcsh-p shell) "-d" "-l"))

(defcustom import-env-from-shell-arguments
  (list (import-env-from-shell--login-arg (getenv "SHELL")) "-i")
  "Additional arguments to pass to the shell.

The default value denotes an interactive login shell."
  :type '(repeat (string :tag "Shell argument"))
  :group 'import-env-from-shell)

(defun import-env-from-shell--debug (msg &rest args)
  "Print MSG and ARGS like `message', but only if debug output is enabled."
  (when import-env-from-shell-debug
    (apply 'message msg args)))

(defun import-env-from-shell--standard-shell-p (shell)
  "Return non-nil iff SHELL supports the standard ${VAR-default} syntax."
  (not (string-match "\\(fish\\|tcsh\\)$" shell)))

(defun import-env-from-shell-printf (str &optional args)
  "Return the result of printing STR in the user's shell.

Executes $SHELL as interactive login shell.

STR is inserted literally in a single-quoted argument to printf,
and may therefore contain backslashed escape sequences understood
by printf.

ARGS is an optional list of args which will be inserted by printf
in place of any % placeholders in STR. ARGS are not automatically
shell-escaped, so they may contain $ etc."
  (let* ((printf-bin (or (executable-find "printf") "printf"))
         (printf-command
          (concat printf-bin
                  " '__RESULT\\000" str "' "
                  (mapconcat #'import-env-from-shell--double-quote args " ")))
         (shell-args (append import-env-from-shell-arguments
                             (list "-c"
                                   (if (import-env-from-shell--standard-shell-p (getenv "SHELL"))
                                       printf-command
                                     (concat "sh -c " (shell-quote-argument printf-command))))))
         (shell (getenv "SHELL")))
    (with-temp-buffer
      (import-env-from-shell--debug "Invoking shell %s with args %S" shell shell-args)
      (let ((exit-code (apply #'call-process shell nil t nil shell-args)))
        (import-env-from-shell--debug "Shell printed: %S" (buffer-string))
        (unless (zerop exit-code)
          (error "Non-zero exit code from shell %s invoked with args %S.  Output was:\n%S"
                 shell shell-args (buffer-string))))
      (goto-char (point-min))
      (if (re-search-forward "__RESULT\0\\(.*\\)" nil t)
          (match-string 1)
        (error "Expected printf output from shell, but got: %S" (buffer-string))))))

(defun import-env-from-shell-getenvs (names)
  "Get the environment variables with NAMES from the user's shell.

Execute $SHELL according to `import-env-from-shell-arguments'.
The result is a list of (NAME . VALUE) pairs."
  (let* ((dollar-names (mapcar (lambda (n) (format "${%s-}" n)) names))
         (values (split-string (import-env-from-shell-printf
                                (mapconcat #'identity (make-list (length names) "%s") "\\000")
                                dollar-names) "\0")))
    (let (result)
      (while names
        (prog1
            (push (cons (car names) (car values)) result)
          (setq values (cdr values)
                names (cdr names))))
      result)))

(defun import-env-from-shell-getenv (name)
  "Get the environment variable NAME from the user's shell.

Execute $SHELL as interactive login shell, have it output the
variable of NAME and return this output as string."
  (cdr (assoc name (import-env-from-shell-getenvs (list name)))))

(defun import-env-from-shell-setenv (name value)
  "Set the value of environment var NAME to VALUE.
Additionally, if NAME is \"PATH\" then also set corresponding
variables such as `exec-path'."
  (setenv name value)
  (when (string-equal "PATH" name)
    (setq eshell-path-env value
          exec-path (append (parse-colon-path value) (list exec-directory)))))

(defun import-env-from-shell-copy-envs (names)
  "Set the environment variables with NAMES from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  The result is an alist,
as described by `import-env-from-shell-getenvs'."
  (mapc (lambda (pair)
          (import-env-from-shell-setenv (car pair) (cdr pair)))
        (import-env-from-shell-getenvs names)))

(defun import-env-from-shell-copy-env (name)
  "Set the environment variable $NAME from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  Return the value
of the environment variable."
  (interactive "sCopy value of which environment variable from shell? ")
  (cdar (import-env-from-shell-copy-envs (list name))))

(defun import-env-from-shell-initialize ()
  "Initialize environment from the user's shell.

The values of all the environment variables named in
`import-env-from-shell-variables' are set from the corresponding
values used in the user's shell."
  (interactive)
  (import-env-from-shell-copy-envs import-env-from-shell-variables))

(import-env-from-shell-initialize)

(provide 'import-env-from-shell)
