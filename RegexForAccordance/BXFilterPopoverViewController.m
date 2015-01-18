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
#import "BXFilterBracketedText.h"

@implementation BXFilterPopoverViewController

- (void)setFiltersInSearcher:(BXSearch *)searcher
{
    [self setFilter:[[BXFilterSpaces alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removeSpaces];
    [self setFilter:[[BXFilterTrailingSpaces alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removeTrailingSpaces];
    [self setFilter:[[BXFilterPilcrows alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removePilcrows];
    [self setFilter:[[BXFilterBracketedText alloc] init] inSearcher:searcher enabled:self.document.searchSettings.removeBracketedText];

    [self setFilter:[[BXFilterHebrewCantillation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemoveCantillation];
    [self setFilter:[[BXFilterHebrewPoints alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemovePoints];
    [self setFilter:[[BXFilterHebrewPunctuation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.hebrewRemovePunctuation];

    [self setFilter:[[BXFilterGreekDiacritics alloc] init] inSearcher:searcher enabled:self.document.searchSettings.greekRemoveDiacritics];
    [self setFilter:[[BXFilterGreekPunctuation alloc] init] inSearcher:searcher enabled:self.document.searchSettings.greekRemovePunctuation];
}


- (void)setFilter:(BXFilter *)filter inSearcher:(BXSearch *)searcher enabled:(BOOL)isEnabled
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
    else if (sender == self.bracketedText)
    {
        self.document.searchSettings.removeBracketedText = ([sender state] == NSOnState);
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
    self.spaces.state = cellStateValueForBool(self.document.searchSettings.removeSpaces);
    self.trailingSpaces.state = cellStateValueForBool(self.document.searchSettings.removeTrailingSpaces);
    self.pilcrows.state = cellStateValueForBool(self.document.searchSettings.removePilcrows);
    self.bracketedText.state = cellStateValueForBool(self.document.searchSettings.removeBracketedText);
    
    self.hebrewCantillation.state = cellStateValueForBool(self.document.searchSettings.hebrewRemoveCantillation);
    self.hebrewPoints.state = cellStateValueForBool(self.document.searchSettings.hebrewRemovePoints);
    self.hebrewPunctuation.state = cellStateValueForBool(self.document.searchSettings.hebrewRemovePunctuation);
    
    self.greekDiacritics.state = cellStateValueForBool(self.document.searchSettings.greekRemoveDiacritics);
    self.greekPunctuation.state = cellStateValueForBool(self.document.searchSettings.greekRemovePunctuation);
}

@end
