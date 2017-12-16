//
//  BXFilterPilcrows.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 10/18/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterPilcrows.h"

@implementation BXFilterPilcrows

- (id) init
{
    return [super initWithName:@"Remove Pilcrows" searchPattern:@"¶ ?" replacePattern:@"" ignoreCase:YES];
}

@end
