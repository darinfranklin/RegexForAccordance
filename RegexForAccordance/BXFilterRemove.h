//
//  BXFilterRemove.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXFilter.h"

@interface BXFilterRemove : BXFilter
@property NSCharacterSet *characterSetToRemove;
- (id)initWithName:(NSString *)name charactersToRemove:(NSCharacterSet *)characterSet;
@end
