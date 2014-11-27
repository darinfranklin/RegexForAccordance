//
//  BXFilterDecomposeCharacters.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/25/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterDecomposeCharacters.h"
#import "BXTextLanguage.h"

@implementation BXFilterDecomposeCharacters

- (id)init
{
    if (self = [super initWithName:@"Decompose Characters"])
    {
    }
    return self;
}

- (NSString *)filter:(NSString *)text
{
    return [text decomposedStringWithCanonicalMapping];
}

@end
