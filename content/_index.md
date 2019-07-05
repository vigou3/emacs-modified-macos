---
title: Emacs Modified for macOS
description: GNU Emacs. Ready for R and LaTeX
---

# Presentation

Emacs Modified for macOS is a distribution
of [GNU Emacs](https://www.gnu.org/software/emacs/) **26.2** (released
April 14, 2019) bundled with a few select packages for R developers
and LaTeX users.

The additions to stock Emacs are the following:

- [ESS](https://ess.r-project.org) 18.10.2;
- [AUCTeX](https://www.gnu.org/software/auctex/) 12.1;
- [org](https://orgmode.org/) 9.2.4;
- [Tabbar](https://github.com/dholm/tabbar) 2.2, a minor mode that
  displays a tab bar at the top of the Emacs window, similar to the
  idea of web browsers tabs;
- [markdown-mode.el](https://jblevins.org/projects/markdown-mode/) 2.3;
- [exec-path-from-shell.el](https://github.com/purcell/exec-path-from-shell) 1.12
  to import the user's environment (by default `PATH`, `MANPATH`,
  `LANG`, `TEXINPUTS` and `BIBINPUTS`) at Emacs startup;
- [psvn.el](https://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/) r1573006,
  an interface for the version control system
  [Subversion](https://subversion.tigris.org) modified to include
  Andre Colomb's and Koji Nakamaru's
  [combined patches](https://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
  to support Subversion 1.7;
- [framepop.el](https://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
  to open temporary buffers in a separate frame;
- [default.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v26.2-modified-2/default.el)
  and
  [site-start.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v26.2-modified-2/site-start.el),
  configuration files to make everything work.

The distribution is based on the latest stable release of GNU Emacs
compiled by David Caldwell and distributed on
[Emacs for Mac OS X](https://emacsformacosx.com).

## Latest release

Version 26.2-modified-2
([Release notes](https://gitlab.com/vigou3/emacs-modified-macos/tags/v26.2-modified-2/))

## System requirements

Mac OS X 10.4 or later.


# Installation

Open the disk image and copy Emacs in the `Applications` folder or any
other folder.


# Additional packages

If you want to install additional Emacs packages
([polymode](https://polymode.github.io) comes to mind, here) through
the [MELPA](https://melpa.org/) repository, add the following lines
to your `.emacs` configuration file:

```
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
```


# Philosophy

This distribution of Emacs is based on the NeXTstep port part of the
official sources of GNU Emacs. Other than the additions mentioned above
and the minor configuration found in the `site-start.el` file, this is
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
