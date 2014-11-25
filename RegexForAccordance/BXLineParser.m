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
        NSString *verseRefPattern = @"^((?:[1-9] )?[a-z]+) (\\d+)(?::(\\d+))?"; // 1 Cor 2:3; Gen 1:23; Jude 9
        NSError *error;
        _verseRefRegex = [NSRegularExpression regularExpressionWithPattern:verseRefPattern
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    }
    return self;
    
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
        NSString *book = nil;
        NSInteger chapterNumber = 0;
        NSInteger verseNumber = 0;
        book = [line substringWithRange:[result rangeAtIndex:1]];
        NSRange verseRange = [result rangeAtIndex:3];
        NSString *verseRefStringValue;
        if (NSEqualRanges(NSMakeRange(NSNotFound, 0), verseRange))
        {
            // 3 John 9
            verseNumber = [[line substringWithRange:[result rangeAtIndex:2]] integerValue];
            verseRefStringValue = [line substringToIndex:NSMaxRange([result rangeAtIndex:2])];
        }
        else
        {
            // John 3:9
            chapterNumber = [[line substringWithRange:[result rangeAtIndex:2]] integerValue];
            verseNumber = [[line substringWithRange:[result rangeAtIndex:3]] integerValue];
            verseRefStringValue = [line substringToIndex:NSMaxRange([result rangeAtIndex:3])];
        }
        verse.ref = [[BXVerseRef alloc] initWithBook:book chapter:chapterNumber verse:verseNumber stringValue:verseRefStringValue];
    }
    else
    {
        verse.ref = nil;
        verse.text = line;
    }
    return verse;
}

@end
