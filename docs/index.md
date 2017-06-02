Presentation
============

Emacs Modified for macOS is a distribution of
[GNU Emacs](https://www.gnu.org/software/emacs/) **25.2** (released
April 21, 2017) bundled with a few select packages for LaTeX users and
R developers.

The additions to stock Emacs are the following:

-   [ESS](http://ess.r-project.org) 16.10;
-   [AUCTeX](http://www.gnu.org/software/auctex/) 11.90;
-   [org](http://orgmode.org/) 9.0.7;
-   [polymode](https://github.com/vitoshka/polymode) 2017-03-07;
-   [`markdown-mode.el`](http://jblevins.org/projects/markdown-mode/) 2.2;
-   [`exec-path-from-shell.el`](https://github.com/purcell/exec-path-from-shell)
    1.11 to import the user's environment (by default `PATH`, `MANPATH` and
    `LANG`) at Emacs startup;
-   [`psvn.el`](http://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/)
    r1573006, an interface for the version control system
    [Subversion](http://subversion.tigris.org) modified to include
    Andre Colomb's and Koji Nakamaru's
    [combined patches](http://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
    to support Subversion 1.7;
-   [`framepop.el`](http://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
    to open temporary buffers in a separate frame;
-   [`default.el`]({{ site.github.repository_url }}/tags/v25.2-modified-2/default.el)
    and
    [`site-start.el`]({{ site.github.repository_url }}/tags/v25.2-modified-2/site-start.el),
    configuration files to make everything work.

The distribution is based on the latest stable release of GNU Emacs
compiled by David Caldwell and distributed on
[Emacs for Mac OS X](http://emacsformacosx.com).

Latest release
--------------

Version 25.2-modified-2 ([Release notes]({{ site.github.repository_url }}/releases/tag/v25.2-modified-2/))

System requirements
-------------------

Mac OS X 10.4 or later.

Installation
============

Open the disk image and copy Emacs in the `Applications` folder or any
other folder.

Philosophy
==========

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

Also available
==============

[Emacs Modified for Windows](https://{{ site.github.owner_name }}.{{ site.github.pages_hostname }}/emacs-modified-windows/). Same idea, with a user friendly installer.
