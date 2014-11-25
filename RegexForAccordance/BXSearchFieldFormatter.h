//
//  BXSearchFieldFormatter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 9/1/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTextLanguage.h"

@interface BXSearchFieldFormatter : NSFormatter
@property BOOL leftToRightOverride;
- (NSString *)stripLRO:(NSString *)string;
@end
