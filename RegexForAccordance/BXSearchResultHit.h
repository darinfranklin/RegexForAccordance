//
//  BXSearchResultHit.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/27/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXSearchResult.h"

@interface BXSearchResultHit : NSObject
@property BXSearchResult *searchResult;
@property NSTextCheckingResult *hit;
- (id)initWithSearchResult:(BXSearchResult *)searchResult hit:(NSTextCheckingResult *)hit;
@end
