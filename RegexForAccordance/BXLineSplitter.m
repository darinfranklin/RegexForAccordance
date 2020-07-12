//
//  BXLineSplitter.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/2/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXLineSplitter.h"

@implementation BXLineSplitter
{
    NSArray *_lines;
}

- (id)initWithString:(NSString *)text delimiter:(NSString *)endOfLine
{
    if (self = [super init])
    {
        _lines = [text componentsSeparatedByString:endOfLine];
        LogDebug(@"Line count: %lu", _lines.count);
    }
    return self;
}

- (NSString *)peekAtNextLine
{
    if (_lineNumber < _lines.count)
    {
        return [_lines objectAtIndex:_lineNumber];
    }
    return nil;
}

- (NSString *)nextLine
{
    NSString *line = [self peekAtNextLine];
    if (line != nil)
    {
        _lineNumber++;
    }
    return line;
}

@end
