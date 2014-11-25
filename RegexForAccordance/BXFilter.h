//
//  BXFilter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BXFilter <NSObject>
- (NSString *)name;
- (NSString *)filter:(NSString *)text;
- (NSString *)languageScriptTag;
@end
