;;; fixpath.el --- Fix exec-path variable

;; Copyright (C) 2009 Vincent Goulet

;; Author: Vincent Goulet from code by David Reitter for Aquamacs
;; Emacs (http://aquamacs.org)

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

(defun mac-read-environment-vars-from-shell ()
  "Import the environment from the system's default login shell
specified in `shell-file-name'."
  
  (setq environment-temp-file (make-temp-file "envvar-"))
  ;; running the shell with -l (to load the environment)
  (let ((default-directory "~/"))	; ensure it can be executed
  
  (message "Shell: %s" shell-file-name)

  (let* ((shell (or shell-file-name "/bin/bash"))   ;; can shell-file-name be nil?
	 (command (format "printenv >%s.tmp; mv %s.tmp %s"
			  environment-temp-file 
			  environment-temp-file 
			  environment-temp-file)))

    (if (string-match ".*/\\(ba\\|z\\)sh" shell)
	(call-process shell nil
		      0 nil
		      "-l" "-c" command)
      (if (or (string-match ".*/\\tcsh" shell)
	      (string-match ".*/ksh" shell))
	  (call-process shell nil
			0 nil
			;; we can't start tcsh as a login shell
			;; because it doesn't accept -l in combination
			;; with a command.
			;; call-process-region wouldn't work because it's
			;; not interactive.
			"-c" command)
	(message "Could not retrieve login shell environment with login shell: %s" shell)
	;; won't work for csh, because it doesn't take -l -c ...
	)))))

(defun mac-read-environment-vars-from-shell-2 ()
  "Reads temporary file if it exists."
  (if (and environment-temp-file (file-readable-p environment-temp-file))
      (prog1
	  (with-temp-buffer
	    (condition-case nil
		(progn
		  (insert-file-contents-literally environment-temp-file nil)
		  (delete-file environment-temp-file))
	      (error nil))
	    (let ((num 0))
	     (if (eq (buffer-size) 0)
		 (message "Warning: Login shell did not return environment.")
	       (goto-char (point-min))
	       (while (re-search-forward "^[A-Za-z_0-9]+=()\s*[^\x]*?
\s*}\s*$" nil t)
		 (replace-match "..." nil nil))
	       (goto-char (point-min))
	       (while (search-forward-regexp "^\\([A-Za-z_0-9]+\\)=\\(.*\\)$" nil t)
		 (setq num (1+ num))
		 (setenv
		  (match-string 1)
		  (if (equal (match-string 1) "PATH")
		      (concat (match-string 2) ":" (getenv "PATH"))
		    (match-string 2)))))
	  (message "%d environment variables imported from login shell (%s)." 
		   num shell-file-name)
	  (mac-add-path-to-exec-path)
	  (mac-add-local-directory-to-exec-path)
	  num)))
    nil))

(defun mac-add-path-to-exec-path ()
  "Add elements from environment variable `PATH' to `exec-path'."
  (let ((l (split-string (getenv "PATH") ":")))
  (mapc
   (lambda (p)
     (unless (member p l)
       (nconc l (list p))))
   exec-path)
  (setq exec-path l)))

(defun mac-add-local-directory-to-exec-path ()
  "Add /usr/local/bin to `exec-path'"
  (add-to-list 'exec-path "/usr/local/bin"))

(mac-read-environment-vars-from-shell)
(sit-for 1)
(mac-read-environment-vars-from-shell-2)

(provide 'fixpath)