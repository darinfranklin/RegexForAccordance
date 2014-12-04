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
    if (self = [super initWithName:name])
    {
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

@end
