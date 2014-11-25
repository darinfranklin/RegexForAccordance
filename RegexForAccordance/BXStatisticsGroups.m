//
//  BXStatisticsGroups.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/28/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXStatisticsGroups.h"

@interface BXStatisticsGroups ()
@property BXStatistics *combinedStatistics;
@property NSMutableArray *groups; // of BXStatisticsGroup
@end

@implementation BXStatisticsGroups

- (id)init
{
    if (self = [super init])
    {
        self.combinedStatistics = [[BXStatistics alloc] init];
        self.groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reset
{
    [self.combinedStatistics reset];
    [self.groups removeAllObjects];
}

- (void)addSearchResult:(BXSearchResult *)searchResult
{
    self.combinedStatistics.ignoreCase = self.ignoreCase;
    [self.combinedStatistics addSearchResult:searchResult];
    [self addSearchResult:searchResult forGroup:searchResult.verse.ref.book];
}

- (void)addSearchResult:(BXSearchResult *)searchResult forGroup:(NSString *)groupName
{
    BXStatisticsGroup *group = nil;
    if (self.groups.count > 0)
    {
        group = [self.groups objectAtIndex:self.groups.count - 1];
    }
    if (group == nil || ![group.name isEqualToString:groupName])
    {
        group = [[BXStatisticsGroup alloc] initWithName:groupName];
        group.statistics.ignoreCase = self.ignoreCase;
        [self.groups addObject:group];
    }
    [group.statistics addSearchResult:searchResult];
    group.cumulativeRowCount = 1 + group.statistics.countOfHitKeys;
    if (self.groups.count >= 2)
    {
        group.cumulativeRowCount += [self groupAtIndex:self.groups.count - 2].cumulativeRowCount;
    }
}

- (BXStatisticsGroup *)groupAtIndex:(NSUInteger)index
{
    return [self.groups objectAtIndex:index];
}

- (NSUInteger)countOfGroups
{
    return self.groups.count;
}

- (NSUInteger)groupRowForGroupIndex:(NSUInteger)groupIndex;
{
    if (groupIndex == 0)
    {
        return 0;
    }
    else
    {
        return [self groupAtIndex:groupIndex - 1].cumulativeRowCount;
    }
}

- (NSUInteger)numberOfRows
{
    return [self groupRowForGroupIndex:self.groups.count];
}

- (NSUInteger)groupIndexForRow:(NSInteger)row
{
    NSUInteger groupIndex;
    for (groupIndex = 0; groupIndex < self.countOfGroups; groupIndex++)
    {
        if ([self groupRowForGroupIndex:groupIndex] > row)
        {
            return groupIndex - 1;
        }
    }
    return groupIndex - 1;
}

- (BOOL)isGroupRow:(NSInteger)row
{
    NSUInteger groupIndex = [self groupIndexForRow:row];
    if (groupIndex >= self.countOfGroups)
    {
        return false;
    }
    NSUInteger count = [self groupRowForGroupIndex:groupIndex];
    return count == row;
}

- (BXStatistics *)statisticsForGroupIndex:(NSUInteger)groupIndex
{
    BXStatisticsGroup *group = [self.groups objectAtIndex:groupIndex];
    return group.statistics;
}

- (NSUInteger)indexInStatisticsForRow:(NSInteger)row
{
    NSUInteger groupIndex = [self groupIndexForRow:row];
    NSUInteger count = 1 + [self groupRowForGroupIndex:groupIndex];
    return row - count;
}


- (NSString *)keyInStatisticsForRow:(NSInteger)row
{
    NSUInteger groupIndex = [self groupIndexForRow:row];
    BXStatistics *statistics = [self statisticsForGroupIndex:groupIndex];
    NSUInteger index = [self indexInStatisticsForRow:row];
    NSArray *sortedKeys = statistics.sortedKeys;
    NSString *key = [sortedKeys objectAtIndex:index];
    return key;
}

- (void)sortAllByHitKey
{
    [self.combinedStatistics sortByHitKey];
    for (BXStatisticsGroup *group in [self.groups copy])
    {
        [group.statistics sortByHitKey];
    }
}

- (void)sortAllByHitKeyLength
{
    [self.combinedStatistics sortByHitKeyLength];
    for (BXStatisticsGroup *group in [self.groups copy])
    {
        [group.statistics sortByHitKeyLength];
    }
}

- (void)sortAllByHitCount
{
    [self.combinedStatistics sortByHitCount];
    NSArray *myGroups = [self.groups copy];
    for (BXStatisticsGroup *group in myGroups)
    {
        [group.statistics sortByHitCount];
    }
}

- (void)sortAllByRefs
{
    [self.combinedStatistics sortByRefs];
    NSArray *myGroups = [self.groups copy];
    for (BXStatisticsGroup *group in myGroups)
    {
        [group.statistics sortByRefs];
    }
}

@end
