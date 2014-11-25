//
//  BXLineSplitter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/2/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXLineSplitter : NSObject

- (id)initWithString:(NSString *)text delimiter:(NSString *)lineDelimiter;
- (NSString *)peekAtNextLine;
- (NSString *)nextLine;

@end
