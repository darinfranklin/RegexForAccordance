//
//  BXFilterPopOverViewControllerTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 12/2/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BXFilterPopoverViewController.h"

@interface BXFilterPopOverViewControllerTests : XCTestCase
@property BXFilterPopoverViewController *vc;
@property BXSearch *searcher;
@end

@implementation BXFilterPopOverViewControllerTests

- (void)setUp
{
    [super setUp];
    self.vc = [[BXFilterPopoverViewController alloc] init];
    self.vc.document = [[BXDocument alloc] init];
    self.searcher = [[BXSearch alloc] initWithFetcher:nil];
}

- (void)testAddFilters
{
    XCTAssertEqual(2, self.searcher.filters.count);
    self.vc.document.searchSettings.removePilcrows = YES;
    self.vc.document.searchSettings.removeBracketedText = YES;
    self.vc.document.searchSettings.removeSpaces = YES;
    self.vc.document.searchSettings.removeTrailingSpaces = YES;
    self.vc.document.searchSettings.hebrewRemoveCantillation = YES;
    self.vc.document.searchSettings.hebrewRemovePoints = YES;
    self.vc.document.searchSettings.hebrewRemovePunctuation = YES;
    self.vc.document.searchSettings.greekRemoveDiacritics = YES;
    self.vc.document.searchSettings.greekRemovePunctuation = YES;
    [self.vc setFiltersInSearcher:self.searcher];
    XCTAssertEqual(11, self.searcher.filters.count);
    self.vc.document.searchSettings.removePilcrows = NO;
    self.vc.document.searchSettings.removeBracketedText = NO;
    self.vc.document.searchSettings.removeSpaces = NO;
    self.vc.document.searchSettings.removeTrailingSpaces = NO;
    self.vc.document.searchSettings.hebrewRemoveCantillation = NO;
    self.vc.document.searchSettings.hebrewRemovePoints = NO;
    self.vc.document.searchSettings.hebrewRemovePunctuation = NO;
    self.vc.document.searchSettings.greekRemoveDiacritics = NO;
    self.vc.document.searchSettings.greekRemovePunctuation = NO;
    [self.vc setFiltersInSearcher:self.searcher];
    XCTAssertEqual(2, self.searcher.filters.count);
}

- (void)toggleState:(BOOL)initialState ofButton:(NSButton *)button
{
    button.state = cellStateValueForBool(!initialState);
    [self.vc searchOptionsChanged:button];
}

- (void)testControlStateChange
{
    BOOL initialState;
    
    initialState = YES;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.removePilcrows);
    [self toggleState:initialState ofButton:self.vc.pilcrows = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.removePilcrows);
    
    initialState = NO;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.removeBracketedText);
    [self toggleState:initialState ofButton:self.vc.bracketedText = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.removeBracketedText);

    initialState = NO;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.removeSpaces);
    [self toggleState:initialState ofButton:self.vc.spaces = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.removeSpaces);
    
    initialState = YES;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.removeTrailingSpaces);
    [self toggleState:initialState ofButton:self.vc.trailingSpaces = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.removeTrailingSpaces);
    
    initialState = YES;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.hebrewRemoveCantillation);
    [self toggleState:initialState ofButton:self.vc.hebrewCantillation = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.hebrewRemoveCantillation);
    
    initialState = YES;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.hebrewRemovePoints);
    [self toggleState:initialState ofButton:self.vc.hebrewPoints = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.hebrewRemovePoints);
    
    initialState = NO;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.hebrewRemovePunctuation);
    [self toggleState:initialState ofButton:self.vc.hebrewPunctuation = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.hebrewRemovePunctuation);
    
    initialState = YES;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.greekRemoveDiacritics);
    [self toggleState:initialState ofButton:self.vc.greekDiacritics = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.greekRemoveDiacritics);
    
    initialState = NO;
    XCTAssertEqual(initialState, self.vc.document.searchSettings.greekRemovePunctuation);
    [self toggleState:initialState ofButton:self.vc.greekPunctuation = [[NSButton alloc] init]];
    XCTAssertEqual(!initialState, self.vc.document.searchSettings.greekRemovePunctuation);
}

@end
