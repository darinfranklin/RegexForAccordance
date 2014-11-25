//
//  BXFilterPopoverViewController.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 9/21/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXSearch.h"
#import "BXDocument.h"

@interface BXFilterPopoverViewController : NSViewController
@property BXDocument *document;
@property IBOutlet NSButton *spaces;
@property IBOutlet NSButton *trailingSpaces;
@property IBOutlet NSButton *pilcrows;
@property IBOutlet NSButton *hebrewCantillation;
@property IBOutlet NSButton *hebrewPoints;
@property IBOutlet NSButton *hebrewPunctuation;
@property IBOutlet NSButton *greekDiacritics;
@property IBOutlet NSButton *greekPunctuation;

- (IBAction)searchOptionsChanged:(id)sender;
- (void)setFiltersInSearcher:(BXSearch *)searcher;
- (void)willBecomeVisible;

@end
