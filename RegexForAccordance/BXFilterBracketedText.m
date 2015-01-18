//
//  BXFilterBracketedText.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 1/17/15.
//  Copyright (c) 2015 Darin Franklin. All rights reserved.
//

#import "BXFilterBracketedText.h"

@implementation BXFilterBracketedText

- (id) init
{
    return [super initWithName:@"Remove Bracketed Text" searchPattern:@"\\[.*?\\]" replacePattern:@"" ignoreCase:YES];
}

@end
