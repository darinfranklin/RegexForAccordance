//
//  BXSearchResult.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchResult.h"

@implementation BXSearchResult

- (NSArray *)hitsEqualToString:(NSString *)str
{
    NSMutableArray *hits = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *hit in self.hits)
    {
        if ([[self.verse.text substringWithRange:hit.range] isEqualToString:str])
        {
            [hits addObject:hit];
        }
    }
    return hits;
}

- (BOOL)includesReference
{
    return self.rangeOfSearch.length > self.verse.text.length;
}

- (NSString *)searchString
{
    if ([self includesReference])
    {
        // reconstruct search string
        NSString *line = self.verse.referenceAndText;
        return line;
    }
    else
    {
        return self.verse.text;
    }
}

- (NSString *)stringForHit:(NSTextCheckingResult *)hit
{
    return [[self searchString] substringWithRange:hit.range];
}

@end
