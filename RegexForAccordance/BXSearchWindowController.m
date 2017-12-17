//
//  BXSearchWindowController.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchWindowController.h"
#import "BXSearch.h"
#import "BXAccVerseFetcher.h"
#import "BXTextLanguage.h"
#import "BXAccVerseURL.h"
#import "BXFontSelector.h"
#import "BXSearchResultFormatter.h"
#import "BXSearchWindowController.h"
#import "BXSearch.h"
#import "BXStatisticsDatasource.h"
#import "BXSearchResultHit.h"
#import "BXAccLink.h"
#import "BXDocument.h"
#import "BXGroupRowViewController.h"
#import "BXSearchResultHighlighter.h"

NSString *formatNumberWithPlural(NSString *format, NSUInteger number)
{
    return [NSString stringWithFormat:format, number, number == 1 ? @"" : @"s"];
}

NSString *makeBlankIfNil(NSString *str)
{
    return (str == nil) ? @"" : str;
}

@interface BXSearchWindowController ()
@property BOOL searchInProgress;
@property BOOL searchCancelled;
@property BXFontSelector *fontSelector;
@property NSTimer *statusUpdateTimer;
@property BXSearchResultFormatter *formatter;
@property BXStatisticsDatasource *statisticsDatasource;
@property NSError *error;
@property NSMutableAttributedString *pendingDisplayLines;
@property BXGroupRowViewController *groupRowViewController;
@property BXSearchResultHighlighter *highlighter;
@property NSMenu *linksPopupMenu;
@end

@implementation BXSearchWindowController

- (id)init
{
    if (self = [super initWithWindowNibName:@"BXSearchWindow"])
    {
        self.pendingDisplayLines = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    self.progressIndicator.hidden = YES;
    self.linkButton.enabled = NO;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setInitialFirstResponder:self.searchField];

    self.fontSelector = [[BXFontSelector alloc] init];
    self.formatter = [[BXSearchResultFormatter alloc] initWithFontSelector:self.fontSelector];
    self.searcher = [[BXSearch alloc] initWithFetcher:[[BXAccVerseFetcher alloc] init]];
    self.statisticsDatasource = [[BXStatisticsDatasource alloc] initWithStatisticsGroups:self.searcher.statisticsGroups];
    self.statisticsDatasource.searchWindowController = self;
    self.statisticsTableView.dataSource = self.statisticsDatasource;
    self.statisticsTableView.delegate = self.statisticsDatasource;
    if (self.statisticsTableView.sortDescriptors.count == 0)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:BXColumnNameRefs ascending:YES];
        [self.statisticsTableView setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    }
    [self.statisticsDatasource tableView:self.statisticsTableView sortDescriptorsDidChange:nil];
    
    self.highlighter = [[BXSearchResultHighlighter alloc] initWithStatisticsDatasource:self.statisticsDatasource
                                                                 searchResultsTextView:self.searchResultsTextView
                                                                        searchSettings:self.document.searchSettings
                                                                             formatter:self.formatter];
    [self loadTextNamePopup];
    
    self.filterPopoverViewController.document = self.document;
    [self.searchField.cell setCancelButtonCell:nil];
    [self.window makeKeyAndOrderFront:self];
    [self.progressIndicatorLabel setHidden:YES];
    [self updateSearchStatus];
    [self.document windowControllerDidLoadNib:self];
    [self buildColumnChooserMenu];
    [self loadSearchSettings];
}

- (BXDocument *)document
{
    return super.document;
}

- (void)documentDidChange
{
    [self loadSearchSettings];
}

- (void)loadTextNamePopup
{
    [self.textNamePopup removeAllItems];
    NSArray *items = self.searcher.fetcher.availableTexts;
    if (items == nil && self.searcher.fetcher.error != nil)
    {
        [NSApp presentError:self.searcher.fetcher.error];
    }
    else
    {
        [self.textNamePopup addItemsWithTitles:items];
    }
    for (NSUInteger i = 0; i < [self.textNamePopup.menu itemArray].count && i < 10; i++)
    {
        [[self.textNamePopup.menu itemAtIndex:i] setKeyEquivalent:[NSString stringWithFormat:@"%ld", (i + 1) % 10]];
        [[self.textNamePopup.menu itemAtIndex:i] setKeyEquivalentModifierMask:NSControlKeyMask];
    }
    [self.textNamePopup selectItemAtIndex:0];
}

- (void)reset
{
    [self.searchResultsTextView setString:@""];
    [[self.pendingDisplayLines mutableString] setString:@""];
    [self.highlighter reset];
    [self.linksPopupMenu removeAllItems];
    self.linkButton.enabled = NO;
    self.searchCancelled = NO;
    [self.searcher reset];
}

