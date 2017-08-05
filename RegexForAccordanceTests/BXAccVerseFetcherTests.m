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
    XCTAssertTrue([names containsObject:@"NKJVS"]); // don't drop first character
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
    NSUInteger count = 1;
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
        count++;
    }
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"Ps"]);
    XCTAssertEqual(150, lastVerse.ref.chapter);
    XCTAssertEqual(6, lastVerse.ref.verse);
    XCTAssertEqual(2577, count);
}

- (void)testFetchFullRangeHebrew
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"HMT-W4"];
    [acc setVerseRange:@"Gen-Deut"];
    BXVerse *verse, *lastVerse;
    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Gen"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    NSUInteger count = 1;
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
        count++;
    }
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"Deut"]);
    XCTAssertEqual(34, lastVerse.ref.chapter);
    XCTAssertEqual(12, lastVerse.ref.verse);
    XCTAssertEqual(5853, count);
}

- (void)testFetchFullRangeGreek
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"GNT-TR"];
    [acc setVerseRange:@"Matt-John"];
    BXVerse *verse, *lastVerse;
    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Mat"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    NSUInteger count = 1;
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
        count++;
    }
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"John"]);
    XCTAssertEqual(21, lastVerse.ref.chapter);
    XCTAssertEqual(25, lastVerse.ref.verse);
    XCTAssertEqual(3779, count);
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

- (void)testVersesWithLineBreaksAndBlankLine
{
    NSString *verse1 = @"Ps 2:12 kiss his feet,\r"
    "\tor he will be angry, and you will perish in the way;\r"
    "\tfor his wrath is quickly kindled.\r"
    "\r"
    "\t\r"
    "\t¶ Happy are all who take refuge in him.\r"
    " ";
    NSString *lines = verse1;
    BXTestAccVerseFetcher *fetcher = [[BXTestAccVerseFetcher alloc] initWithLines:lines];
    [fetcher setTextName:@"NRSVS"];
    [fetcher setVerseRange:@"Ps 2:12"];
    BXVerse *verse = [fetcher nextVerse];
    XCTAssertEqualObjects(verse.text, [[verse1 substringFromIndex:8] stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"]);
}

@end
