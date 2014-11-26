//
//  BXFilterPopoverViewController.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 9/21/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterPopoverViewController.h"
#import "BXFilterReplace.h"
#import "BXFilterTransliterate.h"
#import "BXFilterCFStringTransform.h"
#import "BXFilterSpaces.h"
#import "BXFilterTrailingSpaces.h"
#import "BXFilterPilcrows.h"
#import "BXFilterHebrewCantillation.h"
#import "BXFilterHebrewPoints.h"
#import "BXFilterHebrewPunctuation.h"
#import "BXFilterGreekDiacritics.h"
#import "BXFilterGreekPunctuation.h"

@implementation BXFilterPopoverViewController

- (void)setFiltersInSearcher:(BXSearch *)searcher
{
    [self setFilter:[[BXFilterSpaces alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removeSpaces];
    [self setFilter:[[BXFilterTrailingSpaces alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removeTrailingSpaces];
    [self setFilter:[[BXFilterPilcrows alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removePilcrows];

    [self setFilter:[[BXFilterHebrewCantillation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemoveCantillation];
    [self setFilter:[[BXFilterHebrewPoints alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemovePoints];
    [self setFilter:[[BXFilterHebrewPunctuation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemovePunctuation];

    [self setFilter:[[BXFilterGreekDiacritics alloc] init] inSearcher:searcher enabled:self.document.searchSettings.greekRemoveDiacritics];
    [self setFilter:[[BXFilterGreekPunctuation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.greekRemovePunctuation];
}


- (void)setFilter:(id<BXFilter>)filter inSearcher:(BXSearch *)searcher enabled:(BOOL)isEnabled
{
    if (isEnabled)
    {
        [searcher addFilter:filter];
    }
    else
    {
        [searcher removeFilter:filter];
    }
}

- (IBAction)searchOptionsChanged:(id)sender
{
    if (sender == self.spaces)
    {
        self.document.searchSettings.removeSpaces = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.trailingSpaces)
    {
        self.document.searchSettings.removeTrailingSpaces = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.pilcrows)
    {
        self.document.searchSettings.removePilcrows = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.hebrewCantillation)
    {
        self.document.searchSettings.hebrewRemoveCantillation = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.hebrewPoints)
    {
        self.document.searchSettings.hebrewRemovePoints = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.hebrewPunctuation)
    {
        self.document.searchSettings.hebrewRemovePunctuation = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.greekDiacritics)
    {
        self.document.searchSettings.greekRemoveDiacritics = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
    else if (sender == self.greekPunctuation)
    {
        self.document.searchSettings.greekRemovePunctuation = ([sender state] == NSOnState);
        [self.document updateChangeCount:NSChangeDone];
    }
}

- (void)willBecomeVisible
{
    self.spaces.state = self.document.searchSettings.removeSpaces ? NSOnState : NSOffState;
    self.trailingSpaces.state = self.document.searchSettings.removeTrailingSpaces ? NSOnState : NSOffState;
    self.pilcrows.state = self.document.searchSettings.removePilcrows ? NSOnState : NSOffState;
    
    self.hebrewCantillation.state = self.document.searchSettings.hebrewRemoveCantillation ? NSOnState : NSOffState;
    self.hebrewPoints.state = self.document.searchSettings.hebrewRemovePoints ? NSOnState : NSOffState;
    self.hebrewPunctuation.state = self.document.searchSettings.hebrewRemovePunctuation ? NSOnState : NSOffState;
    
    self.greekDiacritics.state = self.document.searchSettings.greekRemoveDiacritics ? NSOnState : NSOffState;
    self.greekPunctuation.state = self.document.searchSettings.greekRemovePunctuation ? NSOnState : NSOffState;
}

@end
