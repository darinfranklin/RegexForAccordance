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
    return [super initWithName:@"Remove Trailing Spaces" searchPattern:@"\\s+$" replacePattern:@"" ignoreCase:YES];
}

@end
