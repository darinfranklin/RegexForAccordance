//
//  BXTestSearchResult.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXTestSearchResult.h"

@implementation BXTestSearchResult

- (id)initWithText:(NSString *)text book:(NSString *)book chapter:(NSUInteger)chapter verse:(NSUInteger)verse
{
    if (self = [super init])
    {
        self.verse = [[BXVerse alloc] init];
        self.verse.text = text;
        self.verse.ref = [[BXVerseRef alloc] initWithBook:book chapter:chapter verse:verse];
        NSRange hitRange = NSMakeRange(0, text.length);
        NSTextCheckingResult *hit = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&hitRange count:1 regularExpression:nil];
        self.hits = [NSArray arrayWithObject:hit];
    }
    return self;
}

- (id)initWithText:(NSString *)text book:(NSString *)book
{
    return [self initWithText:text book:book chapter:1 verse:1];
}

@end
