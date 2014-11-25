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

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseVerse
{
    BXLineParser *parser = [[BXLineParser alloc] init];
    BXVerse *verse = [parser verseForLine:@"Abc 1:23 blah blah blah"];
    XCTAssertEqualObjects(@"Abc 1:23", [verse.ref stringValue]);
    XCTAssertEqualObjects(@"blah blah blah", verse.text);
    XCTAssertEqualObjects(@"Abc", verse.ref.book);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(23, verse.ref.verse);
}

- (void)testParseVerseWithVerseOnly
{
    BXLineParser *parser = [[BXLineParser alloc] init];
    BXVerse *verse = [parser verseForLine:@"3 John 1 The elder to the beloved Gaius, whom I love in truth. "];
    XCTAssertEqualObjects(@"3 John 1", [verse.ref stringValue]);
    XCTAssertEqualObjects(@"The elder to the beloved Gaius, whom I love in truth. ", verse.text);
    XCTAssertEqualObjects(@"3 John", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
}

@end