- (void)updateSearchFieldLRO
{
    self.lroButton.state = cellStateValueForBool(self.document.searchSettings.leftToRightOverride);
    self.searchFieldFormatter.leftToRightOverride = self.document.searchSettings.leftToRightOverride;
    self.searchField.stringValue = self.searchField.stringValue; // trigger a reformat
    [self.window makeFirstResponder:self.searchField]; // reformat with LRO doesn't display unless this is first responder
}

- (void)buildColumnChooserMenu
{
    [self.statisticsTableMenu removeAllItems];
    for (NSTableColumn *column in [self.statisticsTableView tableColumns])
    {
        if ([column.identifier isEqualToString:@"BXStatisticsKey"])
        {
            continue;
        }
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[column.headerCell stringValue]
                                                          action:@selector(toggleColumn:)
                                                   keyEquivalent:@""];
        menuItem.representedObject = column;
        menuItem.target = self;
        [self.statisticsTableMenu addItem:menuItem];
        [menuItem setState:cellStateValueForBool(!column.isHidden)];
    }
}

- (IBAction)toggleColumn:(id)sender
{
    NSTableColumn *column = [sender representedObject];
    [column setHidden:!column.isHidden];
    [sender setState:cellStateValueForBool(!column.isHidden)];
}

- (IBAction)showFiltersPopover:(id)sender
{
    NSButton *button = sender;
    [self.filterPopoverViewController willBecomeVisible];
    [self.filterPopover showRelativeToRect:button.bounds ofView:sender preferredEdge:NSMaxXEdge];
}

- (void)copy:(id)sender
{
    if (self.window.firstResponder == self.statisticsTableView)
    {
        [self.statisticsDatasource copySelectedRowsFromTableView:self.statisticsTableView];
    }
}

#pragma mark Glue

