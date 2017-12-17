//
//  BXVerseRangeRefTests.m
//  RegexForAccordanceTests
//
//  Created by Darin Franklin on 12/16/17.
//  Copyright © 2017 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXVerseRangeRef.h"
#import "BXVerseRef.h"
#import "BXSearchSettings.h"

@interface BXVerseRangeRefTests : XCTestCase

@end

@implementation BXVerseRangeRefTests

- (void)testRangeSearchScopeVerse
{
    BXVerseRef *first = [[BXVerseRef alloc] initWithBook:@"1 Tim" chapter:1 verse:1];
    BXVerseRef *last = [[BXVerseRef alloc] initWithBook:@"2 Tim" chapter:4 verse:22];
    BXVerseRangeRef *ref = [[BXVerseRangeRef alloc] initWithFirstRef:first lastRef:last searchScope:SearchScopeVerse];
    XCTAssertEqualObjects(@"1 Tim 1:1 - 2 Tim 4:22", ref.stringValue);
    XCTAssertEqualObjects(@"1 Tim", ref.book);
    XCTAssertEqual(1, ref.chapter);
    XCTAssertEqual(1, ref.verse);
}

- (void)testRangeSearchScopeChapter
{
    BXVerseRef *first = [[BXVerseRef alloc] initWithBook:@"1 Tim" chapter:1 verse:1];
    BXVerseRef *last = [[BXVerseRef alloc] initWithBook:@"2 Tim" chapter:4 verse:22];  // end ignored; we must assume that the range includes only one chapter
    BXVerseRangeRef *ref = [[BXVerseRangeRef alloc] initWithFirstRef:first lastRef:last searchScope:SearchScopeChapter];
    XCTAssertEqualObjects(@"1 Tim 1", ref.stringValue);
    XCTAssertEqualObjects(@"1 Tim", ref.book);
    XCTAssertEqual(1, ref.chapter);
    XCTAssertEqual(1, ref.verse);
}

- (void)testRangeSearchScopeBook
{
    BXVerseRef *first = [[BXVerseRef alloc] initWithBook:@"1 Tim" chapter:1 verse:1];
    BXVerseRef *last = [[BXVerseRef alloc] initWithBook:@"2 Tim" chapter:4 verse:22]; // end ignored; we must assume that the range includes only one book
    BXVerseRangeRef *ref = [[BXVerseRangeRef alloc] initWithFirstRef:first lastRef:last searchScope:SearchScopeBook];
    XCTAssertEqualObjects(@"1 Tim", ref.stringValue);
    XCTAssertEqualObjects(@"1 Tim", ref.book);
    XCTAssertEqual(1, ref.chapter);
    XCTAssertEqual(1, ref.verse);
}

@end
