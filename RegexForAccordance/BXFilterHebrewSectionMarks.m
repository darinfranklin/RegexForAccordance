//
//  BXFilterHebrewSectionMarks.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 7/18/20.
//  Copyright © 2020 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewSectionMarks.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewSectionMarks

- (id)init
{
    if (self = [super initWithName:@"Hebrew Remove Section Marks"
                     searchPattern:@" \\b[ןספ]\\b"
                    replacePattern:@""
                        ignoreCase:false])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end
