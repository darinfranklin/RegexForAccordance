//
//  BXFontSelector.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFontSelector.h"
@interface BXFontSelector ()
@property NSFont *plainFont;
@property NSFont *hitFont;
@property NSFont *verseRefFont;
@end

@implementation BXFontSelector

- (NSFont *)fontForKeyName:(NSString *)fontKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [defaults stringForKey:[NSString stringWithFormat:@"%@FontName", fontKey]];
    CGFloat pointSize = [defaults floatForKey:[NSString stringWithFormat:@"%@FontSize", fontKey]];
    return [NSFont fontWithName:fontName size:pointSize];
}

- (NSFont *)latinFont
{
    return [self fontForKeyName:@"Default"];
}

- (NSFont *)greekFont
{
    return [self fontForKeyName:@"Greek"];
}

- (NSFont *)hebrewFont
{
    return [self fontForKeyName:@"Hebrew"];
}

- (void)setCurrentFontsForLanguageScriptTag:(NSString *)scriptTag
{
    if ([scriptTag isEqualToString:@SCRIPT_TAG_HEBREW])
    {
        self.plainFont = self.hebrewFont;
    }
    else if ([scriptTag isEqualToString:@SCRIPT_TAG_GREEK])
    {
        self.plainFont = self.greekFont;
    }
    else
    {
        self.plainFont = self.latinFont;
    }
    self.hitFont = self.plainFont;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HitsFontBold"])
    {
        self.hitFont = [[NSFontManager sharedFontManager] convertFont:self.hitFont toHaveTrait:NSBoldFontMask];
    }
    self.verseRefFont = [self fontForKeyName:@"VerseRef"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"VerseRefFontBold"])
    {
        self.verseRefFont = [[NSFontManager sharedFontManager] convertFont:self.verseRefFont toHaveTrait:NSBoldFontMask];
    }
}

- (NSColor *)hitTextColor
{
    return NSColor.systemRedColor;
}

- (NSFont *)systemFont
{
    return [NSFont systemFontOfSize:[NSFont systemFontSize]];
}

@end
