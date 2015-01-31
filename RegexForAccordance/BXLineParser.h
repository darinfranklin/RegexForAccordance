//
//  BXLineParser.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerse.h"

/*! Parses a line of text into a BXVerse, which contains a BXVerseRef and the text */
@interface BXLineParser : NSObject
- (BXVerse *)verseForLine:(NSString *)line;
- (bool)lineHasVerseReference:(NSString *)line;
@end
