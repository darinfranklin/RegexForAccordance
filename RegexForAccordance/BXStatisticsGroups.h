//
//  BXStatisticsGroups.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/28/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXStatistics.h"
#import "BXSearchResult.h"
#import "BXStatisticsGroup.h"

@interface BXStatisticsGroups : NSObject
@property BOOL ignoreCase;
- (void)reset;
- (BXStatistics *)combinedStatistics;
- (void)addSearchResult:(BXSearchResult *)searchResult;
- (BXStatisticsGroup *)groupAtIndex:(NSUInteger)index;
- (NSUInteger)countOfGroups;
- (NSUInteger)groupRowForGroupIndex:(NSUInteger)index;
- (NSUInteger)numberOfRows;
- (BOOL)isGroupRow:(NSInteger)row;
- (NSUInteger)groupIndexForRow:(NSInteger)row;
- (BXStatistics *)statisticsForGroupIndex:(NSUInteger)groupIndex;
- (NSUInteger)indexInStatisticsForRow:(NSInteger)row;
- (NSString *)keyInStatisticsForRow:(NSInteger)row;

- (void)sortAllByHitKey;
- (void)sortAllByHitKeyLength;
- (void)sortAllByHitCount;
- (void)sortAllByRefs;

@end
