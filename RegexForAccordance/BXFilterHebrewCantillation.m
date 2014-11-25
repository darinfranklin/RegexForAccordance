//
//  BXFilterHebrewCantillation.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewCantillation.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewCantillation

-(id)init
{
    if (self = [super initWithName:@"Hebrew Remove Cantillation"
                     searchPattern:@"[" HEB_CANTIL @"]"
                    replacePattern:@""
                        ignoreCase:YES])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end
