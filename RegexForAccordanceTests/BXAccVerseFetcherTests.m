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
    XCTAssertTrue([verse.ref.book hasPrefix:@"Ps"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    XCTAssertEqual(1, verse.lineNumber);
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
    }
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"Ps"]);
    XCTAssertEqual(150, lastVerse.ref.chapter);
    XCTAssertEqual(6, lastVerse.ref.verse);
    XCTAssertEqual(2577, lastVerse.lineNumber);
}

@end
