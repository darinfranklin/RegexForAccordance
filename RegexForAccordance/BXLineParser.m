//
//  BXLineParser.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXLineParser.h"

@interface BXLineParser()
@property NSRegularExpression *verseRefRegex;
@end

@implementation BXLineParser

- (id) init
{
    if ( self = [super init] )
    {
        // Three Accordance preferences affect the verse reference format
        //   Appearance: Use European verse notation; Use SBL standard abbreviations; Use decimal (.) verse divider
        //   Decimal and Euro are mutually exclusive.
        // SBL: 1 Cor 2:3; Gen 1:23; Jude 9; 3 John 1
        // Non-SBL: 1Cor. 2:3; Gen. 1:23; Jude 9; 3John 1
        // SBL Euro: 1 Cor 2,3; Gen 1,23; Jude 9; 3 John 1
        // Non-SBL Euro: 1Cor. 2,3; Gen. 1,23; Jude 9; 3John 1
        // SBL Decimal: 1 Cor 2.3; Gen 1.23; Jude 9; 3 John 1
        // Non-SBL Decimal: 1Cor. 2.3; Gen. 1.23; Jude 9; 3 John 1
        NSString *verseRefPattern = @"^(.*?)\\s(?:(\\d+)[:,.])?(\\d+)";
        NSError *error;
        _verseRefRegex = [NSRegularExpression regularExpressionWithPattern:verseRefPattern
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    }
    return self;
    
}

- (BOOL)lineHasVerseReference:(NSString *)line
{
    if (line == nil)
    {
        return NO;
    }
    NSArray *textCheckingResults = [_verseRefRegex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
    return textCheckingResults.count > 0;
}

- (BOOL)string:(NSString *)string contains:(NSString *)substring
{
    return [string rangeOfString:substring].location != NSNotFound;
}

- (BOOL)useEuropeanNotation:(NSString *)verseRefStringValue
{
    if ([self string:verseRefStringValue contains:@","])
    {
        return YES;
    }
    else if ([self string:verseRefStringValue contains:@":"])
    {
        return NO;
    }
    else
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"UseEuropeanNotation"];
    }
}

- (BXVerse *)verseForLine:(NSString *)line
{
    NSArray *textCheckingResults = [_verseRefRegex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
    BXVerse *verse = [[BXVerse alloc] init];
    if (textCheckingResults.count > 0)
    {
        NSTextCheckingResult *result = [textCheckingResults objectAtIndex:0];
        if (line.length > result.range.length + 1)
        {
            verse.text = [line substringFromIndex:result.range.length + 1];
        }
        NSString *book = [line substringWithRange:[result rangeAtIndex:1]];
        NSRange chapterRange = [result rangeAtIndex:2];
        NSRange verseRange = [result rangeAtIndex:3];
        NSInteger chapterNumber = 0;
        NSInteger verseNumber = 0;
        NSString *verseRefStringValue;
        if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), chapterRange))
        {
            chapterNumber = [[line substringWithRange:chapterRange] integerValue];
        }
        verseNumber = [[line substringWithRange:verseRange] integerValue];
        verseRefStringValue = [line substringWithRange:result.range];
        BOOL useEuropeanNotation = [self useEuropeanNotation:verseRefStringValue];
        verse.ref = [[BXVerseRef alloc] initWithBook:book chapter:chapterNumber verse:verseNumber europeanFormat:useEuropeanNotation];
    }
    else
    {
        verse.ref = nil;
        verse.text = line;
    }
    return verse;
}

@end
