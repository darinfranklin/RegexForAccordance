//
//  BXVerse.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/2/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXVerse.h"

@implementation BXVerse

- (NSString *)textIncludingReference:(BOOL)includeReference
{
    if (includeReference)
    {
        return [self referenceAndText];
    }
    else
    {
        return [self text];
    }
}

- (NSString *)referenceAndText
{
    return [[self.ref.stringValue stringByAppendingString:@" "] stringByAppendingString:self.text];
}

@end
