//
//  BXFilterHebrewNormalizeToCompositeCharacters.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewNormalizeToCompositeCharacters.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewNormalizeToCompositeCharacters

-(id)init
{
    if (self = [super init])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
        self.name = @"Hebrew Decompose Characters";
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [text decomposedStringWithCanonicalMapping];
}

@end


// [\uFB1D-\uFB29] none (hiriq yod, wide letters)
// [\uFB2A-\uFB2B] sin-shin dots (preserve; do not change)
// [\uFB2C-\uFB2D] sin-shin with dagesh (keep sin and shin, separate dagesh)
// [\uFB2E-\uFB4B] letters with dagesh, mapiq, holam, etc.
// [\uFB4C-\uFB4F] none (rafe, alef-lamed ligature)
