//
//  BXFilterSpaces.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterSpaces.h"

@implementation BXFilterSpaces

- (id) init
{
    return [super initWithName:@"Remove Spaces" charactersToRemove:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

@end
