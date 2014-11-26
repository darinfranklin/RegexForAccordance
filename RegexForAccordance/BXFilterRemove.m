//
//  BXFilterRemove.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterRemove.h"

@implementation BXFilterRemove

- (id)initWithName:(NSString *)name languageScriptTag:(NSString *)languageScriptTag charactersToRemove:(NSCharacterSet *)characterSet
{
    if (self = [super init])
    {
        self.languageScriptTag = languageScriptTag;
        self.name = name;
        self.characterSetToRemove = characterSet;
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [[text componentsSeparatedByCharactersInSet:self.characterSetToRemove] componentsJoinedByString:@""];
}

- (BOOL)isEqual:(id)other
{
    if (other == nil)
    {
        return NO;
    }
    if (other == self)
    {
        return YES;
    }
    if (![other isKindOfClass:[self class]])
    {
        return NO;
    }
    return [self isEqualToReplaceFilter:other];
}

- (BOOL)isEqualToReplaceFilter:(BXFilterRemove *)other
{
    if (![self.name isEqualToString:[other name]])
    {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = 0;
    hash += self.name.hash;
    return hash;
}

@end
