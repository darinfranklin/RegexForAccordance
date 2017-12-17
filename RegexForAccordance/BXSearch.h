//
//  BXSearch.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXSearchResult.h"
#import "BXAccVerseFetcher.h"
#import "BXFilter.h"
#import "BXStatisticsGroups.h"
#import "BXTextLanguage.h"
#import "BXSearchSettings.h"

@interface BXSearch : NSObject
@property BXAccVerseFetcher *fetcher;
@property NSString *pattern;
@property BXStatisticsGroups *statisticsGroups;
@property (readonly) NSError *error;
@property BOOL ignoreCase;
@property BOOL includeReference;
@property NSString *languageScriptTag;
@property SearchScopeOptions searchScope;

- (id)initWithFetcher:(BXAccVerseFetcher *)fetcher;
- (BOOL)prepareSearch:(NSError **)error;
- (void)reset;
- (BXSearchResult *)nextSearchResult;
- (void)cancelSearch;
- (BOOL)hasValidSearchPattern;
- (void)addFilter:(BXFilter *)filter;
- (void)removeFilter:(BXFilter *)filter;
- (NSArray *)filters;
- (NSArray *)searchResults;
@end
