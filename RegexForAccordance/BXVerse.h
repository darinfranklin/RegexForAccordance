//
//  BXVerse.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/2/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerseRef.h"

@interface BXVerse : NSObject

@property NSString *text;
@property BXVerseRef *ref;
@property NSUInteger lineNumber;
- (NSString *)searchText:(BOOL)includeReference;
- (NSString *)referenceAndText;
@end
