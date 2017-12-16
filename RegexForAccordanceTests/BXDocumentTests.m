//
//  BXDocumentTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 12/1/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BXDocument.h"

@interface BXDocumentTests : XCTestCase
@property BXDocument *document;
@end

@interface BXDocument (XCTestCase)
- (NSDictionary *)searchSettingsDictionary;
- (void)loadDocumentContents:(NSDictionary *)documentContents;
@end

@implementation BXDocumentTests

- (void)setUp
{
    [super setUp];
    self.document = [[BXDocument alloc] init];
}

- (void)testSetGet
{
    self.document.searchSettings.removePilcrows = YES;
    self.document.searchSettings.removeBracketedText = YES;
    self.document.searchSettings.removeSpaces = YES;
    self.document.searchSettings.removeTrailingSpaces = YES;
    self.document.searchSettings.hebrewRemoveCantillation = YES;
    self.document.searchSettings.hebrewRemovePoints = YES;
    self.document.searchSettings.hebrewRemovePunctuation = YES;
    self.document.searchSettings.greekRemoveDiacritics = YES;
    self.document.searchSettings.greekRemovePunctuation = YES;
    self.document.searchSettings.ignoreCase = YES;
    self.document.searchSettings.includeReference = YES;
    self.document.searchSettings.groupByBook = YES;
    self.document.searchSettings.textName = @"Abc";
    self.document.searchSettings.verseRange = @"Def - Ghi";
    self.document.searchSettings.searchScope = SearchScopeVerse;
    self.document.searchSettings.leftToRightOverride = YES;
    self.document.searchSettings.searchPattern = @"abc";
    self.document.searchSettings.searchFieldFont = @"Greek";

    NSDictionary *dict = [self.document searchSettingsDictionary];
    XCTAssertEqual(YES, [[dict objectForKey:@"RemovePilcrows"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"RemoveBracketedText"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"RemoveSpaces"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"RemoveTrailingSpaces"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"HebrewRemoveCantillation"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"HebrewRemovePoints"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"HebrewRemovePunctuation"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"GreekRemoveDiacritics"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"GreekRemovePunctuation"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"IgnoreCase"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"IncludeReference"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"GroupByBook"] boolValue]);
    XCTAssertEqual(YES, [[dict objectForKey:@"LeftToRightOverride"] boolValue]);
    XCTAssertEqualObjects(@"Abc", [dict objectForKey:@"TextName"]);
    XCTAssertEqualObjects(@"Def - Ghi", [dict objectForKey:@"VerseRange"]);
    XCTAssertEqualObjects(@"Verse", [dict objectForKey:@"SearchScope"]);
    XCTAssertEqualObjects(@"abc", [dict objectForKey:@"SearchPattern"]);
    XCTAssertEqualObjects(@"Greek", [dict objectForKey:@"SearchFieldFont"]);
}

- (void)testLoadDocumentContents
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"RemovePilcrows"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"RemoveBracketedText"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"RemoveSpaces"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"RemoveTrailingSpaces"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"HebrewRemoveCantillation"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"HebrewRemovePoints"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"HebrewRemovePunctuation"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"GreekRemoveDiacritics"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"GreekRemovePunctuation"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IgnoreCase"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IncludeReference"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"GroupByBook"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"LeftToRightOverride"];
    [dict setObject:@"Abc" forKey:@"TextName"];
    [dict setObject:@"Def - Ghi" forKey:@"VerseRange"];
    [dict setObject:@"Verse" forKey:@"SearchScope"];
    [dict setObject:@"abc" forKey:@"SearchPattern"];
    [dict setObject:@"Hebrew" forKey:@"SearchFieldFont"];

    [self.document loadDocumentContents:dict];

    XCTAssertEqual(YES, self.document.searchSettings.removePilcrows);
    XCTAssertEqual(YES, self.document.searchSettings.removeBracketedText);
    XCTAssertEqual(YES, self.document.searchSettings.removeSpaces);
    XCTAssertEqual(YES, self.document.searchSettings.removeTrailingSpaces);
    XCTAssertEqual(YES, self.document.searchSettings.hebrewRemoveCantillation);
    XCTAssertEqual(YES, self.document.searchSettings.hebrewRemovePoints);
    XCTAssertEqual(YES, self.document.searchSettings.hebrewRemovePunctuation);
    XCTAssertEqual(YES, self.document.searchSettings.greekRemoveDiacritics);
    XCTAssertEqual(YES, self.document.searchSettings.greekRemovePunctuation);
    XCTAssertEqual(YES, self.document.searchSettings.ignoreCase);
    XCTAssertEqual(YES, self.document.searchSettings.includeReference);
    XCTAssertEqual(YES, self.document.searchSettings.groupByBook);
    XCTAssertEqualObjects(@"Abc", self.document.searchSettings.textName);
    XCTAssertEqualObjects(@"Def - Ghi", self.document.searchSettings.verseRange);
    XCTAssertEqualObjects(@"Verse", self.document.searchSettings.searchScopeString);
    XCTAssertEqual(YES, self.document.searchSettings.leftToRightOverride);
    XCTAssertEqualObjects(@"abc", self.document.searchSettings.searchPattern);
    XCTAssertEqualObjects(@"Hebrew", self.document.searchSettings.searchFieldFont);

}

@end
