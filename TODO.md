# TODO

* Screenshots and description

* Put on GitHub

* Create GitHub Pages


# Bugs

* Cancel button is hidden when starting a search by choosing from the recent search menu.

* Do not start searching when an item is selected from the recent search menu. Then the previous bug is fixed too.

* Baselines for different font sizes should be aligned in the statistics view.
http://www.cocoabuilder.com/archive/cocoa/142820-setting-vertical-alignment-for-nstextfieldcell.html


# Feature Ideas

* Option to span lines.

* The last column header (tableView.cornerView) can be a selector button, showing popup for show/hide column.

* Highlight or filter the search results when selecting a row in statistics.

* Group by chapter or verse

* Custom filters


# Font Problems
(probably can't fix)

* Some fonts don't work well with composite characters.

  Composite Greek capital letter with diacritic causes display problem in Galatia SIL. Times is OK.
  
    Ἰησοῦ Ἑσρὼμ Ῥαχάβ  -- composite
    
    Ἰησοῦ Ἑσρὼμ Ῥαχάβ  -- precomposed

* Dotted Circle placeholder is misaligned with combiner in some fonts.  SBL Hebrew is best.

* Hebrew points are misplaced in search field when LRO is on.
