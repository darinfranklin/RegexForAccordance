//
//  BXFilterRemove.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXFilter.h"

@interface BXFilterRemove : NSObject<BXFilter>
@property NSString *name;
@property NSString *languageScriptTag;
@property NSCharacterSet *characterSetToRemove;
- (NSString *)filter:(NSString *)text;
- (id)initWithName:(NSString *)name languageScriptTag:(NSString *)languageScriptTag charactersToRemove:(NSCharacterSet *)characterSet;
@end