- (void)controlTextDidChange:(NSNotification *)notification
{
    if (notification.object == self.verseReferenceField)
    {
        self.document.searchSettings.verseRange = self.verseReferenceField.stringValue;
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (notification.object == self.searchField)
    {
        self.document.searchSettings.searchPattern = self.searchPattern;
        [self.document updateChangeCount:NSChangeDone];
    }
}

- (IBAction)searchOptionsChanged:(id)sender
{
    LogDebug(@"searchOptionsChanged “%@” %ld", [sender title], [sender state]);
    if (sender == self.ignoreCase)
    {
        self.document.searchSettings.ignoreCase = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.includeReference)
    {
        self.document.searchSettings.includeReference = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.groupByBook)
    {
        self.document.searchSettings.groupByBook = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
        [self reloadStatistics];
    }
    else if (sender == self.textNamePopup)
    {
        self.document.searchSettings.textName = self.textNamePopup.selectedItem.title;
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.searchScopePopup)
    {
		[self.document.searchSettings setSearchScopeString:self.searchScopePopup.selectedItem.title];
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.lroButton)
    {
        self.document.searchSettings.leftToRightOverride = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
        [self updateSearchFieldLRO];
    }
}

- (void)loadSearchSettings
{
    self.ignoreCase.state = cellStateValueForBool(self.document.searchSettings.ignoreCase);
    self.includeReference.state = cellStateValueForBool(self.document.searchSettings.includeReference);
    self.groupByBook.state = cellStateValueForBool(self.document.searchSettings.groupByBook);
    if (self.document.searchSettings.textName != nil)
    {
        [self.textNamePopup selectItemWithTitle:self.document.searchSettings.textName];
    }
    else
    {
        self.document.searchSettings.textName = self.textNamePopup.selectedItem.title;
    }
	[self.searchScopePopup selectItemWithTitle:self.document.searchSettings.searchScopeString];
    self.verseReferenceField.stringValue = makeBlankIfNil(self.document.searchSettings.verseRange);
    self.lroButton.state = cellStateValueForBool(self.document.searchSettings.leftToRightOverride);
    self.searchField.stringValue = makeBlankIfNil(self.document.searchSettings.searchPattern);
    [self setSearchFieldFontByName:self.document.searchSettings.searchFieldFont];
    [self updateSearchFieldLRO];
}


#pragma mark Searching

- (NSString *)searchPattern
{
    NSString *str = self.searchField.stringValue;
    return [self.searchFieldFormatter stripLRO:str];
}

- (IBAction)startSearching:(id)sender
{
    LogDebug(@"startSearching");
    if (self.searchInProgress)
    {
        [self cancelSearch:self];
        return;
    }
    // notification event arrives late, so we get the latest value here
    self.document.searchSettings.searchPattern = self.searchPattern;
    if (self.document.searchSettings.searchPattern.length == 0)
    {
        return;
    }

    [self reset];
    if (![self prepareSearcher])
    {
        [self searchFinished];
        return;
    }
    
    self.searchInProgress = YES;
    [self prepareSearchResultsFormatting];
    [self prepareStatisticsTableView];
    [self startStatusUpdateTimer];
    [self startProgressIndicator];
    [self performSelectorInBackground:@selector(searchResultsThread) withObject:nil];
}

- (BOOL)prepareSearcher
{
    self.searcher.fetcher.verseRange = self.document.searchSettings.verseRange;
    self.searcher.fetcher.textName = self.document.searchSettings.textName;
    self.searcher.ignoreCase = self.document.searchSettings.ignoreCase;
    self.searcher.includeReference = self.document.searchSettings.includeReference;
    self.searcher.searchScope = self.document.searchSettings.searchScope;
    self.searcher.fetcher.searchScope = self.document.searchSettings.searchScope;
    self.searcher.pattern = self.document.searchSettings.searchPattern;
    [self.filterPopoverViewController setFiltersInSearcher:self.searcher];
    
    NSString *line = self.searcher.fetcher.peekAtNextLine;
    if (self.searcher.fetcher.error != nil)
    {
        self.error = self.searcher.fetcher.error;
        return NO;
    }
    self.searcher.languageScriptTag = [[[BXTextLanguage alloc] init] scriptTagForString:line];
    
    NSError *error;
    if (![self.searcher prepareSearch:&error])
    {
        self.error = error;
        return NO;
    }
    return YES;
}

- (void)prepareSearchResultsFormatting
{
    BXTextLanguage *textLanguage = [[BXTextLanguage alloc] init];
    NSWritingDirection writingDirection = [textLanguage writingDirectionForLanguageScriptTag:self.searcher.languageScriptTag];
    [self.fontSelector setCurrentFontsForLanguageScriptTag:self.searcher.languageScriptTag];
    self.formatter.writingDirection = writingDirection;
    self.formatter.textName = self.document.searchSettings.textName;
    self.formatter.includeReference = self.document.searchSettings.includeReference;
    [self.searchResultsTextView setAlignment:[self textAlignmentForWritingDirection:writingDirection]];
}

- (NSTextAlignment)textAlignmentForWritingDirection:(NSWritingDirection)dir
{
    return dir == NSWritingDirectionRightToLeft ? NSRightTextAlignment : NSLeftTextAlignment;
}

- (void)prepareStatisticsTableView
{
    self.statisticsDatasource.font = self.fontSelector.plainFont;
    NSLayoutManager *lm = [[NSLayoutManager alloc] init];
    CGFloat lineHeight = [lm defaultLineHeightForFont:self.fontSelector.plainFont];
    self.statisticsTableView.rowHeight = lineHeight + 6.0;
    self.statisticsDatasource.alignment = self.searchResultsTextView.alignment;
    self.statisticsDatasource.groupByBook = self.document.searchSettings.groupByBook;
    self.statisticsDatasource.searchScope = self.document.searchSettings.searchScope;
}

- (void)startStatusUpdateTimer
{
    [self updateSearchStatus];
    self.statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self
                                                            selector:@selector(updateSearchStatus)
                                                            userInfo:nil repeats:YES];
}

- (void)stopStatusUpdateTimer
{
    [self.statusUpdateTimer invalidate];
    self.statusUpdateTimer = nil;
    [self updateSearchStatus];
}

- (void)startProgressIndicator
{
    [self.progressIndicatorLabel setHidden:NO];
    [self.progressIndicator startAnimation:self];
    self.progressIndicator.hidden = NO;
    
    [self.searchField.cell resetCancelButtonCell];
    [[self.searchField.cell cancelButtonCell] setAction:@selector(cancelSearch:)];
    [[self.searchField.cell cancelButtonCell] setTarget:self];
    [self.searchField display];
}

- (void)stopProgressIndicator
{
    [self.progressIndicatorLabel setHidden:YES];
    self.progressIndicator.hidden = YES;
    [self.progressIndicator stopAnimation:self];

    [self.searchField.cell setCancelButtonCell:nil];
    [self.searchField display];
}

