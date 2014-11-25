//
//  BXVerseRangeParser.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXVerseRangeParser : NSObject

@property NSString *refRangeStart;
@property NSString *refRangeEnd;

- (void)parseVerseRefs:(NSString *)refs;

@end
