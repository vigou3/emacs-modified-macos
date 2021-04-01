---
title: Emacs Modified for macOS
description: GNU Emacs. Ready for R and LaTeX.
---

# Presentation

Emacs Modified for macOS is a distribution
of [GNU Emacs](https://www.gnu.org/software/emacs/) **27.1** (released
August 10, 2020) bundled with a few select packages for R developers
and LaTeX users.

The additions to stock Emacs are the following:

- [ESS](https://ess.r-project.org) 18.10.2;
- [AUCTeX](https://www.gnu.org/software/auctex/) 12.3;
- [org](https://orgmode.org/) 9.4;
- [Tabbar](https://github.com/dholm/tabbar) 2.2, a minor mode that
  displays a tab bar at the top of the Emacs window, similar to the
  idea of web browsers tabs;
- [markdown-mode.el](https://jblevins.org/projects/markdown-mode/) 2.4;
- [exec-path-from-shell.el](https://github.com/purcell/exec-path-from-shell) 1.12
  to import the user's environment at Emacs startup;
- dictionaries for the [Hunspell](https://hunspell.github.io) spell
  checker (optional; see below for details);
- [psvn.el](https://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/) r1573006,
  an interface for the version control system
  [Subversion](https://subversion.tigris.org) modified to include
  Andre Colomb's and Koji Nakamaru's
  [combined patches](https://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
  to support Subversion 1.7;
- [default.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v27.2-2-modified-1/default.el)
  and
  [site-start.el](https://gitlab.com/vigou3/emacs-modified-macos/blob/v27.2-2-modified-1/site-start.el),
  configuration files to make everything work.

The distribution is based on the latest stable release of GNU Emacs
compiled by David Caldwell and distributed on
[Emacs for Mac OS X](https://emacsformacosx.com).

## Latest release

Version 27.2-2-modified-1
([Release notes](https://gitlab.com/vigou3/emacs-modified-macos/tags/v27.2-2-modified-1/))

## System requirements

Mac OS X 10.4 or later.

## Installation

Open the disk image and copy Emacs in the `Applications` folder or any
other folder.

## Spell checking and dictionaries

Spell checking inside Emacs on macOS requires an external checker. I
recommend to install [Hunspell](https://hunspell.github.io) using
[Homebrew](https://brew.sh).

The Hunspell installation does not include any dictionaries.
Therefore, this distributions of Emacs ships with the following [Libre
Office dictionaries](https://extensions.libreoffice.org/extensions?getCategories=Dictionary&getCompatibility=any) suitable for use with Hunspell:
[English](https://extensions.libreoffice.org/extensions/english-dictionaries/) (version 2021.02.01);
[French](https://extensions.libreoffice.org/extensions/dictionnaires-francais/) (version 5.7);
[German](https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries) (version 2017.01.12);
[Spanish](https://extensions.libreoffice.org/extensions/spanish-dictionaries) (version 2.5).

To make use of the dictionaries, copy the files in the `Dictionaries`
directory of the disk image to `~/Library/Spelling`. If needed, create
a symbolic link named after your `LANG` environment variable to the
corresponding dictionary and affix files. For example, if `LANG` is set
to `fr_CA.URF-8`, do from the command line

    cd ~/Library/Spelling
    ln -s fr-classique.dic fr_CA.dic
    ln -s fr-classique.aff fr_CA.aff

Finally, add the following lines to your ~/.emacs file:

    (setq-default ispell-program-name "/usr/local/bin/hunspell")
    (setq ispell-really-hunspell t)

Spell checking should now work with `M-x ispell`.

## Additional packages

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
