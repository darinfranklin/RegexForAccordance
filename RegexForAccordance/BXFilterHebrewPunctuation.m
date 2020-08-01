//
//  BXFilterHebrewPunctuation.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewPunctuation.h"
#import "BXTextLanguage.h"
#import "BXFilterReplace.h"

@implementation BXFilterHebrewPunctuation
BXFilterReplace *_filterMaqaf;

- (id)init
{
    if (self = [super initWithName:@"Hebrew Remove Punctuation" charactersToRemove:[BXTextLanguage hebrewPunctuationCharacterSet]])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
        _filterMaqaf = [[BXFilterReplace alloc] initWithName:@"Maqaf to Space" searchPattern:@"\u05BE" replacePattern:@" " ignoreCase:false];
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [super filter:[_filterMaqaf filter:text]];
}

@end
