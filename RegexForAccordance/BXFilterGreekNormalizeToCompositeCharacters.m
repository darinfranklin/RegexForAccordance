//
//  BXFilterGreekNormalizeToCompositeCharacters.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/20/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterGreekNormalizeToCompositeCharacters.h"
#import "BXTextLanguage.h"

@implementation BXFilterGreekNormalizeToCompositeCharacters

-(id)init
{
    if (self = [super init])
    {
        self.languageScriptTag = @SCRIPT_TAG_GREEK;
        self.name = @"Greek Decompose Characters";
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [text decomposedStringWithCanonicalMapping];
}

@end
