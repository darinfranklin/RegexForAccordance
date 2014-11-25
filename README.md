RegexForAccordance
==================

[Accordance](http://accordancebible.com/) is a popular Bible study program for the Mac (iOS and Windows too). It is host to many high quality original language manuscripts and Bible translations.  RegexForAccordance allows you to search any of the text modules in Accordance using regular expressions.

How It Works
------------

Accordance has an AppleScript interface which provides access to all of its text modules in a consistent, verse-per-line, Unicode format.  RegexForAccordance gets the text through AppleScript, transforms it with some optional filters, and then searches it with the regular expression.  It lists the search results, offers some basic statistics, and provides links back to Accordance through the accord:// URL scheme.

Unicode characters are decomposed so that combining marks, like Hebrew vowel points and Greek diacritics, can be matched individually or removed altogether.

The regex matching is provided by Apple’s implementation of [ICU Regular Expression](http://userguide.icu-project.org/strings/regexp) syntax.