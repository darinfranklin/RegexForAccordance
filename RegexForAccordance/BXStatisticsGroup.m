//
//  BXStatisticsGroup.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXStatisticsGroup.h"

@implementation BXStatisticsGroup

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
        self.statistics = [[BXStatistics alloc] init];
        self.cumulativeRowCount = 0;
    }
    return self;
}

@end
