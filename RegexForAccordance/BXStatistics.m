//
//  BXStatistics.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/16/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXStatistics.h"
#import "BXSearchResultHit.h"

@interface BXStatistics ()
{
    NSMutableDictionary *_distinctHits; // NSString -> NSMutableArray of BXSearchResultHit
    NSUInteger _countOfHits;
    NSUInteger _countOfSearchResults;
    NSArray *_sortedKeys;
    NSMutableArray *_unsortedKeys;
}
@end

@implementation BXStatistics

- (id)init
{
    if (self = [super init])
    {
        _distinctHits = [[NSMutableDictionary alloc] init];
        _countOfHits = 0;
        _unsortedKeys = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reset
{
    _countOfSearchResults = 0;
    _countOfHits = 0;
    [_distinctHits removeAllObjects];
    [_unsortedKeys removeAllObjects];
    _sortedKeys = nil;
}

- (void)addSearchResult:(BXSearchResult *)searchResult
{
    for (NSTextCheckingResult *hit in searchResult.hits)
    {
        NSString *hitKey = [searchResult stringForHit:hit];
        BXSearchResultHit *searchResultHit = [[BXSearchResultHit alloc] initWithSearchResult:searchResult hit:hit];
        [self addSearchResultHit:searchResultHit forHitKey:hitKey];
        _countOfHits += 1;
    }
    _countOfSearchResults += 1;
}

- (void)addSearchResultHit:(BXSearchResultHit *)searchResultHit forHitKey:(NSString *)hitKey
{
    if (self.ignoreCase)
    {
        hitKey = [hitKey lowercaseString];
    }
    NSMutableArray *searchResultHits = [_distinctHits objectForKey:hitKey];
    if (searchResultHits == nil)
    {
        searchResultHits = [[NSMutableArray alloc] init];
        [_distinctHits setObject:searchResultHits forKey:hitKey];
        [_unsortedKeys addObject:hitKey];
    }
    [searchResultHits addObject:searchResultHit];
}

- (NSUInteger)countOfSearchResults
{
    return _countOfSearchResults;
}

- (NSUInteger)countOfHits
{
    return _countOfHits;
}

- (NSUInteger)countOfHitKeys
{
    return _distinctHits.count;
}

- (NSDictionary *)distinctHits
{
    return _distinctHits;
}

- (NSArray *)searchResultHitsForHitKey:(NSString *)hitKey
{
    if (self.ignoreCase)
    {
        hitKey = [hitKey lowercaseString];
    }
    NSMutableArray *searchResultHits = [self.distinctHits objectForKey:hitKey];
    return searchResultHits;
}

- (void)sortByHitKey
{
    NSMutableArray *keys = [self.distinctHits.allKeys mutableCopy];
    NSSortDescriptor *descr = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(compare:)];
    [keys sortUsingDescriptors:[NSArray arrayWithObject:descr]];
    _sortedKeys = keys;
}

- (void)sortByHitCount
{
    NSDictionary *distinctHits = [self.distinctHits copy];
    NSMutableArray *keys = [distinctHits.allKeys mutableCopy];
    [keys setArray:[distinctHits keysSortedByValueUsingComparator:
                    ^NSComparisonResult(id obj1, id obj2)
                    {
                        if ([obj1 count] > [obj2 count])
                        {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        if ([obj1 count] < [obj2 count])
                        {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }]];
    _sortedKeys = keys;
}

- (void)sortByHitKeyLength
{
    NSMutableDictionary *lengthDict = [self.distinctHits mutableCopy];
    for (NSString *key in lengthDict.allKeys)
    {
        [lengthDict setValue:[NSNumber numberWithInteger:key.length] forKey:key];
    }
    _sortedKeys = [lengthDict keysSortedByValueUsingSelector:@selector(compare:)];
}

- (void)sortByRefs
{
    _sortedKeys = _unsortedKeys;
}

- (NSArray *)sortedKeys
{
    if (_sortedKeys == nil)
    {
        _sortedKeys = _unsortedKeys;
    }
    return _sortedKeys;

}


@end
