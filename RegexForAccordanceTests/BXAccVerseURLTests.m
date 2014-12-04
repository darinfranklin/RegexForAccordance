//
//  BXAccVerseURLTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXAccVerseURL.h"
#import "BXTestSearchResult.h"
#import "BXAccLink.h"

@interface BXAccVerseURLTests : XCTestCase

@end

@implementation BXAccVerseURLTests
{
    BXAccVerseURL *urlFormatter;
}

- (void)setUp
{
    [super setUp];
    urlFormatter = [[BXAccVerseURL alloc] init];
}

- (void)testURL
{
    XCTAssertEqualObjects(@"accord://read/ESVS?John%201:23", [[urlFormatter urlForVerseRef:@"John 1:23" inText:@"ESVS"] absoluteString]);
}

- (void)testURLEscaping
{
    XCTAssertEqualObjects(@"accord://read/My%20User%20Bible?1%20John%201:2",
                          [[urlFormatter urlForVerseRef:@"1 John 1:2" inText:@"My User Bible"] absoluteString]);
}

- (void)testURLWithRefList
{
    XCTAssertEqualObjects(@"accord://read/KJVS?Matt%201:1;1%20Cor%203:5;%20Rev%2022:19",
                          [[urlFormatter urlForVerseRef:@"Matt 1:1;1 Cor 3:5; Rev 22:19"
                                                 inText:@"KJVS"] absoluteString]);
}

- (void)testLinksForSearchResults
{
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    for (int chapter = 1; chapter <= 250; chapter++)
    {
        for (int verse = 1; verse <= 2; verse++)
        {
            BXTestSearchResult *searchResult = [[BXTestSearchResult alloc] initWithText:@"NRSVS" book:@"Bob" chapter:chapter verse:verse];
            [searchResults addObject:searchResult];
        }
    }
    NSArray *links = [urlFormatter linksForSearchResults:searchResults textName:@"NRSVS"];
    XCTAssertEqual(3, links.count);
    BXAccLink *link = [links objectAtIndex:0];
    XCTAssertEqual(1, link.firstVerseRef.chapter);
    XCTAssertEqual(125, link.lastVerseRef.chapter);
    XCTAssertTrue([link.url.absoluteString hasPrefix:@"accord://read/NRSVS?Bob%201:1-2;%202:1-2"], @"%@", link.url.absoluteString);
    XCTAssertTrue([link.url.absoluteString hasSuffix:@";%20125:1-2"], @"%@", link.url.absoluteString);

    link = [links objectAtIndex:1];
    XCTAssertEqual(126, link.firstVerseRef.chapter);
    XCTAssertEqual(238, link.lastVerseRef.chapter);
    XCTAssertTrue([link.url.absoluteString hasPrefix:@"accord://read/NRSVS?Bob%20126:1-2;%20127:1-2"], @"%@", link.url.absoluteString);
    XCTAssertTrue([link.url.absoluteString hasSuffix:@";%20238:1-2"], @"%@", link.url.absoluteString);
    
    link = [links objectAtIndex:2];
    XCTAssertEqual(239, link.firstVerseRef.chapter);
    XCTAssertEqual(250, link.lastVerseRef.chapter);
    XCTAssertTrue([link.url.absoluteString hasPrefix:@"accord://read/NRSVS?Bob%20239:1-2;%20240:1-2"], @"%@", link.url.absoluteString);
    XCTAssertTrue([link.url.absoluteString hasSuffix:@";%20250:1-2"], @"%@", link.url.absoluteString);
}

@end
