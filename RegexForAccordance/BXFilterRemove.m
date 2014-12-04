//
//  BXFilterRemove.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterRemove.h"

@implementation BXFilterRemove

- (id)initWithName:(NSString *)name charactersToRemove:(NSCharacterSet *)characterSet
{
    if (self = [super initWithName:name])
    {
        self.characterSetToRemove = characterSet;
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [[text componentsSeparatedByCharactersInSet:self.characterSetToRemove] componentsJoinedByString:@""];
}

@end
