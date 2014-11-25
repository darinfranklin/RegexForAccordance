//
//  BXStatistics.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/16/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXSearchResult.h"

@interface BXStatistics : NSObject
@property BOOL ignoreCase;
- (void)addSearchResult:(BXSearchResult *)result;
- (NSUInteger)countOfSearchResults;
- (NSUInteger)countOfHits;
- (NSUInteger)countOfHitKeys;
- (NSDictionary *)distinctHits;
- (void)reset;
- (NSArray *)searchResultHitsForHitKey:(NSString *)distinctHit;

- (void)sortByHitKey;
- (void)sortByHitCount;
- (void)sortByHitKeyLength;
- (void)sortByRefs;
- (NSArray *)sortedKeys;
@end
