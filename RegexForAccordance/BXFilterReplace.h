//
//  BXFilterReplace.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXFilter.h"

@interface BXFilterReplace : NSObject <BXFilter>
@property NSString *name;
@property NSString *languageScriptTag;
@property NSString *searchPattern;
@property NSString *replacePattern;
@property BOOL ignoreCase;
- (NSString *)filter:(NSString *)text;
-(id)initWithName:(NSString *)name searchPattern:(NSString *)searchPattern replacePattern:(NSString *)replacePattern ignoreCase:(BOOL)ignoreCase;
@end
