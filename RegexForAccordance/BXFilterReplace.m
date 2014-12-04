//
//  BXFilterReplace.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterReplace.h"

@implementation BXFilterReplace
{
    NSRegularExpression *_regex;
}

-(id)initWithName:(NSString *)name searchPattern:(NSString *)searchPattern replacePattern:(NSString *)replacePattern ignoreCase:(BOOL)ignoreCase
{
    if (self = [super initWithName:name])
    {
        [self setSearchPattern:searchPattern];
        [self setReplacePattern:replacePattern];
        [self setIgnoreCase:ignoreCase];
    }
    return self;
}

- (NSRegularExpression *)regex
{
    if (_regex == nil)
    {
        NSError *error;
        NSRegularExpressionOptions options = NSRegularExpressionUseUnicodeWordBoundaries;
        if (self.ignoreCase)
        {
            options |=  NSRegularExpressionCaseInsensitive;
        }
        _regex = [[NSRegularExpression alloc] initWithPattern:_searchPattern options:options error:&error];
        if (error)
        {
            LogError(@"%@ %@ %@ %@", [error localizedFailureReason], [error localizedDescription],
                     [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        }
    }
    return _regex;
}

- (NSString *)filter:(NSString *)text
{
    NSString *string = [self.regex stringByReplacingMatchesInString:text
                                                            options:0
                                                              range:NSMakeRange(0, text.length)
                                                       withTemplate:_replacePattern];
    return string;
}

@end
