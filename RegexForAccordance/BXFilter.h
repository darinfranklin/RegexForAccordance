//
//  BXFilter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXFilter : NSObject
@property NSString *name;
@property NSString *languageScriptTag;
- (NSString *)filter:(NSString *)text;
- (id)initWithName:(NSString *)name;
@end
