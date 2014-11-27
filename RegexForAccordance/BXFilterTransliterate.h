//
//  BXFilterTransliterate.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXFilter.h"

@interface BXFilterTransliterate : BXFilter
@property NSDictionary *map;
- (id)initWithName:(NSString *)name searchPattern:(NSString *)searchPattern replacePattern:(NSString *)replacePattern;
- (id)initWithName:(NSString *)name searchReplaceMap:(NSDictionary *)map;
@end
