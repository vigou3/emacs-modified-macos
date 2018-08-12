---
title: Emacs Modified for macOS
description: GNU Emacs. Ready for R and LaTeX
---

# Presentation

Emacs Modified for macOS is a distribution
of [GNU Emacs](https://www.gnu.org/software/emacs/) **26.1** (released
May 28, 2018) bundled with a few select packages for R developers
and LaTeX users.

The additions to stock Emacs are the following:

- [ESS](http://ess.r-project.org) 17.11;
- [AUCTeX](http://www.gnu.org/software/auctex/) 12.1;
- [org](http://orgmode.org/) 9.1.13;
- [polymode](https://github.com/vitoshka/polymode) 2017-03-07;
- [markdown-mode.el](http://jblevins.org/projects/markdown-mode/) 2.3;
- [exec-path-from-shell.el](https://github.com/purcell/exec-path-from-shell) 1.11
  to import the user's environment (by default `PATH`, `MANPATH` and
  `LANG`) at Emacs startup;
- [psvn.el](http://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/) r1573006,
  an interface for the version control system
  [Subversion](http://subversion.tigris.org) modified to include
  Andre Colomb's and Koji Nakamaru's
  [combined patches](http://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
  to support Subversion 1.7;
- [framepop.el](http://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
  to open temporary buffers in a separate frame;
- [default.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v26.1-2-modified-1/default.el)
  and
  [site-start.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v26.1-2-modified-1/site-start.el),
  configuration files to make everything work.

The distribution is based on the latest stable release of GNU Emacs
compiled by David Caldwell and distributed on
[Emacs for Mac OS X](http://emacsformacosx.com).

## Latest release

Version 26.1-2-modified-1
([Release notes](https://gitlab.com/vigou3/emacs-modified-macos/tags/v26.1-2-modified-1/))

## System requirements

Mac OS X 10.4 or later.


# Installation

Open the disk image and copy Emacs in the `Applications` folder or any
other folder.


# Philosophy

This distribution of Emacs is based on the NeXTstep port part of the
official sources of GNU Emacs. Other than the additions mentioned above
and the minor configurations found in the `site-start.el` file, this is
a stock distribution of Emacs. Users of Emacs on other platforms will
appreciate the similar look and feel of the application.

Those looking for a more Mac-like version of Emacs may consider
[Aquamacs](http://aquamacs.org). I used Aquamacs myself for
two years, but I got tired of disabling the newer “features” in each
release of the application. For me Aquamacs insists too much on opening
new frames and on playing with fonts. Moreover, ESS is not kept up to
date on a regular basis.

For more information of the various options to run Emacs on macOS, see
the [Emacs wiki](http://www.emacswiki.org/emacs/EmacsForMacOS).


# Also available

[Emacs Modified for Windows](https://vigou3.gitlab.io/emacs-modified-windows/). Same idea, with a user friendly installer.
