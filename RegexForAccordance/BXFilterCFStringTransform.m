//
//  BXFilterCFStringTransform.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterCFStringTransform.h"

@implementation BXFilterCFStringTransform

- (id)initWithName:(NSString *)name transform:(CFStringRef)transform;
{
    if (self = [super init])
    {
        self.name = name;
        self.transform = transform;
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    NSMutableString *string = [text mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, _transform, NO);
    return string;
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
    if (!other || ![other isKindOfClass:[self class]])
    {
        return NO;
    }
    return [self isEqualToCFStringTransformFilter:other];
}

- (BOOL)isEqualToCFStringTransformFilter:(BXFilterCFStringTransform *)other
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
