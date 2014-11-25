//
//  BXSearchResult.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerse.h"

@interface BXSearchResult : NSObject
@property BXVerse *verse;
/* NSArray of NSTextCheckingResult */
@property NSArray *hits;
/* NSRange in the NSTextView for the formatted result */
@property NSRange rangeOfDisplayLine;
/* NSRange within the string given by rangeOfDisplayLine, either with or without reference string. */
@property NSRange rangeOfSearch;
- (NSArray *)hitsEqualToString:(NSString *)str;
- (NSString *)stringForHit:(NSTextCheckingResult *)hit;

@end
