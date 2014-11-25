//
//  BXSearchResultHit.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/27/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchResultHit.h"

@implementation BXSearchResultHit

- (id)initWithSearchResult:(BXSearchResult *)searchResult hit:(NSTextCheckingResult *)hit
{
    if (self = [super init])
    {
        self.searchResult = searchResult;
        self.hit = hit;
    }
    return self;
}

@end