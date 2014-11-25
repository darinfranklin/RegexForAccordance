//
//  BXAccLink.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/31/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXAccLink.h"

@implementation BXAccLink

- (id)initWithURL:(NSURL *)url firstVerseRef:(BXVerseRef *)first lastVerseRef:(BXVerseRef *)last
{
    if (self = [super init])
    {
        self.url = url;
        self.firstVerseRef = first;
        self.lastVerseRef = last;
    }
    return self;
}

@end