- (void)searchResultsThread
{
#ifdef DEBUG
    NSDate *t0 = [NSDate date];
#endif
    BXSearchResult *searchResult;
    NSUInteger offset = 0;
    while (!self.searchCancelled && nil != (searchResult = [self.searcher nextSearchResult]))
    {
        NSMutableAttributedString *decoratedDisplayLine = [[self.formatter formatSearchResult:searchResult] mutableCopy];
        [decoratedDisplayLine appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        searchResult.rangeOfDisplayLine = NSMakeRange(offset, decoratedDisplayLine.length);
        offset += decoratedDisplayLine.length;
        [self performSelectorOnMainThread:@selector(appendDisplayLine:)
                               withObject:decoratedDisplayLine
                            waitUntilDone:NO];
    }
    if (self.searcher.error != nil)
    {
        self.error = self.searcher.error;
    }
#ifdef DEBUG
    NSTimeInterval t1 = [t0 timeIntervalSinceNow] * -1;
    LogDebug(@"Search time: %f sec", t1);
#endif
    [self performSelectorOnMainThread:@selector(searchFinished) withObject:nil waitUntilDone:NO];
}

- (void)appendDisplayLine:(NSAttributedString *)decoratedDisplayLine
{
    [self.pendingDisplayLines appendAttributedString:decoratedDisplayLine];
}

- (IBAction)cancelSearch:(id)sender
{
    self.searchCancelled = YES;
    [self.searcher cancelSearch];
}

- (void)searchFinished
{
    self.searchInProgress = NO;
    [self stopStatusUpdateTimer];
    [self stopProgressIndicator];
    if (self.error != nil)
    {
        [NSApp presentError:self.error modalForWindow:self.window delegate:nil didPresentSelector:nil contextInfo:nil];
        self.error = nil;
    }
    else
    {
        [self.statisticsTableView reloadData];
        [self buildSearchResultLinks];
    }
}

- (void)buildSearchResultLinks
{
    if (self.searcher.searchResults.count > 0)
    {
        self.linksPopupMenu = [self menuForSearchResults:self.searcher.searchResults];
        self.linkButton.enabled = YES;
    }
}

- (NSMenu *)menuForSearchResults:(NSArray *)searchResults
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Links"];
    BXAccVerseURL *acc = [[BXAccVerseURL alloc] init];
    NSArray *links = [acc linksForSearchResults:searchResults textName:self.document.searchSettings.textName searchScope:self.document.searchSettings.searchScope];
    for (BXAccLink *link in links)
    {
        NSString *menuItemTitle = [NSString stringWithFormat:@"%@ … %@", link.firstVerseRef.stringValue, link.lastVerseRef.stringValue];
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:menuItemTitle action:@selector(openLinkForMenuItem:) keyEquivalent:@""];
        menuItem.representedObject = link;
        [menu addItem:menuItem];
    }
    return menu;
}

- (void)updateSearchStatus
{
	NSString* scopeText;
	switch (self.document.searchSettings.searchScope)
	{
		case SearchScopeChapter:
			scopeText = @"chapter";
			break;
		case SearchScopeBook:
			scopeText = @"book";
			break;
		default:
			scopeText = @"verse";
			break;
	}

    NSString* formatText = [NSString stringWithFormat:@"%%ld %@%%@", scopeText];
    self.statusLabel.stringValue
    = [NSString stringWithFormat:@"%@ | %@",
       formatNumberWithPlural(@"%ld hit%@", self.searcher.statisticsGroups.combinedStatistics.countOfHits),
       formatNumberWithPlural(formatText, self.searcher.statisticsGroups.combinedStatistics.countOfSearchResults)
       ];

    self.statisticsLabel.stringValue
    = formatNumberWithPlural(@"%ld distinct hit%@", self.searcher.statisticsGroups.combinedStatistics.countOfHitKeys);

    [self.statisticsTableView reloadData];

    self.progressIndicatorLabel.stringValue = makeBlankIfNil(self.searcher.fetcher.lastVerse.ref.book);

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.25]; // TODO: configurable
    [paragraphStyle setAlignment:self.searchResultsTextView.alignment];
    [self.searchResultsTextView setDefaultParagraphStyle:paragraphStyle];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self.pendingDisplayLines addAttributes:attr range:NSMakeRange(0, self.pendingDisplayLines.length)];

    [self.searchResultsTextView.textStorage appendAttributedString:self.pendingDisplayLines];
    [[self.pendingDisplayLines mutableString] setString:@""];
}

#pragma mark Search Results

- (IBAction)popupMenuWithLinks:(id)sender
{
    NSMenu *menu = [self menuForSearchResults:self.searcher.searchResults];
    if (menu.itemArray.count == 1)
    {
        [self openLink:[[[menu itemAtIndex:0] representedObject] url]];
    }
    else
    {
        [self.linksPopupMenu popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];
    }
}

