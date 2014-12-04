//
//  BXStatisticsDatasourceTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXStatistics.h"
#import "BXStatisticsDatasource.h"
#import "BXSearchResultHit.h"
#import "BXTestSearchResult.h"

@interface BXStatisticsDatasourceTests : XCTestCase

@end

@implementation BXStatisticsDatasourceTests
{
    BXStatisticsGroups *statisticsGroups;
    BXStatistics *stats;
    BXStatisticsDatasource *ds;
}

- (void)setUp
{
    [super setUp];
    statisticsGroups = [[BXStatisticsGroups alloc] init];
    stats = statisticsGroups.combinedStatistics;
}

- (void)testSearchResultsForRow
{
    [statisticsGroups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"A"]];
    XCTAssertEqual(1, statisticsGroups.combinedStatistics.countOfSearchResults);
    XCTAssertEqual(1, statisticsGroups.combinedStatistics.countOfHitKeys);
    XCTAssertEqual(1, statisticsGroups.combinedStatistics.countOfHits);

    ds = [[BXStatisticsDatasource alloc] initWithStatisticsGroups:statisticsGroups];
    NSArray *searchResultHits = [ds searchResultHitsForRow:0];
    XCTAssertEqual(1, searchResultHits.count);
    BXSearchResultHit *searchResultHit = [searchResultHits objectAtIndex:0];
    BXSearchResult *searchResult = searchResultHit.searchResult;
    NSTextCheckingResult *hit = [[searchResult hits] objectAtIndex:0];
    XCTAssertEqualObjects(@"aaa", [searchResult.verse.text substringWithRange:hit.range]);

    [statisticsGroups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"bbb" book:@"A"]];
    [statisticsGroups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"abc" book:@"B"]];
    ds.groupByBook = YES;
    XCTAssertEqual(2, statisticsGroups.countOfGroups);
    XCTAssertEqual(2, [statisticsGroups groupAtIndex:0].statistics.countOfHits);
    XCTAssertEqual(1, [statisticsGroups groupAtIndex:1].statistics.countOfHits);
    XCTAssertEqual(5, [ds numberOfRowsInTableView:nil]);
    XCTAssertTrue([ds tableView:nil isGroupRow:0]);
    XCTAssertEqual(0, [ds.statisticsGroups groupIndexForRow:0]); // group row
    XCTAssertEqual(0, [ds.statisticsGroups groupIndexForRow:1]); // group 0 item 0
    XCTAssertEqual(0, [ds.statisticsGroups groupIndexForRow:2]); // group 0 item 1
    XCTAssertTrue([ds tableView:nil isGroupRow:3]);
    XCTAssertEqual(1, [ds.statisticsGroups groupIndexForRow:3]); // group 1 row
    XCTAssertEqual(1, [ds.statisticsGroups groupIndexForRow:4]); // group 1 item 0
}

- (void)testGetReferencesForDistinctHit
{
    [statisticsGroups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"A"]];
    [statisticsGroups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"B"]];
    ds = [[BXStatisticsDatasource alloc] initWithStatisticsGroups:statisticsGroups];
    
    XCTAssertEqualObjects(@"", [ds tableView:nil
                          objectValueForTableColumn:[[NSTableColumn alloc] initWithIdentifier:@"BXStatisticsRefs"]
                                                row:0]);
    XCTAssertEqualObjects(@"A 1:1; B 1:1", [ds refsForRow:0]);

}


- (void)testIncrementIndex
{
    ds = [[BXStatisticsDatasource alloc] init];
    XCTAssertEqual(0, [ds incrementIndex:0 byAmount:1 forCount:1]);
    
    XCTAssertEqual(1, [ds incrementIndex:0 byAmount:1 forCount:2]);
    XCTAssertEqual(0, [ds incrementIndex:1 byAmount:1 forCount:2]);
    
    XCTAssertEqual(1, [ds incrementIndex:0 byAmount:1 forCount:3]);
    XCTAssertEqual(2, [ds incrementIndex:1 byAmount:1 forCount:3]);
    XCTAssertEqual(0, [ds incrementIndex:2 byAmount:1 forCount:3]);
    
    XCTAssertEqual(1, [ds incrementIndex:2 byAmount:2 forCount:3]);
    XCTAssertEqual(2, [ds incrementIndex:2 byAmount:3 forCount:3]);
    XCTAssertEqual(0, [ds incrementIndex:2 byAmount:4 forCount:3]);
    XCTAssertEqual(1, [ds incrementIndex:2 byAmount:5 forCount:3]);
    
    XCTAssertEqual(2, [ds incrementIndex:2 byAmount:12 forCount:3]);
}

- (void)testIncrementIndexReverse
{
    ds = [[BXStatisticsDatasource alloc] init];
    XCTAssertEqual(0, [ds incrementIndex:0 byAmount:-1 forCount:1]);
    
    XCTAssertEqual(1, [ds incrementIndex:0 byAmount:-1 forCount:2]);
    XCTAssertEqual(0, [ds incrementIndex:1 byAmount:-1 forCount:2]);
    
    XCTAssertEqual(2, [ds incrementIndex:0 byAmount:-1 forCount:3]);
    XCTAssertEqual(0, [ds incrementIndex:1 byAmount:-1 forCount:3]);
    XCTAssertEqual(1, [ds incrementIndex:2 byAmount:-1 forCount:3]);
    
    XCTAssertEqual(0, [ds incrementIndex:2 byAmount:-2 forCount:3]);
    XCTAssertEqual(2, [ds incrementIndex:2 byAmount:-3 forCount:3]);
    XCTAssertEqual(1, [ds incrementIndex:2 byAmount:-4 forCount:3]);
    XCTAssertEqual(0, [ds incrementIndex:2 byAmount:-5 forCount:3]);
    
    XCTAssertEqual(2, [ds incrementIndex:2 byAmount:-12 forCount:3]);
}

@end

