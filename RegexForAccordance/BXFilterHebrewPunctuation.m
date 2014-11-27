//
//  BXFilterHebrewPunctuation.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewPunctuation.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewPunctuation

- (id)init
{
    if (self = [super initWithName:@"Hebrew Remove Punctuation" charactersToRemove:[BXTextLanguage hebrewPunctuationCharacterSet]])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end
