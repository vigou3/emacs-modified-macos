Copyright (C) 2008-2013 Free Software Foundation, Inc.
Copyright (C) 2009-2017 Vincent Goulet for the modifications
See below for GNU Emacs license conditions.

Emacs Modified for macOS 25.2-modified-9
========================================

This is GNU Emacs modified to include the following add-on packages:

* ESS 16.10;
* AUCTeX 11.90;
* org 9.0.6;
* polymode 2016-12-18 (active by default for RMarkdown mode
  only);
* markdown-mode.el 2.1;
* exec-path-from-shell.el 1.11 to import the user's
  environment (by default PATH, MANPATH and LANG) at Emacs startup;
* psvn.el 1573006 to work with Subversion repositories from
  within Emacs;
* framepop.el, to obtain temporary buffers in separate frames;
* default.el and site-start.el files to make everything work together.

In order to use Markdown you may need to install a parser such as
Pandoc (see https://github.com/jgm/pandoc/releases/latest) and
customize 'markdown-command'.

You may want to customize 'exec-path-from-shell-variables'.

Please direct questions or comments on this version of Emacs Modified
for macOS to Vincent Goulet <vincent.goulet@act.ulaval.ca>.

GNU Emacs Modified is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

GNU Emacs
=========

[The following are excerpts from the file etc/NEXTSTEP in the GNU
Emacs sources.]

The Nextstep support code works on many POSIX systems (and possibly
W32) using the GNUstep libraries, and on MacOS X systems using the
Cocoa libraries.

GNU Emacs is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
