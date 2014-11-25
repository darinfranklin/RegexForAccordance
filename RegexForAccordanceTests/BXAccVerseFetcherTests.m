//
//  BXAccVerseFetcherTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXAccVerseFetcher.h"

@interface BXAccVerseFetcherTests : XCTestCase

@end

@implementation BXAccVerseFetcherTests

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

- (void)testFetchTextNames
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    NSArray *names = acc.availableTexts;
    XCTAssertTrue(names.count > 0);
    XCTAssertTrue([names containsObject:@"KJVS"]);
}

- (void)testFetchFullRange
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"Psalms"];
    BXVerse *verse, *lastVerse;
    verse = [acc nextVerse];
    XCTAssertEqualObjects(@"Ps 1:1", verse.ref.stringValue);
    XCTAssertEqual(1, verse.lineNumber);
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
    }
    XCTAssertEqualObjects(@"Ps 150:6", lastVerse.ref.stringValue);
    XCTAssertEqual(2577, lastVerse.lineNumber);
}

@end
