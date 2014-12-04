//
//  BXFilterTransliterate.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterTransliterate.h"

@implementation BXFilterTransliterate
{
}

- (id)initWithName:(NSString *)name searchPattern:(NSString *)searchPattern replacePattern:(NSString *)replacePattern
{
    if (self = [super initWithName:name])
    {
        self.map = [self mapFromSearchPattern:searchPattern replacePattern:replacePattern];
    }
    return self;
}

- (id)initWithName:(NSString *)name searchReplaceMap:(NSDictionary *)map
{
    if (self = [super initWithName:name])
    {
        self.map = map;
    }
    return self;
}

- (NSDictionary *)mapFromSearchPattern:(NSString *)searchPattern replacePattern:(NSString *)replacePattern
{
    NSMutableDictionary *theMap = [[NSMutableDictionary alloc] initWithCapacity:searchPattern.length];
    NSUInteger len = searchPattern.length;
    if (len > replacePattern.length)
    {
        len = replacePattern.length;
    }
    for (NSUInteger i = 0; i < len; i++)
    {
        NSString *key = [searchPattern substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [replacePattern substringWithRange:NSMakeRange(i, 1)];
        [theMap setValue:value forKey:key];
    }
    return theMap;
}

- (NSString *)filter:(NSString *)text
{
    NSMutableString *string = [text mutableCopy];
    for (NSUInteger i = 0; i < string.length; i++)
    {
        NSString *key = [string substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [[self map] objectForKey:key];
        if (value != nil)
        {
            [string replaceCharactersInRange:NSMakeRange(i, 1) withString:value];
            i += value.length - 1;
        }
    }
    return string;
}

@end
