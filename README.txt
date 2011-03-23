Copyright (C) 2008, 2009, 2010, 2011 Free Software Foundation, Inc.
Copyright (C) 2009, 2010, 2011 Vincent Goulet for the modifications
See below for GNU Emacs license conditions.

Emacs.app Modified
==================

This is the the NeXTstep-based port of GNU Emacs, known as Emacs.app,
modified to include the following add-on packages:

* ESS 5.13;
* AUCTeX 11.86;
* psvn.el, to work with Subversion repositories from within Emacs;
* site-start.el, to make everything work.

Please direct questions or comments on this modified version of
Emacs.app to Vincent Goulet <vincent.goulet@act.ulaval.ca>.

GNU Emacs Modified is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.


Emacs.app
=========

[The following are excerpts from the file nextstep/README in the GNU
Emacs sources.]

The Nextstep support code works on many POSIX systems (and possibly
W32) using the GNUstep libraries, and on MacOS X systems using the
Cocoa libraries.

Those primarily responsible for the port were, in chronological order:
Michael Brouwer, Carl Edman, Christian Limpach, Scott Bender,
Christophe de Dinechin, and Adrian Robert.

Peter Dyballa assisted in a variety of ways to improve text rendering
and keyboard handling, Adam Ratcliffe documented the Preferences
panel, David M. Cooke contributed fixes to XPM handling, and Carsten
Bormann helped get dired working for non-ASCII filenames.  People who
provided additional assistance include Adam Fedor, Fred Kiefer, M. Uli
Klusterer, Alexander Malmberg, Jonas Matton, and Riccardo Mottola.
See AUTHORS file and "Release History" below for more information.


Requirements
------------
MacOS X 10.4 or later

- or -

GNUstep "Startup 0.23" or later
Tested on GNU/Linux, should work on other systems, perhaps with minor
build tweaking.


Background
----------
Within Emacs, the port and its code are referred to using the term
"Nextstep", despite the fact that no system or API has been released
under this name in more than 10 years.  Here's some background on why:

