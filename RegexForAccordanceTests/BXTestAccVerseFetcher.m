//
//  BXTestAccVerseFetcher.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 1/31/15.
//  Copyright (c) 2015 Darin Franklin. All rights reserved.
//

#import "BXTestAccVerseFetcher.h"

@implementation BXTestAccVerseFetcher

- initWithLines:(NSString *)lines
{
    if (self = [super init])
    {
        self.lines = lines;
    }
    return self;
}

- (NSString *)fetchVersesFromText:(NSString *)textName withVerseRange:(NSString *)verseRefs
{
    return self.lines;
}

@end
