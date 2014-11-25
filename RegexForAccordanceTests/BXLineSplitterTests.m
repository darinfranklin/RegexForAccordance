//
//  BXLineSplitterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXLineSplitter.h"

@interface BXLineSplitterTests : XCTestCase
{
}
@end

@implementation BXLineSplitterTests
BXLineSplitter *splitter;

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIterateLines
{
    splitter = [[BXLineSplitter alloc] initWithString:@"line one\rline two\rline three" delimiter:@"\r"];
    XCTAssertEqualObjects(@"line one", [splitter peekAtNextLine]);
    XCTAssertEqualObjects(@"line one", [splitter peekAtNextLine]);
    XCTAssertEqualObjects(@"line one", [splitter nextLine]);
    XCTAssertEqualObjects(@"line two", [splitter peekAtNextLine]);
    XCTAssertEqualObjects(@"line two", [splitter nextLine]);
    XCTAssertEqualObjects(@"line three", [splitter peekAtNextLine]);
    XCTAssertEqualObjects(@"line three", [splitter nextLine]);
    XCTAssertEqualObjects(nil, [splitter peekAtNextLine]);
    XCTAssertEqualObjects(nil, [splitter nextLine]);
    XCTAssertEqualObjects(nil, [splitter peekAtNextLine]);
    XCTAssertEqualObjects(nil, [splitter nextLine]);
}

@end
