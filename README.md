RegexForAccordance
==================

[Accordance](http://accordancebible.com/) is a popular Bible study program for the Mac (and iOS and Windows too). It is host to many high quality original language manuscripts and Bible translations.  RegexForAccordance allows you to search any of the text modules in Accordance using regular expressions.

Project Page: http://darinfranklin.github.io/RegexForAccordance/


How It Works
------------

RegexForAccordance gets the text from Accordance through its AppleScript interface.  It transforms the text with some optional filters, and then searches it with the regular expression.  It lists the search results, tabulates some statistics, and provides links back to Accordance through the accord:// URL scheme.

The regex matching is provided by Apple’s implementation of [ICU Regular Expression](http://userguide.icu-project.org/strings/regexp) syntax.

Developer Notes
---------------

Use these Accordance preferences when running the unit tests.

- Appearance > Use European verse notation: FALSE
- Appearance > Use SBL standard abbreviations: TRUE
- Citation > Suppress poetry: TRUE

--

Problem: When running from Xcode, you see this error.

>  Unable to communicate with Accordance. Not authorized to send Apple events to Accordance. (Error -1743)

Solution: Product > Clean Build Folder. 

