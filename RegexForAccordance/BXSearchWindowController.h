//
//  BXSearchWindowController.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXSearch.h"
#import "BXSearchFieldFormatter.h"
#import "BXFilterPopoverViewController.h"

@interface BXSearchWindowController : NSWindowController<NSSplitViewDelegate,NSTextFieldDelegate>
@property BXSearch *searcher;
@property (weak) IBOutlet NSTextField *verseReferenceField;
@property (weak) IBOutlet NSPopUpButton *textNamePopup;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (unsafe_unretained) IBOutlet NSTextView *searchResultsTextView;
@property (weak) IBOutlet NSTableView *statisticsTableView;
@property (weak) IBOutlet NSTextField *statisticsLabel;
@property (weak) IBOutlet NSTableColumn *statisticsKeyColumn;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSButton *linkButton;
@property (weak) IBOutlet BXSearchFieldFormatter *searchFieldFormatter;
@property (weak) IBOutlet NSTextField *progressIndicatorLabel;
@property (weak) IBOutlet NSButton *groupByBook;
@property (strong) IBOutlet NSMenu *statisticsTableMenu;
@property IBOutlet NSProgressIndicator *progressIndicator;
@property IBOutlet NSPopover *filterPopover;
@property IBOutlet BXFilterPopoverViewController *filterPopoverViewController;
@property (weak) IBOutlet NSButton *ignoreCase;
@property (weak) IBOutlet NSButton *includeReference;
@property (weak) IBOutlet NSButton *lroButton;

- (IBAction)openLinkFromTableView:(id)sender;
- (IBAction)popupMenuWithLinks:(id)sender;
- (IBAction)startSearching:(id)sender;
- (IBAction)searchOptionsChanged:(id)sender;
- (IBAction)toggleColumn:(id)sender;
- (IBAction)showFiltersPopover:(id)sender;
- (IBAction)setSearchFieldFont:(id)sender;
- (IBAction)toggleLRO:(id)sender;

- (void)performFindPanelAction:(id)sender;
- (BXDocument *)document;
- (void)documentDidChange;

@end