- (IBAction)openLinkForMenuItem:(id)sender
{
    NSMenuItem *menuItem = sender;
    [self openLink:[menuItem.representedObject url]];
}

- (IBAction)openLinkFromTableView:(id)sender
{
    NSArray *searchResults = [self.statisticsDatasource searchResultsForRow:[sender tag]];
    NSMenu *menu = [self menuForSearchResults:searchResults];
    if (menu.itemArray.count == 1)
    {
        [self openLink:[[[menu itemAtIndex:0] representedObject] url]];
    }
    else
    {
        [menu popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];
    }
}

- (void)openLink:(NSURL *)url
{
    LogDebug(@"%@", url.absoluteString);
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)setSearchFieldFont:(id)sender
{
    NSMenuItem *menuItem = sender;
    NSString *fontTypeName = menuItem.title;
    [self setSearchFieldFontByName:fontTypeName];
    self.document.searchSettings.searchFieldFont = fontTypeName;
    [self.document updateChangeCount:NSChangeDone];
}

- (void)setSearchFieldFontByName:(NSString *)fontTypeName
{
    if ([fontTypeName isEqualToString:@"System"])
    {
        self.searchField.font = self.fontSelector.systemFont;
    }
    else if ([fontTypeName isEqualToString:@"Default"])
    {
        self.searchField.font = self.fontSelector.latinFont;
    }
    else if ([fontTypeName isEqualToString:@"Hebrew"])
    {
        self.searchField.font = self.fontSelector.hebrewFont;
    }
    else if ([fontTypeName isEqualToString:@"Greek"])
    {
        self.searchField.font = self.fontSelector.greekFont;
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem.action == @selector(copy:))
    {
        if (self.window.firstResponder == self.statisticsTableView)
        {
            return self.statisticsTableView.numberOfSelectedRows > 0;
        }
    }
    else if (menuItem.action == @selector(openLinkForMenuItem:))
    {
        return YES;
    }
    else if (menuItem.action == @selector(setSearchFieldFont:))
    {
        menuItem.state = NSOffState;
        if ([menuItem.title isEqualToString:@"System"] && [self.searchField.font isEqual:self.fontSelector.systemFont])
        {
            menuItem.state = NSOnState;
        }
        else if ([menuItem.title isEqualToString:@"Default"] && [self.searchField.font isEqual:self.fontSelector.latinFont])
        {
            menuItem.state = NSOnState;
        }
        else if ([menuItem.title isEqualToString:@"Hebrew"] && [self.searchField.font isEqual:self.fontSelector.hebrewFont])
        {
            menuItem.state = NSOnState;
        }
        else if ([menuItem.title isEqualToString:@"Greek"] && [self.searchField.font isEqual:self.fontSelector.greekFont])
        {
            menuItem.state = NSOnState;
        }
        return YES;
    }
    else if (menuItem.action == @selector(toggleLRO:))
    {
        menuItem.state = self.document.searchSettings.leftToRightOverride == NSOnState;
        return YES;
    }
    else if (menuItem.tag == NSFindPanelActionNext ||
             menuItem.tag == NSFindPanelActionPrevious)
    {
        if (self.window.firstResponder == self.statisticsTableView)
        {
            return self.statisticsTableView.numberOfSelectedRows > 0;
        }
    }
    else if (menuItem.action == @selector(toggleColumn:))
    {
        return YES;
    }
    else if (menuItem.menu == self.textNamePopup.menu)
    {
        return YES;
    }
    return NO;
}

- (IBAction)toggleLRO:(id)sender
{
    self.document.searchSettings.leftToRightOverride = !self.document.searchSettings.leftToRightOverride;
    [self updateSearchFieldLRO];
}

- (void)performFindPanelAction:(id)sender
{
    if (self.window.firstResponder == self.statisticsTableView)
    {
        switch ([sender tag])
        {
            case NSFindPanelActionNext:
                [self.highlighter showNextFindIndicatorForRow:self.statisticsTableView.selectedRow increment:1];
                break;
                
            case NSFindPanelActionPrevious:
                [self.highlighter showNextFindIndicatorForRow:self.statisticsTableView.selectedRow increment:-1];
                break;
                
            default:
                break;
        }
    }
}

- (void)reloadStatistics
{
    self.statisticsDatasource.groupByBook = self.document.searchSettings.groupByBook;
    [self.statisticsTableView reloadData];
}

@end

