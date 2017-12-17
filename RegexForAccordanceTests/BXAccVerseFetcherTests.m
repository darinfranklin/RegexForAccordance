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
#import "BXSearchSettings.h"

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

- (void)testChapterScopePutsSpaceBetweenVersesAndRefUsesFirstVerseOfRange
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"Gen 1"];
    [acc setSearchScope:SearchScopeChapter];
    BXVerse *verse, *lastVerse;
    verse = [acc nextVerse];
    lastVerse = verse;
    XCTAssertTrue([verse.ref.book hasPrefix:@"Gen"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);
    NSUInteger count = 1;
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
        count++;
    }
    NSLog(@"length %ld", lastVerse.text.length);
    XCTAssertTrue([lastVerse.text containsString:@"heaven and the earth. And the earth was"],
                  @"%@", [lastVerse.text substringWithRange:NSMakeRange(50, 80)]);
    XCTAssertTrue([lastVerse.text containsString:@"shall be for meat. And to every beast"],
                  @"%@", [lastVerse.text substringWithRange:NSMakeRange(3900, 77)]);
    XCTAssertTrue([lastVerse.text hasSuffix:@"And the evening and the morning were the sixth day."],
                  @"%@", [lastVerse.text substringWithRange:NSMakeRange(lastVerse.text.length - 50, 50)]);
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"Gen"]);
    XCTAssertEqual(1, lastVerse.ref.chapter);
    XCTAssertEqual(1, lastVerse.ref.verse);
    XCTAssertEqual(1, count);
}

- (void)testChapterScopeUsesFirstVerseOfChapterAsRef
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"Gen 9:3 - Exod 2:7"];
    [acc setSearchScope:SearchScopeChapter];
    BXVerse *verse, *lastVerse;
    verse = [acc nextVerse];
    lastVerse = verse;
    XCTAssertTrue([verse.ref.book hasPrefix:@"Gen"]);
    XCTAssertEqual(9, verse.ref.chapter);
    XCTAssertEqual(3, verse.ref.verse);
    NSUInteger count = 1;
    while (nil != (verse = [acc nextVerse]))
    {
        lastVerse = verse;
        XCTAssertEqual(1, verse.ref.verse);
        count++;
    }
    XCTAssertTrue([lastVerse.ref.book hasPrefix:@"Exo"]);
    XCTAssertEqual(2, lastVerse.ref.chapter);
    XCTAssertEqual(1, lastVerse.ref.verse);
    XCTAssertEqual(44, count);
}

- (void)testBookScopeUsesFirstVerseOfBookAsRef
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"1Th 2:7 - 1Tim 1:8"]; // 128 verses
    [acc setSearchScope:SearchScopeBook];
    BXVerse *verse;
    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 Th"]);
    XCTAssertEqual(2, verse.ref.chapter);
    XCTAssertEqual(7, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"2 Th"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 Tim"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNil(verse);
}

- (void)testNonContiguousRangeChapterScope
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"Matt 27:63 - Mark 2:2, 4:4-5:6"]; // 115 verses; max is 500 for non-contiguous ranges
    [acc setSearchScope:SearchScopeChapter];
    BXVerse *verse;

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Matt"]);
    XCTAssertEqual(27, verse.ref.chapter);
    XCTAssertEqual(63, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Matt"]);
    XCTAssertEqual(28, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Mark"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Mark"]);
    XCTAssertEqual(2, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Mark"]);
    XCTAssertEqual(4, verse.ref.chapter);
    XCTAssertEqual(4, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertTrue([verse.ref.book hasPrefix:@"Mark"]);
    XCTAssertEqual(5, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNil(verse);
}

- (void)testLargeRangeBookScope
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"Acts 21:10 - Gal 2:2"]; // 1410 verses in 3 fetches
    [acc setSearchScope:SearchScopeBook];
    BXVerse *verse;

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"Acts"]);
    XCTAssertEqual(21, verse.ref.chapter);
    XCTAssertEqual(10, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"Rom"], @"%@", verse.ref.book);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 Cor"], @"%@", verse.ref.book);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"2 Cor"], @"%@", verse.ref.book);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"Gal"], @"%@", verse.ref.book);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNil(verse);
}

- (void)testSmallBooksInBookScope
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"1Jn - Jude"]; // 158 verses; 4 books
    [acc setSearchScope:SearchScopeBook];
    BXVerse *verse;

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"2 John"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"3 John"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"Jude"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNil(verse);
}

- (void)testSmallBooksInChapterScope
{
    BXAccVerseFetcher *acc = [[BXAccVerseFetcher alloc] init];
    [acc setTextName:@"KJVS"];
    [acc setVerseRange:@"1Jn - Jude"]; // 158 verses; 4 books
    [acc setSearchScope:SearchScopeChapter];
    BXVerse *verse;

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(1, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(2, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(3, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(4, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"1 John"]);
    XCTAssertEqual(5, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"2 John"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"3 John"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNotNil(verse);
    XCTAssertTrue([verse.ref.book hasPrefix:@"Jude"], @"%@", verse.ref.book);
    XCTAssertEqual(0, verse.ref.chapter);
    XCTAssertEqual(1, verse.ref.verse);

    verse = [acc nextVerse];
    XCTAssertNil(verse);
}

@end
