//
//  BXTextLanguage.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXTextLanguage.h"

static NSCharacterSet *hebrewCantillationCharacterSet = nil;
static NSCharacterSet *hebrewPointsCharacterSet = nil;
static NSCharacterSet *greekDiacriticsCharacterSet = nil;

@interface BXTextLanguage ()
    @property NSRegularExpression *hebRegex;
    @property NSRegularExpression *greekRegex;
@end

@implementation BXTextLanguage

- (id)init
{
    if (self = [super init])
    {
        NSError *error = [[NSError alloc] init];
        self.hebRegex = [NSRegularExpression regularExpressionWithPattern:@"[" HEB_LETTERS "]" options:0 error:&error];
        self.greekRegex = [NSRegularExpression regularExpressionWithPattern:@"[" GRK_LETTERS "]" options:0 error:&error];
    }
    return self;
}

- (NSWritingDirection)writingDirectionForString:(NSString *)text
{
    return [self writingDirectionForLanguageScriptTag:[self scriptTagForString:text]];
}

- (NSWritingDirection)writingDirectionForLanguageScriptTag:(NSString *)script
{
    return [script isEqualToString:@SCRIPT_TAG_HEBREW] ? NSWritingDirectionRightToLeft : NSWritingDirectionLeftToRight;
}

- (NSString *)scriptTagForString:(NSString *)text
{
    NSString *languageScriptTag;
    if ([[self.hebRegex matchesInString:text options:0 range:NSMakeRange(0, text.length)] count] > 0)
    {
        languageScriptTag = @SCRIPT_TAG_HEBREW;
    }
    else if ([[self.greekRegex matchesInString:text options:0 range:NSMakeRange(0, text.length)] count] > 0)
    {
        languageScriptTag = @SCRIPT_TAG_GREEK;
    }
    else
    {
        languageScriptTag = @SCRIPT_TAG_LATIN;
    }
    LogDebug(@"%@", languageScriptTag);
    return languageScriptTag;
}

// slower and more complex version (not used)
- (NSString *)scriptTagForStringUsingLinguisticTagger:(NSString *)text
{
    if (text.length == 0)
    {
        return @SCRIPT_TAG_LATIN;
    }
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc]
                                  initWithTagSchemes:[NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil]
                                  options:NSLinguisticTaggerOmitPunctuation
                                  | NSLinguisticTaggerOmitWhitespace
                                  | NSLinguisticTaggerOmitOther];
    [tagger setString:text];
    [tagger enumerateTagsInRange:NSMakeRange(0, text.length)
                          scheme:NSLinguisticTagSchemeLanguage
                         options:NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitOther
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         //orthography.dominantLanguage returns nil if we do not loop through the tokens here
         //NSLog(@"Tag %@ for substring '%@'", tag, [text substringWithRange:tokenRange]);
     }];
    
    NSOrthography *orthography = [tagger orthographyAtIndex:0 effectiveRange:NULL];
    LogDebug(@"NSLinguisticTagger %@-%@", orthography.dominantLanguage, orthography.dominantScript);
    
    NSString *scriptTag = orthography.dominantScript;
    if (scriptTag == nil)
    {
        scriptTag = @SCRIPT_TAG_LATIN;
    }
    return scriptTag;
}

+ (NSCharacterSet *)hebrewCantillationCharacterSet
{
    if (hebrewCantillationCharacterSet == nil)
    {
        NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
        [charSet addCharactersInRange:NSMakeRange(L'\u0591', L'\u05AF' - L'\u0591' + 1)];
        hebrewCantillationCharacterSet = charSet;
    }
    return hebrewCantillationCharacterSet;
}

+ (NSCharacterSet *)hebrewPointsCharacterSet
{
    // HEB_POINTS "\\u05B0-\\u05BD\\u05BF\\u05C1\\u05C2\\u05C7" // SHIN DOT U+05C1; SIN DOT U+05C2
    if (hebrewPointsCharacterSet == nil)
    {
        NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
        [charSet addCharactersInRange:NSMakeRange(L'\u05B0', L'\u05BD' - L'\u05B0' + 1)];
        [charSet addCharactersInRange:NSMakeRange(L'\u05BF', 1)];
        [charSet addCharactersInRange:NSMakeRange(L'\u05C1', 2)];
        [charSet addCharactersInRange:NSMakeRange(L'\u05C7', 1)];
        hebrewPointsCharacterSet = charSet;
    }
    return hebrewPointsCharacterSet;
}

+ (NSCharacterSet *)greekDiacriticsCharacterSet
{
    // GRK_DIACRITICS "\\u0300-\\u0344\u0346-\\u036F" // U+0345 is iota subscript, which regex matches to iota U+03B9

    if (greekDiacriticsCharacterSet == nil)
    {
        NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
        [charSet addCharactersInRange:NSMakeRange(L'\u0300', L'\u0344' - L'\u0300' + 1)];
        [charSet addCharactersInRange:NSMakeRange(L'\u0346', L'\u036F' - L'\u0346' + 1)];
        greekDiacriticsCharacterSet = charSet;
    }
    return greekDiacriticsCharacterSet;
}

@end
