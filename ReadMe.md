You are looking at the ReadMe file for MightEMacs, an Emacs text editor which
runs on Unix and Linux platforms.  See file *Install.txt* for build and
installation instructions.  A C99 C compiler is required if you are not
installing on a CentOS Linux, Debian Linux, OS X, or Red Hat Linux platform, or
do not want to use the included binaries.

History and Project Goals
-------------------------
MightEMacs is designed to be a fast and full-featured text editor.  The goals of
the project are to create an Emacs-like text editor that will:

1. Provide the ability to edit code quickly and easily with few keystrokes.
2. Use key bindings that are well designed and intuitive.
3. Be as easy as possible to learn.
4. Be robust and powerful enough to perform sophisticated editing and automation
   tasks, provide a high level of extensibility, and yet not be overly complex.

MightEMacs is focused on editing files well and being easily extensible, but
also being an editor that is not daunting -- one that can be learned fairly
quickly by the average programmer.  The tradeoff is that it lacks some features
(and complexity) of other editors.  It uses a simple Text User Interface with no
special text formatting; for example, there is no color display or highlighting
of lexical elements of a particular programming language.  It is not an IDE and
doesn't try to be.  It does however, provide most of the things you would expect
from an Emacs editor, like buffers, windows, modes, a kill ring, keyboard
macros, sophisticated navigation, searching, and editing commands,
language-specific auto-formatting, fence matching, extensibility, etc.

It also supports a C-like scripting language that is very powerful and fairly
easy to learn (assuming you already have programming experience).  The
distribution package includes several scripts as well that perform various
tasks, such as finding a file that contains a particular C function or Ruby
method definition and opening it at that location, naming and storing keyboard
macros in a file, or grepping for files and performing a global search and
replace on them, to name just a few.  

See the `memacs(1)` and `memacs-guide(1)` man files for further information.

Distribution
------------
The current distribution of MightEMacs may be obtained at
`https://github.com/italia389/MightEMacs.git`.

Contact and Feedback
--------------------
User feedback is welcomed and encouraged.  If you have the time and interest,
please contact Rick Marinelli <italian389@yahoo.com> with your questions,
comments, bug reports, likes, dislikes, or whatever you feel is worth
mentioning.  Questions and feature requests are welcomed as well.  You may also
post questions or comments on the MightEMacs discussion forum on Reddit at
`http://reddit.com/r/memacs`.

Notes
-----
This distribution of MightEMacs is version 8.3.1.   64-bit binaries are included
for CentOS Linux (vers. 6 and later), Debian Linux (vers. 8 and later), OS X
(vers. 10.6 and later on Intel), and Red Hat Linux (RHEL 6 and later).  The
sources should compile on other platforms as well; however, this has not been
tested and there may be some (hopefully minor) issues which will need to be
resolved.  If you are compiling on a platform other than one of those listed
above and encounter any problems, please contact the author with the details.

Note that a library (geeklib) is included which contains a few routines that are
used by the editor.  The most important ones are in valobj.c.  These functions
manage "Value" objects, which are strings that can be of any length and built on
the fly.  Geeklib contains those and other generic functions that can be used in
any C program.  The library is independent of MightEMacs, but included with it
for convenience.

Credits
-------
MightEMacs (c) Copyright 2016 Richard W. Marinelli is based on code from
MicroEMACS 3.12 (c) Copyright 1988, 1989, 1990, 1991, 1992, 1993 Daniel M.
Lawrence, which was based on code by Dave G. Conroy, Steve Wilhite, and George
Jones.

MightEMacs is written by Rick Marinelli <italian389@yahoo.com>.

MicroEMACS was written by Dan Lawrence with contributions by Dana Hoggatt
and C. Smith.

MicroEMACS 3.12 can be copied and distributed freely for any non-commercial
purpose, but can be incorporated into commercial software only with the
permission of the current author.

See License.txt for the MightEMacs license.
