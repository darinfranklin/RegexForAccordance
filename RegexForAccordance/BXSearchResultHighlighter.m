//
//  BXSearchResultHighlighter.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 10/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchResultHighlighter.h"

@interface BXSearchResultHighlighter ()
@property BXStatisticsDatasource *statisticsDatasource;
@property NSUInteger highlightedSearchResultHitIndex;
@property NSUInteger lastClickedRow;
@property NSTextView *searchResultsTextView;
@property BXSearchSettings *searchSettings;
@property BXSearchResultFormatter *formatter;
@end

@implementation BXSearchResultHighlighter

- (id)initWithStatisticsDatasource:(BXStatisticsDatasource *)statisticsDatasource
             searchResultsTextView:(NSTextView *)searchResultsTextView
                    searchSettings:(BXSearchSettings *)searchSettings
                         formatter:(BXSearchResultFormatter *)formatter
{
    if (self = [super init])
    {
        self.statisticsDatasource = statisticsDatasource;
        self.searchResultsTextView = searchResultsTextView;
        self.searchSettings = searchSettings;
        self.formatter = formatter;
        self.lastClickedRow = -1;
    }
    return self;
}

- (void)reset
{
    self.lastClickedRow = -1;
}

- (void)showNextFindIndicatorForRow:(NSInteger)row increment:(NSInteger)increment
{
    if (row == -1)
    {
        return;
    }
    NSString *key = [self.statisticsDatasource keyForRow:row];
    if (key == nil)
    {
        return;
    }
    NSArray *searchResultHits = [self.statisticsDatasource searchResultHitsForRow:row];
    if (self.lastClickedRow == row)
    {
        self.highlightedSearchResultHitIndex
        = [self.statisticsDatasource incrementIndex:self.highlightedSearchResultHitIndex
                                           byAmount:increment
                                           forCount:searchResultHits.count];
    }
    else
    {
        self.highlightedSearchResultHitIndex = 0;
    }
    BXSearchResultHit *searchResultHit = [searchResultHits objectAtIndex:self.highlightedSearchResultHitIndex];
    BXSearchResult *searchResult = searchResultHit.searchResult;
    self.lastClickedRow = row;
    [self scrollToSearchResult:searchResult];
    NSRange highlightRange = [self rangeToHighlightForHit:searchResultHit.hit inSearchResult:searchResult];
    [self.searchResultsTextView showFindIndicatorForRange:highlightRange];
}

- (NSRange)rangeToHighlightForHit:(NSTextCheckingResult *)hit inSearchResult:(BXSearchResult *)searchResult
{
    NSString *searchText = [searchResult.verse searchText:self.searchSettings.includeReference];
    NSRange highlightRange = hit.range;
    highlightRange = [searchText rangeOfComposedCharacterSequencesForRange:highlightRange];
    highlightRange = [self.formatter hitRange:highlightRange inFormattedSearchResult:searchResult];
    return NSMakeRange(searchResult.rangeOfDisplayLine.location + highlightRange.location,
                       highlightRange.length);
}

- (void)scrollToSearchResult:(BXSearchResult *)searchResult
{
    [self.searchResultsTextView scrollRangeToVisible:searchResult.rangeOfDisplayLine];
}

@end
