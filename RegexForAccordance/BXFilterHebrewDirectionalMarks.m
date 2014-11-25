//
//  BXFilterHebrewDirectionalMarks.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/18/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewDirectionalMarks.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewDirectionalMarks

-(id)init
{
    if (self = [super initWithName:@"Hebrew Remove Directional Marks"
                     searchPattern:@"[" LRM RLM @"]"
                    replacePattern:@""
                        ignoreCase:YES])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end
