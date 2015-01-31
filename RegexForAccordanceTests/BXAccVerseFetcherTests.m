//
//  BXAccVerseFetcherTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXAccVerseFetcher.h"
#import "BXTestAccVerseFetcher.h"

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

- (void)testVersesWithLineBreaks
{
    NSString *verse1 = @"Ps 1:1 ¶ \tHappy the man\r"
    "\twho did not walk by the counsel of the impious,\r"
    "\tand in the way of sinners did not stand,\r"
    "\tand on the seat of pestiferous people did not sit down. ";
    NSString *verse2 = @"Ps 1:2 \tRather, his will is in the law of the Lord,\r"
    "\tand on his law he will meditate day and night. ";
    NSString *lines = [NSString stringWithFormat:@"%@\r%@", verse1, verse2];
    BXTestAccVerseFetcher *fetcher = [[BXTestAccVerseFetcher alloc] initWithLines:lines];
    [fetcher setTextName:@"NETS"];
    [fetcher setVerseRange:@"Ps 1:1-2"];
    BXVerse *verse = [fetcher nextVerse];
    XCTAssertEqualObjects(verse.text, [[verse1 substringFromIndex:7] stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"]);
}

@end
