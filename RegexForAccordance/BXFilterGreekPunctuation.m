//
//  BXFilterGreekPunctuation.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/20/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterGreekPunctuation.h"
#import "BXTextLanguage.h"

@implementation BXFilterGreekPunctuation

- (id)init
{
    if (self = [super initWithName:@"Greek Remove Punctuation"
                 languageScriptTag:@SCRIPT_TAG_GREEK
                     charactersToRemove:[BXTextLanguage greekPunctuationCharacterSet]])
    {
    }
    return self;
}

@end
