//
//  BXStatisticsGroup.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXStatistics.h"

@interface BXStatisticsGroup : NSObject
@property NSString *name;
@property BXStatistics *statistics;
@property NSUInteger cumulativeRowCount;
- (id)initWithName:(NSString *)name;
@end