NeXT, Inc. introduced the NeXTstep API with its computer and operating
system in the late 1980's.  Later on, in collaboration with Sun, this
API was published as a specification called OpenStep.  The GNUstep
project started in the early 1990's to provide a free implementation
of this API.  Later on, Apple bought NeXT (some would say "NeXT bought
Apple") and made OpenStep the basis of OS X, calling the API "Cocoa".
Since then, Cocoa has evolved beyond the OpenStep specification, and
GNUstep has followed it.

Thus, calling this port "OpenStep" is not technically accurate, and in
the absence of any other determinant, we are using the term
"Nextstep", both because it signifies the original inspiration that
created these APIs, and because all of the classes and functions still
begin with the letters "NS".

(See http://en.wikipedia.org/wiki/Nextstep)

This Emacs port was first released in the early 1990's on the NeXT
computer, and was successively updated to OpenStep, Rhapsody, OS X,
and then finally GNUstep, tracking GNU emacs core releases in the
meantime.


Release History
---------------

1990-1992	1.0-3.0 (?)	Michael Brouwer's socket/terminal communication
				based version (GUI ran as a separate process.)

1993/10/25	3.0.1		Last (?) release of Brouwer version.  Supports
				NeXTstep 3.x and below.

1994/04/24	4.0		Carl Edman's version using direct API following
				the X-Windows port.  NeXTstep 3.x only.

1995/06/15	4.1        	Second (and last) Carl Edman release, based on
				Emacs 19.28.

1996/07/28	4.2		First Christian Limpach release, based on
				Emacs 19.29.

??		5.0		??

1997/12/??	6.0b1		Ported to OpenStep by Scott Bender.  Updated
				to Emacs 20.2.

??		6.0b2		(?) Scott Bender: ported to Rhapsody.

1999/05/??	6.0b3		Scott Bender: "OS X Server", Emacs 20.3.

2001/06/25	7.0		Ported to MacOS X (10.1) by Christophe de
				Dinechin. Release based on Emacs 20.7. Hosting
				moved to SourceForge.

2002/01/03	7.0.1		Bug fixes.

2002/08/27	7.0.2		Jaguar (OS X 10.2) support. Added an autoconf
				option for sys_nerr being in stdio. Added
				libncurses to the build libraries. Fixed a
				problem with ns-alternate-is-meta. Changed the
				icon color to blue, since Jaguar is yellow.

2004/10/07	8.0-pre1	Ported to GNUstep by Adrian Robert.

2004/11/04	8.0-pre2	Restored functionality on OS X (menu code
				cleanup).  Improved scrollbar handling and
				paste from other applications.  File icons
				obtained properly from NSWorkspace.  Dropped
				Gorm and Nib files.  Background refresh bug
				fixed (in GNUstep).  Various small fixes and
				code cleanups.  Now starts up under Art.

2005/01/27	8.0-pre3	Bold and italic faces supported.  Cursor and
				mouse highlighting rendering bugs
				fixed. Drag/drop and cut/paste interaction
				w/external apps fixed.  File load/save panels
				available.  Stability and rendering speed
				improvements. Some ObjC and VC mode bugs fixed.

2005/02/27	8.0-rc1		Dynamic path detection at startup so Emacs.app
				can be moved anywhere.  Added binary packages
				and simplified source installation to running
				two scripts.  Thorough cleanup of menu code;
				now fully functional.  Fixed all detected
				memory leaks.  Minor frame focus and title
				bugs fixed.

2005/03/30	8.0-rc2		"Configure" info directory now uses dynamic
				path setting, so info files can go under .app.
				Improved select() handling and PTY fixes so
				shell mode and tramp run smoothly.
				Significant rendering optimizations under
				GNUstep, and now works under Art backend.
				Non-Latin text rendering works (but not
				fontsets), and LEIM is bundled.  UTF8 is used
				for clipboard interaction.
				Arrow cursor now used on scrollbar.
				objc-mode and tramp now bundled in site-lisp.

2005/05/30	8.0-rc3		Fixed bug with parsing of "easymenu" menus.
       				Many problems with modes such as SLIME, MatLab,
				and Planner go away.  Improved scrollbar
				handling and rendering speed.  Color panel
				and other bug fixes. mac-fix-env utility.
				Font handling improvements (OS X 10.3, 10.4):
				- heed 'GSFontAntiAlias' default
				- heed system antialiasing threshold
				- added 'UseQuickdrawSmoothing' default to
				  invoke less heavy antialiasing

2005/07/05	8.0-rc4		Added a Preferences panel.  Cleaned up
				rendering for synthetic italic fonts.  Further
				improved menu parsing.  Use system highlight
				color.  Added previous- and next-mark history
				navigation commmands bound to M-p,M-n.
				Miscellaneous bug fixes.

2005/08/04	8.0-rc5		All internal string handling changed to UTF-8.
				This means menu items, color and color list
				names, and a few other things will now display
				properly.  It does NOT mean UTF-8 filenames
				are displayed correctly in the minibuffer.
				Also relating to UTF-8, contents of files
				using this coding can now be displayed (though
				not auto-recognized; add extensions to your
				default coding alist).  Limited mac-roman
				support was also added (also sans recognition).
				Certain characters are not displayed properly
				due to a translation problem.  (UTF-8 based on
				work by Otfried Cheong; mac-roman from
				emacs-21.)  Partial support for "dead-key"
				handling now added.  Transparency (e.g., M-x
				set-background-color ARGB88FFFFFF) improved:
				only the background is made transparent.
				Cursor drawing glitches fixed.  Preferences
				handling improved.  Fixed some portability
				problems on Tiger and Puma.

2005/09/12	8.0		Bundled ispell on OS X.  Minor bug fixes and
				stability improvements.  Compiles under gcc-4.

2005/09/26	8.0.1		Correct clipped rendering for synthetic
				italics. Include the info directory.
				Fix grabenv. Bundle whitespace package.

2005/10/27	8.0.2		Correct rendering for wide characters during
				cursor movement.  Fix bungled hack in ispell
				bundling.

2005/11/05	9.0-pre1	Updated to latest Emacs CVS code on unicode-2
				branch (proposed to be released 2006/2007 as
				Emacs 23).

2005/11/11	9.0-pre2	Fix crashes for deiconifying and loading
				certain images.  Improve vertical font metrics
				(fixes inaccurate page up/down, window size,
				and partial lines).  Support better remapping
				of Alt/Opt and remapping of Command.  More
				insistent defaulting of scrollbar to right.
				Modest improvements to build process.

2006/04/22	9.0-pre2a	Stopgap interim release to sync w/latest
				unicode-2 CVS.  Includes XPM and partial
				toolbar support.

2006/06/08	9.0-pre3	Major upgrade to keyboard handling:
				system-selected compositional input methods
				should now work, as well as more keys /
				keyboards.  XPM, toolbar, and tooltip support.
				Some improvements to scrollbars, zoom, italic
				rendering, pasting, Color panel.  Added function
				ns-set-background-alpha to work around
				inability to customize with numeric colors.

2006/12/24	9.0-rc1		Reworked font handling and text rendering to
				use Kenichi Handa's new font back-end system.
				Font sets are now supported and automatically
				created when a font is selected.  Added recent
				X11 colors to Emacs.clr (remove
				~/Library/Colors/Emacs.clr to pick up).  Added
				ns-option-modifier, ns-control-modifier,
				ns-function-modifier customization variables.
				Update menus to Emacs 21+ conventions.  Right
				mouse button now generates mouse-3 events.
				Various bug fixes and rendering improvements.

2007/09/10	9.0-rc2		Improve menubar, popup menu, and scrollbar
				behavior, let accented char entry work in
				isearch, follow system keymap for shortcut
				keys, fix border and box drawing, remove
				glitches in modeline drawing, support
				overstrike for unavailable bold fonts, fix XPM
				related crasher bugs.  Incremental font
				metrics caching and other performance
				improvements.  Shared-lisp builds now possible.

2007/09/20	9.0-rc2a	Interim release.  New features: composed
				character display, colored fringe bitmaps,
				colored relief drawing, dynamic resizing,
				Bug fixes: popup menu position and selection,
				font width calculation, face color adaptation
				to background, submenu keyboard navigation.
				NOT TESTED ON GNUSTEP.

2007/11/19	9.0-rc3		Integrated the multi-TTY functionality from
				emacs core (however, mixed TTY and GUI
				sessions are not working yet).  Support 10.5.
				Give site-lisp load precedence over lisp and
				add a compile option to prefer an additional
				directory, use miniaturized miniwindow images
				in some cases, rename cursor types for
				consistency w/other emacs terms, improved font
				selection for symbol scripts.
				Bug fixes: fringe and bitmap, frame deletion,
				resizing, cursor blink, workspace open-file,
				image backgrounds, toolbar item enablement,
				context menu positioning.

2008/07/15	(none)		Merge to GNU Emacs CVS trunk.

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