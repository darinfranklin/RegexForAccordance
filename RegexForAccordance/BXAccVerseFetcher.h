//
//  BXAccVerseFetcher.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerse.h"

typedef NS_OPTIONS(NSInteger, BXErrorCodes) {
    BXFetchLimitError = 500
};

@interface BXAccVerseFetcher : NSObject
@property NSString *textName;
@property NSString *verseRange;
@property (readonly) NSError *error;
@property BXVerse *firstVerse;
@property BXVerse *lastVerse;
@property NSInteger searchScope;
@property BOOL hasGarbage;

- (BXVerse *)nextVerse;
- (void)reset;
- (NSString *)peekAtNextLine;
- (NSArray *)availableTexts;
@end
