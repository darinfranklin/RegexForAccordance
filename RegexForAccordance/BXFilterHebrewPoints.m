//
//  BXFilterHebrewPoints.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterHebrewPoints.h"
#import "BXTextLanguage.h"

@implementation BXFilterHebrewPoints

- (id)init
{
    if (self = [super initWithName:@"Hebrew Remove Points" charactersToRemove:[BXTextLanguage hebrewPointsCharacterSet]])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end
