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
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"\u05D9\u05B4", @"\uFB1D", // HEBREW LETTER YOD WITH HIRIQ
                         @"\u05E9\u05C1", @"\uFB2A", // HEBREW LETTER SHIN WITH SHIN DOT
                         @"\u05E9\u05C2", @"\uFB2B", // HEBREW LETTER SHIN WITH SIN DOT
                         //@"\uFB2A\u05BC", @"\uFB2C", // HEBREW LETTER SHIN WITH DAGESH AND SHIN DOT
                         @"\u05E9\u05C1\u05BC", @"\uFB2C", // HEBREW LETTER SHIN WITH DAGESH AND SHIN DOT
                         //@"\uFB2B\u05BC", @"\uFB2D", // HEBREW LETTER SHIN WITH DAGESH AND SIN DOT
                         @"\u05E9\u05C2\u05BC", @"\uFB2D", // HEBREW LETTER SHIN WITH DAGESH AND SIN DOT
                         @"\u05D0\u05B7", @"\uFB2E", // HEBREW LETTER ALEF WITH PATAH
                         @"\u05D0\u05B8", @"\uFB2F", // HEBREW LETTER ALEF WITH QAMATS
                         @"\u05D0\u05BC", @"\uFB30", // HEBREW LETTER ALEF WITH MAPIQ
                         @"\u05D1\u05BC", @"\uFB31", // HEBREW LETTER BET WITH DAGESH
                         @"\u05D2\u05BC", @"\uFB32", // HEBREW LETTER GIMEL WITH DAGESH
                         @"\u05D3\u05BC", @"\uFB33", // HEBREW LETTER DALET WITH DAGESH
                         @"\u05D4\u05BC", @"\uFB34", // HEBREW LETTER HE WITH MAPIQ
                         @"\u05D5\u05BC", @"\uFB35", // HEBREW LETTER VAV WITH DAGESH
                         @"\u05D6\u05BC", @"\uFB36", // HEBREW LETTER ZAYIN WITH DAGESH
                         @"\u05D8\u05BC", @"\uFB38", // HEBREW LETTER TET WITH DAGESH
                         @"\u05D9\u05BC", @"\uFB39", // HEBREW LETTER YOD WITH DAGESH
                         @"\u05DA\u05BC", @"\uFB3A", // HEBREW LETTER FINAL KAF WITH DAGESH
                         @"\u05DB\u05BC", @"\uFB3B", // HEBREW LETTER KAF WITH DAGESH
                         @"\u05DC\u05BC", @"\uFB3C", // HEBREW LETTER LAMED WITH DAGESH
                         @"\u05DE\u05BC", @"\uFB3E", // HEBREW LETTER MEM WITH DAGESH
                         @"\u05E0\u05BC", @"\uFB40", // HEBREW LETTER NUN WITH DAGESH
                         @"\u05E1\u05BC", @"\uFB41", // HEBREW LETTER SAMEKH WITH DAGESH
                         @"\u05E3\u05BC", @"\uFB43", // HEBREW LETTER FINAL PE WITH DAGESH
                         @"\u05E4\u05BC", @"\uFB44", // HEBREW LETTER PE WITH DAGESH
                         @"\u05E6\u05BC", @"\uFB46", // HEBREW LETTER TSADI WITH DAGESH
                         @"\u05E7\u05BC", @"\uFB47", // HEBREW LETTER QOF WITH DAGESH
                         @"\u05E8\u05BC", @"\uFB48", // HEBREW LETTER RESH WITH DAGESH
                         @"\u05E9\u05BC", @"\uFB49", // HEBREW LETTER SHIN WITH DAGESH
                         @"\u05EA\u05BC", @"\uFB4A", // HEBREW LETTER TAV WITH DAGESH
                         @"\u05D5\u05B9", @"\uFB4B", // HEBREW LETTER VAV WITH HOLAM
                         @"\u05D1\u05BF", @"\uFB4C", // HEBREW LETTER BET WITH RAFE
                         @"\u05DB\u05BF", @"\uFB4D", // HEBREW LETTER KAF WITH RAFE
                         @"\u05E4\u05BF", @"\uFB4E", // HEBREW LETTER PE WITH RAFE
                         nil];
    if (self = [super initWithName:@"Hebrew Normalize to Composite Characters" searchReplaceMap:map])
    {
        self.languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    return self;
}

@end


// [\uFB1D-\uFB29] none (hiriq yod, wide letters)
// [\uFB2A-\uFB2B] sin-shin dots (preserve; do not change)
// [\uFB2C-\uFB2D] sin-shin with dagesh (keep sin and shin, separate dagesh)
// [\uFB2E-\uFB4B] letters with dagesh, mapiq, holam, etc.
// [\uFB4C-\uFB4F] none (rafe, alef-lamed ligature)
