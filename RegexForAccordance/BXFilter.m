//
//  BXFilter.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/26/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilter.h"

@interface BXFilter ()
@end

@implementation BXFilter

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
    }
    return self;
}


- (NSString *)filter:(NSString *)text
{
    return text;
}

@end