//
//  BXVerseRef.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXVerseRef.h"

/* Verse reference for a single verse: Gen 1:1 or Jude 1 */
@implementation BXVerseRef

- (id)initWithBook:(NSString *)book chapter:(NSInteger)chapter verse:(NSInteger)verse stringValue:(NSString *)stringValue
{
    if (self = [super init])
    {
        _book = book;
        _chapter = chapter;
        _verse = verse;
        _stringValue = stringValue;
    }
    return self;
}

- (id)initWithBook:(NSString *)book chapter:(NSInteger)chapter verse:(NSInteger)verse
{
    if (self = [self initWithBook:book chapter:chapter verse:verse stringValue:nil])
    {
        _stringValue = [self formatString];
    }
    return self;
}

- (NSString *)formatString
{
    if (_chapter != 0)
    {
        return [NSString stringWithFormat:@"%@ %ld:%ld", _book, _chapter, _verse];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %ld", _book, _verse];
    }
}

@end
