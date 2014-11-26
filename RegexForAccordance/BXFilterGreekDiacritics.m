//
//  BXFilterGreekDiacritics.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/20/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterGreekDiacritics.h"
#import "BXTextLanguage.h"

@implementation BXFilterGreekDiacritics

- (id)init
{
    if (self = [super initWithName:@"Greek Remove Diacritics"
                 languageScriptTag:@SCRIPT_TAG_GREEK
                charactersToRemove:[BXTextLanguage greekDiacriticsCharacterSet]])
    {
    }
    return self;
}

@end
