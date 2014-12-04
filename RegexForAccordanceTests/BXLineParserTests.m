//
//  BXLineParserTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXLineParser.h"
#import "BXVerse.h"
#import "BXVerseRef.h"

@interface BXLineParserTests : XCTestCase

@end

@implementation BXLineParserTests

- (void)testBookVerse
{
    BXVerse *verse = [[[BXLineParser alloc] init] verseForLine:@"Abc 1 abc def ghi"];
    XCTAssertEqualObjects(@"Abc", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    XCTAssertEqualObjects(@"Abc 1", verse.ref.stringValue);
    XCTAssertEqualObjects(@"abc def ghi", verse.text);
    XCTAssertEqualObjects(@"abc def ghi", [verse textIncludingReference:NO]);
    XCTAssertEqualObjects(@"Abc 1 abc def ghi", [verse textIncludingReference:YES]);
}

- (void)testBookChapterVerse
{
    BXVerse *verse = [[[BXLineParser alloc] init] verseForLine:@"Abc 2:1 abc def ghi"];
    XCTAssertEqualObjects(@"Abc", verse.ref.book);
    XCTAssertEqual(2, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    XCTAssertEqualObjects(@"Abc 2:1", verse.ref.stringValue);
    XCTAssertEqualObjects(@"abc def ghi", verse.text);
    XCTAssertEqualObjects(@"abc def ghi", [verse textIncludingReference:NO]);
    XCTAssertEqualObjects(@"Abc 2:1 abc def ghi", [verse textIncludingReference:YES]);
}

- (void)testNumberBookChapterVerse
{
    BXVerse *verse = [[[BXLineParser alloc] init] verseForLine:@"3 Abc 2:4 abc def ghi"];
    XCTAssertEqualObjects(@"3 Abc", verse.ref.book);
    XCTAssertEqual(2, verse.ref.chapter);
    XCTAssertEqual(4, verse.ref.verse);
    XCTAssertEqualObjects(@"3 Abc 2:4", verse.ref.stringValue);
    XCTAssertEqualObjects(@"abc def ghi", verse.text);
    XCTAssertEqualObjects(@"abc def ghi", [verse textIncludingReference:NO]);
    XCTAssertEqualObjects(@"3 Abc 2:4 abc def ghi", [verse textIncludingReference:YES]);
}

- (void)testNumberBookVerse
{
    BXVerse *verse = [[[BXLineParser alloc] init] verseForLine:@"3 Abc 2 abc def ghi"];
    XCTAssertEqualObjects(@"3 Abc", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(2, verse.ref.verse);
    XCTAssertEqualObjects(@"3 Abc 2", verse.ref.stringValue);
    XCTAssertEqualObjects(@"abc def ghi", verse.text);
    XCTAssertEqualObjects(@"abc def ghi", [verse textIncludingReference:NO]);
    XCTAssertEqualObjects(@"3 Abc 2 abc def ghi", [verse textIncludingReference:YES]);
}

@end
