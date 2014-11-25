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
    NSUInteger _index;
    NSArray *_lines;
}

- (id)initWithString:(NSString *)text delimiter:(NSString *)endOfLine
{
    if (self = [super init])
    {
        _lines = [text componentsSeparatedByString:endOfLine];
    }
    return self;
}

- (NSString *)peekAtNextLine
{
    if (_index < _lines.count)
    {
        return [_lines objectAtIndex:_index];
    }
    return nil;
}

- (NSString *)nextLine
{
    NSString *line = [self peekAtNextLine];
    if (line != nil)
    {
        _index++;
    }
    return line;
}

@end
