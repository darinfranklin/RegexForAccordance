//
//  BXStatisticsTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/16/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXStatistics.h"

@interface BXStatisticsTests : XCTestCase

@end

@implementation BXStatisticsTests
{
    BXStatistics *stats;
}

- (void)setUp
{
    [super setUp];
    stats = [[BXStatistics alloc] init];
}

- (BXSearchResult *)makeSearchResult:(NSString *)text book:(NSString *)book
{
    BXSearchResult *result = [[BXSearchResult alloc] init];
    result.verse = [[BXVerse alloc] init];
    result.verse.text = text;
    result.verse.ref = [[BXVerseRef alloc] initWithBook:book chapter:1 verse:1];
    NSRange range = NSMakeRange(0, 3);
    NSTextCheckingResult *hit = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&range
                                                                                          count:1
                                                                              regularExpression:nil];
    result.hits = [NSArray arrayWithObjects:hit, nil];
    return result;
}

- (void)testStatistics
{
    stats.ignoreCase = YES;
    [stats addSearchResult:[self makeSearchResult:@"foo" book:@"A"]];
    XCTAssertEqual(1, [[stats searchResultHitsForHitKey:@"foo"] count]);
    [stats addSearchResult:[self makeSearchResult:@"Foo" book:@"A"]];
    XCTAssertEqual(2, [[stats searchResultHitsForHitKey:@"Foo"] count]);
    [stats addSearchResult:[self makeSearchResult:@"foo" book:@"A"]];
    XCTAssertEqual(3, [[stats searchResultHitsForHitKey:@"foo"] count]);

//    XCTAssertEqual(3, [[stats searchResultHitsForHitKey:@"foo" andBook:@"A"] count]);
    
    [stats addSearchResult:[self makeSearchResult:@"bar" book:@"A"]];
    XCTAssertEqual(1, [[stats searchResultHitsForHitKey:@"bar"] count]);
    XCTAssertEqual(0, [[stats searchResultHitsForHitKey:@"baz"] count]);
}

- (void)testAddSearchResults
{
    BXSearchResult *result = [[BXSearchResult alloc] init];
    result.verse = [[BXVerse alloc] init];
    result.verse.text = @"abc";
    result.verse.ref = [[BXVerseRef alloc] initWithBook:@"A" chapter:1 verse:1];
    NSRange range = NSMakeRange(0, 3);
    NSTextCheckingResult *hit = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&range
                                                                                          count:1
                                                                              regularExpression:nil];
    result.hits = [NSArray arrayWithObjects:hit, nil];
    [stats addSearchResult:result];
    XCTAssertEqual(1, stats.countOfSearchResults);
    XCTAssertEqual(1, stats.countOfHitKeys);
    XCTAssertEqual(1, stats.countOfHits);

    result.verse.text = @"abc";
    [stats addSearchResult:result];
    XCTAssertEqual(2, stats.countOfSearchResults);
    XCTAssertEqual(1, stats.countOfHitKeys);
    XCTAssertEqual(2, stats.countOfHits);
    
    result.verse.text = @"def";
    [stats addSearchResult:result];
    XCTAssertEqual(3, stats.countOfSearchResults);
    XCTAssertEqual(2, stats.countOfHitKeys);
    XCTAssertEqual(3, stats.countOfHits);

    result.hits = [NSArray arrayWithObjects:hit, hit, nil];
    [stats addSearchResult:result];
    XCTAssertEqual(4, stats.countOfSearchResults);
    XCTAssertEqual(2, stats.countOfHitKeys);
    XCTAssertEqual(5, stats.countOfHits);
}

@end
