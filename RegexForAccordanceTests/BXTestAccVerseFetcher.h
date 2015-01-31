//
//  BXTestAccVerseFetcher.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 1/31/15.
//  Copyright (c) 2015 Darin Franklin. All rights reserved.
//

#import "BXAccVerseFetcher.h"

@interface BXTestAccVerseFetcher : BXAccVerseFetcher
@property NSString *lines;
- initWithLines:(NSString *)lines;
@end
