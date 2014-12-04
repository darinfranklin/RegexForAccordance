//
//  BXStatisticsGroupsTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXStatisticsGroups.h"
#import "BXTestSearchResult.h"

@interface BXStatisticsGroupsTests : XCTestCase

@end

@implementation BXStatisticsGroupsTests

- (void)testGroups
{
    BXStatisticsGroups *groups = [[BXStatisticsGroups alloc] init];
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"Gen"]];
    XCTAssertEqual(1, groups.countOfGroups);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);
    XCTAssertEqual(1, groups.combinedStatistics.distinctHits.count);
    XCTAssertEqual(1, [groups groupAtIndex:0].statistics.distinctHits.count);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);

    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"bbb" book:@"Gen"]];
    XCTAssertEqual(1, groups.countOfGroups);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);
    XCTAssertEqual(2, groups.combinedStatistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:0].statistics.distinctHits.count);
    
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"ccc" book:@"Deut"]];
    XCTAssertEqual(2, groups.countOfGroups);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);
    XCTAssertEqualObjects(@"Deut", [groups groupAtIndex:1].name);
    XCTAssertEqual(3, groups.combinedStatistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:0].statistics.distinctHits.count);
    XCTAssertEqual(1, [groups groupAtIndex:1].statistics.distinctHits.count);
    XCTAssertEqualObjects(@"Deut", [groups groupAtIndex:1].name);
    
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"Deut"]];
    XCTAssertEqual(2, groups.countOfGroups);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);
    XCTAssertEqualObjects(@"Deut", [groups groupAtIndex:1].name);
    XCTAssertEqual(3, groups.combinedStatistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:0].statistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:1].statistics.distinctHits.count);
    
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"Gen"]];
    XCTAssertEqual(3, groups.countOfGroups);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:0].name);
    XCTAssertEqualObjects(@"Deut", [groups groupAtIndex:1].name);
    XCTAssertEqualObjects(@"Gen", [groups groupAtIndex:2].name);
    XCTAssertEqual(3, groups.combinedStatistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:0].statistics.distinctHits.count);
    XCTAssertEqual(2, [groups groupAtIndex:1].statistics.distinctHits.count);
    XCTAssertEqual(1, [groups groupAtIndex:2].statistics.distinctHits.count);
}

- (void)testGettingRows
{
    BXStatisticsGroups *groups = [[BXStatisticsGroups alloc] init];                        // 0 Gen
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"aaa" book:@"Gen"]]; // 1
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"bbb" book:@"Gen"]]; // 2
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"bbb" book:@"Gen"]]; // 2 - bbb++ but no new row
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"ccc" book:@"Gen"]]; // 3
                                                                                           // 4 Exod
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"ddd" book:@"Exod"]];// 5
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"eee" book:@"Exod"]];// 6
                                                                                           // 7 Lev
    [groups addSearchResult:[[BXTestSearchResult alloc] initWithText:@"fff" book:@"Lev"]]; // 8

    XCTAssertEqual(0, [groups groupRowForGroupIndex:0]);

    XCTAssertEqual(1 + 3, [[groups groupAtIndex:0] cumulativeRowCount]);
    XCTAssertEqual(1 + 3, [groups groupRowForGroupIndex:1]);

    XCTAssertEqual(1 + 3 + 1 + 2, [[groups groupAtIndex:1] cumulativeRowCount]);
    XCTAssertEqual(1 + 3 + 1 + 2, [groups groupRowForGroupIndex:2]);

    XCTAssertEqual(1 + 3 + 1 + 2 + 1 + 1, [[groups groupAtIndex:2] cumulativeRowCount]);
    XCTAssertEqual(1 + 3 + 1 + 2 + 1 + 1, [groups groupRowForGroupIndex:3]);

    XCTAssertEqual(1 + 3 + 1 + 2 + 1 + 1, [groups numberOfRows]);
    
    XCTAssertEqual(0, [groups groupIndexForRow:0]);
    XCTAssertEqual(0, [groups groupIndexForRow:1]);
    XCTAssertEqual(0, [groups groupIndexForRow:3]);
    XCTAssertEqual(1, [groups groupIndexForRow:4]);
    XCTAssertEqual(1, [groups groupIndexForRow:6]);
    XCTAssertEqual(2, [groups groupIndexForRow:7]);
    XCTAssertEqual(2, [groups groupIndexForRow:8]);
    XCTAssertEqual(YES, [groups isGroupRow:0]);
    XCTAssertEqual(NO, [groups isGroupRow:1]);
    XCTAssertEqual(NO, [groups isGroupRow:3]);
    XCTAssertEqual(YES, [groups isGroupRow:4]);
    XCTAssertEqual(NO, [groups isGroupRow:5]);
    XCTAssertEqual(YES, [groups isGroupRow:7]);
    
    XCTAssertEqual(3, [groups statisticsForGroupIndex:0].countOfHitKeys);
    XCTAssertEqual(2, [groups statisticsForGroupIndex:1].countOfHitKeys);
    XCTAssertEqual(1, [groups statisticsForGroupIndex:2].countOfHitKeys);
    
    XCTAssertEqual(0, [groups indexInStatisticsForRow:1]);
    XCTAssertEqual(1, [groups indexInStatisticsForRow:2]);
    XCTAssertEqual(2, [groups indexInStatisticsForRow:3]);
    XCTAssertEqual(0, [groups indexInStatisticsForRow:5]);
    XCTAssertEqual(1, [groups indexInStatisticsForRow:6]);
    XCTAssertEqual(0, [groups indexInStatisticsForRow:8]);
    
    [groups sortAllByHitKey];
    XCTAssertEqualObjects(@"bbb", [groups keyInStatisticsForRow:2]);
    XCTAssertEqualObjects(@"eee", [groups keyInStatisticsForRow:6]);
    XCTAssertEqualObjects(@"fff", [groups keyInStatisticsForRow:8]);
    

}

@end









