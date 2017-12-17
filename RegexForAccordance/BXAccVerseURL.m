//
//  BXAccVerseURL.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXAccVerseURL.h"
#import "BXSearchResult.h"
#import "BXVerseRefConsolidator.h"
#import "BXAccLink.h"
#import "BXSearchSettings.h"

@implementation BXAccVerseURL

- (NSURL *)urlForVerseRef:(NSString *)ref inText:(NSString *)text
{
    NSString *urlString = [NSString stringWithFormat:@"accord://read/%@?%@",
                           [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ?: @"",
                           [ref stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ?: @""];
    return [NSURL URLWithString:urlString];
}

- (NSArray *)linksForSearchResults:(NSArray *)searchResults textName:(NSString *)textName
{
    return [self linksForSearchResults:searchResults textName:textName searchScope:SearchScopeVerse];
}

- (NSArray *)linksForSearchResults:(NSArray *)searchResults textName:(NSString *)textName searchScope:(SearchScopeOptions)searchScope
{
    NSMutableArray *refs = [[NSMutableArray alloc] initWithCapacity:searchResults.count];
    for (BXSearchResult *searchResult in searchResults)
    {
        if (searchResult.verse.ref != nil)
        {
            [refs addObject:searchResult.verse.ref];
        }
    }
    BXVerseRefConsolidator *consolidator = [[BXVerseRefConsolidator alloc] initWithVerseRefs:refs];
    consolidator.searchScope = searchScope;
    NSMutableArray *links = [[NSMutableArray alloc] init];
    NSString *refString;
    BXVerseRef *first = [consolidator currentVerseRef];
    refString = [consolidator buildRefString];
    BXVerseRef *last = [consolidator lastUsedVerseRef];
    while (refString != nil)
    {
        NSURL *url = [self urlForVerseRef:refString inText:textName];
        BXAccLink *link = [[BXAccLink alloc] initWithURL:url firstVerseRef:first lastVerseRef:last];
        [links addObject:link];
        first = [consolidator currentVerseRef];
        refString = [consolidator buildRefString];
        last = [consolidator lastUsedVerseRef];
    };
    return links;
}

@end

