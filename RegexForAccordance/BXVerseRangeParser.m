//
//  BXVerseRangeParser.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXVerseRangeParser.h"
#import "BXLineParser.h"

/*! For parsing the Verse Range: Gen - Deut */
@implementation BXVerseRangeParser

- (void)parseVerseRefs:(NSString *)refs
{
    // A contiguous range requires multiple fetches if it contains more than 500 verses.
    // If the range has less than 500, then we do not have to know the endpoint
    // To get the endpoint, the contiguous range
    //   must not have comma or semicolon
    //   may have a hyphen
    //   may be a single book: Job
    //   may be part of a single book: Ps 1:3 - 150:4
    //   may be chapters in a book: [Ps 1-150]
    //   may be entire books: [Job - Ps]
    self.refRangeStart = refs;
    NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    if (NSEqualRanges(notFoundRange, [refs rangeOfString:@","])
        && NSEqualRanges(notFoundRange, [refs rangeOfString:@";"]))
    {
        NSRange range = [refs rangeOfString:@"-"];
        if (!NSEqualRanges(notFoundRange, range))
        {
            self.refRangeStart = [[refs substringToIndex:range.location]
                                  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (range.location + 1 < refs.length)
            {
                self.refRangeEnd = [[refs substringFromIndex:range.location + 1]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                // Ps 1-150 == Ps 1 - Ps 150;  Jude 2 - 7 == Jude 2 - Jude 7
                if (NSEqualRanges(notFoundRange, [self.refRangeStart rangeOfString:@":"])
                    && !NSEqualRanges(notFoundRange, [self.refRangeEnd rangeOfString:@"^[0-9]+$" options:NSRegularExpressionSearch]))
                {
                    BXVerseRef *startVerseRef = [[[[BXLineParser alloc] init] verseForLine:self.refRangeStart] ref];
                    BXVerseRef *endVerseRef = [[BXVerseRef alloc] initWithBook:startVerseRef.book
                                                                       chapter:0
                                                                         verse:[self.refRangeEnd integerValue]];

                    self.refRangeEnd = endVerseRef.stringValue;
                }
            }
        }
        else if (NSEqualRanges(notFoundRange, [refs rangeOfString:@":"]))
        {
            // it's a single book name: Job
            self.refRangeEnd = refs;
        }
    }
}

@end
