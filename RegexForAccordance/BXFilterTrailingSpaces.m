//
//  BXFilterTrailingSpaces.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/22/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterTrailingSpaces.h"

@implementation BXFilterTrailingSpaces

- (id) init
{
    return [super initWithName:@"Remove Trailing Spaces" charactersToRemove:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)filter:(NSString *)text
{
    NSUInteger length = text.length;
    while (length > 0 && [self.characterSetToRemove characterIsMember:[text characterAtIndex:length - 1]])
    {
        length--;
    }
    return [text substringToIndex:length];
}

@end
