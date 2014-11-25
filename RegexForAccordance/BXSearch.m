//
//  BXSearch.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearch.h"
#import "BXSearchResult.h"
#import "BXFilter.h"
#import "BXTextLanguage.h"
#import "BXFilterHebrewDirectionalMarks.h"
#import "BXFilterHebrewNormalizeToCompositeCharacters.h"
#import "BXFilterGreekNormalizeToCompositeCharacters.h"

@interface BXSearch()
@property NSRegularExpression *searchRegex;
@property NSRegularExpression *xformRegex;
@property NSMutableArray *searchResults; // array of BXSearchResult
@property id<BXFilter> greekCompositeFilter;
@property id<BXFilter> hebrewCompositeFilter;
@property id<BXFilter> hebrewDirectionalFilter;
@property BOOL cancelled;
@end

@implementation BXSearch

- (id)init
{
    if (self = [super init])
    {
        _searchResults = [[NSMutableArray alloc] init];
        self.filters = [[NSMutableArray alloc] init];
        self.statisticsGroups = [[BXStatisticsGroups alloc] init];
        self.hebrewCompositeFilter = [[BXFilterHebrewNormalizeToCompositeCharacters alloc] init];
        self.greekCompositeFilter = [[BXFilterGreekNormalizeToCompositeCharacters alloc] init];
        self.hebrewDirectionalFilter = [[BXFilterHebrewDirectionalMarks alloc] init];
        [self reset];
    }
    return self;
}

- (id)initWithFetcher:(BXAccVerseFetcher *)fetcher
{
    if (self = [self init])
    {
        self.fetcher = fetcher;
    }
    return self;
}

- (void)reset
{
    [_searchResults removeAllObjects];
    _error = nil;
    [self.fetcher reset];
    [self.statisticsGroups reset];
    [self.filters removeAllObjects];
    if ([self useCompositeCharacters])
    {
        [self addFilter:self.greekCompositeFilter];
        [self addFilter:self.hebrewCompositeFilter];
    }
    [self addFilter:self.hebrewDirectionalFilter];
    self.cancelled = NO;
    self.languageScriptTag = nil;
}

- (BOOL)useCompositeCharacters
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UseCompositeCharacters"];
}

- (NSError *)errorForInvalidPattern:(NSString *)pattern errorCode:(NSInteger)code
{
    NSDictionary *userInfo
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"The value “%@” is invalid.", pattern], NSLocalizedDescriptionKey,
       @"Enter a valid regular expression.", NSLocalizedRecoverySuggestionErrorKey,
       nil];
    NSError *error = [NSError errorWithDomain:@"BXErrorDomain" code:code userInfo:userInfo];
    return error;
}

- (BOOL)prepareSearch:(NSError **)aError
{
    if (![self hasValidSearchPattern])
    {
        if (aError != NULL)
        {
            *aError = [self errorForInvalidPattern:self.pattern errorCode:-2];
        }
        return NO;
    }
    if ([self useCompositeCharacters])
    {
        self.pattern = [self.greekCompositeFilter filter:self.pattern];
        self.pattern = [self.hebrewCompositeFilter filter:self.pattern];
    }
    NSRegularExpressionOptions options = NSRegularExpressionUseUnicodeWordBoundaries;
    if (self.ignoreCase)
    {
        options |=  NSRegularExpressionCaseInsensitive;
    }
    self.statisticsGroups.ignoreCase = self.ignoreCase;
    NSError *error;
    self.searchRegex = [[NSRegularExpression alloc] initWithPattern:self.pattern options:options error:&error];
    if (error != nil)
    {
        LogError(@"NSRegularExpression error: %@ %@ %@ %@",
                 error.localizedFailureReason,       // The value “[[[” is invalid.
                 error.localizedDescription,         // The value “[[[” is invalid.
                 error.localizedRecoveryOptions,     // null
                 error.localizedRecoverySuggestion); // Please provide a valid value.
        if (aError != NULL)
        {
            *aError = [self errorForInvalidPattern:self.pattern errorCode:error.code];
        }
        return NO;
    }
    if (self.languageScriptTag != nil)
    {
        for (int i = (int) self.filters.count - 1; i >= 0; i--)
        {
            id<BXFilter>filter = [self.filters objectAtIndex:i];
            if (filter.languageScriptTag != nil
                && ![filter.languageScriptTag isEqualToString:self.languageScriptTag])
            {
                [self removeFilter:filter];
            }
        }
#ifdef DEBUG
        for (id<BXFilter>filter in self.filters)
        {
            LogDebug(@"Active filter: %@", filter.name);
        }
#endif
    }
    else if (self.fetcher.error != nil)
    {
        if (aError != NULL)
        {
            *aError = self.fetcher.error;
        }
        return NO;
    }
    return YES;
}


- (void)addFilter:(id<BXFilter>)filter
{
    LogDebug(@"Add filter: %@", filter.name);
    [self.filters addObject:filter];
}

- (void)removeFilter:(id<BXFilter>)filter
{
    LogDebug(@"Remove filter: %@", filter.name);
    [self.filters removeObject:filter];
}

- (NSString *)applyFilters:(NSString *)text
{
    for (id<BXFilter>filter in self.filters)
    {
        text = [filter filter:text];
    }
    return text;
}

- (BOOL)hasValidSearchPattern
{
    return self.pattern.length > 0;
}

- (BXSearchResult *)nextSearchResult
{
    BXSearchResult *result = nil;
    BXVerse *verse = nil;
    do
    {
        @autoreleasepool
        {
            while (!self.cancelled && nil != (verse = [self.fetcher nextVerse]))
            {
                verse.text = [self applyFilters:verse.text];
                NSString *searchLine = verse.text;
                if (self.includeReference)
                {
                    searchLine = verse.referenceAndText;
                }
                NSRange rangeOfSearch = NSMakeRange(0, searchLine.length);
                NSArray *hits = [self.searchRegex matchesInString:searchLine options:0 range:rangeOfSearch];
                if (hits.count > 0)
                {
                    result = [[BXSearchResult alloc] init];
                    result.verse = verse;
                    result.hits = hits;
                    result.rangeOfSearch = rangeOfSearch;
                    [_searchResults addObject:result];
                    [self.statisticsGroups addSearchResult:result];
                    break; // goto GC with result != nil
                }
                if (self.fetcher.hasGarbage)
                {
                    break; // goto GC
                }
            }
        } // GC: Exit the autorelease pool so that memory from previous iterations is released.
        self.fetcher.hasGarbage = NO;
        // Now keep going if not cancelled, there are more verses, and no result yet
    } while (!self.cancelled && verse != nil && result == nil);
    
    if (verse == nil)
    {
        if (self.fetcher.error)
        {
            _error = self.fetcher.error;
        }
    }
    return result;
}

- (void)cancelSearch
{
    self.cancelled = YES;
}

@end
