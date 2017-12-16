//
//  BXPreferencesWindowController.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/31/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXPreferencesWindowController.h"
#import "BXFontSelector.h"
#import "BXSearchResultFormatter.h"
#import "BXLineParser.h"
#import "BXSearchResult.h"
#import "BXTextLanguage.h"

NSString *const ShowUnicodeID = @"ShowUnicodeID";
NSString *const NoPromptForUnsaved = @"NoPromptForUnsaved";
NSString *const HitsFontBold = @"HitsFontBold";
NSString *const VerseRefFontBold = @"VerseRefFontBold";
NSString *const DefaultFontSize = @"DefaultFontSize";
NSString *const DefaultFontName = @"DefaultFontName";
NSString *const HebrewFontSize = @"HebrewFontSize";
NSString *const HebrewFontName = @"HebrewFontName";
NSString *const GreekFontSize = @"GreekFontSize";
NSString *const GreekFontName = @"GreekFontName";
NSString *const VerseRefFontName = @"VerseRefFontName";
NSString *const VerseRefFontSize = @"VerseRefFontSize";

@interface BXPreferencesWindowController ()
@property NSString *languageScriptTag;
@property BXSearchResultFormatter *formatter;
@property BXFontSelector *fontSelector;
@property NSString *hebrewSampleText;
@property NSString *greekSampleText;
@property NSString *defaultSampleText;
@end

@implementation BXPreferencesWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"BXPreferencesWindow"];
    if (self) {
        self.hebrewSampleText = @"Gen 1:1 " "בְּרֵאשִׁ֖ית בָּרָ֣א אֱלֹהִ֑ים אֵ֥ת הַשָּׁמַ֖יִם וְאֵ֥ת הָאָֽרֶץ׃";
        self.greekSampleText = @"Gen 1:1 Ἐν ἀρχῇ ἐποίησεν ὁ θεὸς τὸν οὐρανὸν καὶ τὴν γῆν.";
        self.defaultSampleText = @"Gen 1:1 In the beginning God created the heaven and the earth.";
        self.fontSelector = [[BXFontSelector alloc] init];
        self.formatter = [[BXSearchResultFormatter alloc] initWithFontSelector:self.fontSelector];
    }
    return self;
}

- (void)awakeFromNib
{
    self.hebrewFontSample.alignment = NSRightTextAlignment;

    [self.defaultFontSample setEditable:NO];
    [self.defaultFontSample setSelectable:NO];
    [self.hebrewFontSample setEditable:NO];
    [self.hebrewFontSample setSelectable:NO];
    [self.greekFontSample setEditable:NO];
    [self.greekFontSample setSelectable:NO];
    
    NSArray *fontNames = [[NSFontManager sharedFontManager] availableFontFamilies];
    NSArray *sizes = [NSArray arrayWithObjects:@"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                      @"22", @"24", @"26", @"28", @"30", @"32", @"34", @"36", @"40", @"44", @"48", @"56", @"64", @"72", nil];

    [self setUpFontNamePopUp:self.defaultFontNamePopUp withFontNames:fontNames andSizePopUp:self.defaultFontSizePopUp withSizes:sizes];
    [self setUpFontNamePopUp:self.hebrewFontNamePopUp withFontNames:fontNames andSizePopUp:self.hebrewFontSizePopUp withSizes:sizes];
    [self setUpFontNamePopUp:self.greekFontNamePopUp withFontNames:fontNames andSizePopUp:self.greekFontSizePopUp withSizes:sizes];
    [self setUpFontNamePopUp:self.verseRefFontNamePopUp withFontNames:fontNames andSizePopUp:self.verseRefFontSizePopUp withSizes:sizes];
    [self.fontSelector setCurrentFontsForLanguageScriptTag:@SCRIPT_TAG_LATIN];
    [self loadPreferences];
    [self formatAllSampleText];
}

- (void)setUpFontNamePopUp:(NSPopUpButton *)namePopUp withFontNames:(NSArray *)fontNames
              andSizePopUp:(NSPopUpButton *)sizePopUp withSizes:(NSArray *)fontSizes
{
    [namePopUp removeAllItems];
    [namePopUp addItemsWithTitles:fontNames];
    [sizePopUp removeAllItems];
    [sizePopUp addItemsWithTitles:fontSizes];
}

- (void)setFontSelection:(NSFont *)font intoNamePopUpButton:(NSPopUpButton *)namePopupButton andSizePopUpButton:sizePopUpButton
{
    NSString *name = font.familyName;
    NSUInteger size = (NSUInteger)roundf(font.pointSize);
    [namePopupButton selectItemWithTitle:name];
    [sizePopUpButton selectItemWithTitle:[NSString stringWithFormat:@"%ld", size]];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[[NSFontManager sharedFontManager] fontPanel:NO] close];
}

- (void)formatAllSampleText
{
    [self formatSampleText:self.defaultSampleText withLanguageScriptTag:@SCRIPT_TAG_LATIN inTextView:self.defaultFontSample];
    [self formatSampleText:self.hebrewSampleText withLanguageScriptTag:@SCRIPT_TAG_HEBREW inTextView:self.hebrewFontSample];
    [self formatSampleText:self.greekSampleText withLanguageScriptTag:@SCRIPT_TAG_GREEK inTextView:self.greekFontSample];
}

- (void)formatSampleText:(NSString *)text
   withLanguageScriptTag:(NSString *)languageScriptTag
              inTextView:(NSTextView *)textView
{
    [self.fontSelector setCurrentFontsForLanguageScriptTag:languageScriptTag];
    [self.formatter setWritingDirectionForLanguageScriptTag:languageScriptTag];
    [textView.textStorage setAttributedString:[self formatVerseLine:text]];
    // Yosemite bug workaround:
    textView.alignment = textView.alignment;
}

- (NSAttributedString *)formatVerseLine:(NSString *)line
{
    BXVerse *verse = [[[BXLineParser alloc] init] verseForLine:line];
    BXSearchResult *searchResult = [[BXSearchResult alloc] init];
    searchResult.verse = verse;
    NSRange hitRange = NSMakeRange(0, 10);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^.{10}" options:0 error:nil];
    NSTextCheckingResult *tcr = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&hitRange count:1 regularExpression:regex];
    searchResult.hits = [NSArray arrayWithObjects:tcr, nil];
    NSAttributedString *formattedLine = [self.formatter formatSearchResult:searchResult];
    return formattedLine;
}

- (void)loadPreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setFontSelection:self.fontSelector.latinFont intoNamePopUpButton:self.defaultFontNamePopUp andSizePopUpButton:self.defaultFontSizePopUp];
    [self setFontSelection:self.fontSelector.hebrewFont intoNamePopUpButton:self.hebrewFontNamePopUp andSizePopUpButton:self.hebrewFontSizePopUp];
    [self setFontSelection:self.fontSelector.greekFont intoNamePopUpButton:self.greekFontNamePopUp andSizePopUpButton:self.greekFontSizePopUp];
    [self setFontSelection:self.fontSelector.verseRefFont intoNamePopUpButton:self.verseRefFontNamePopUp andSizePopUpButton:self.verseRefFontSizePopUp];
    [self updateSample:self.defaultFontSample withFontNameKey:DefaultFontName andFontSizeKey:DefaultFontSize];
    [self updateSample:self.hebrewFontSample withFontNameKey:HebrewFontName andFontSizeKey:HebrewFontSize];
    [self updateSample:self.greekFontSample withFontNameKey:GreekFontName andFontSizeKey:GreekFontSize];
    self.toolbar.selectedItemIdentifier = @"FontsToolbarItem";
    self.showUnicodeCheckbox.state = [defaults boolForKey:ShowUnicodeID];
    self.noPromptForUnsavedCheckbox.state = [defaults boolForKey:NoPromptForUnsaved];
    self.boldHitsButton.state = [defaults boolForKey:HitsFontBold];
    self.boldReferencesButton.state = [defaults boolForKey:VerseRefFontBold];
}

- (void)updateSample:(NSTextView *)sample withFontNameKey:(NSString *)fontNameKey andFontSizeKey:(NSString *)fontSizeKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [defaults stringForKey:fontNameKey];
    CGFloat fontSize = [defaults floatForKey:fontSizeKey];
    NSFont *font = [NSFont fontWithName:fontName size:fontSize];
    sample.font = font;
}

- (IBAction)selectTab:(id)sender
{
    [self.tabView selectTabViewItem:[self.tabView tabViewItemAtIndex:[sender tag]]];
}

- (void)changeFont:(id)sender
{
    NSString *fontNameKey;
    NSString *fontSizeKey;
    NSString *fontName;
    NSString *fontSize;
    NSTextView *sampleView = nil;
    NSString *sampleText = nil;
    NSString *languageScriptTag = nil;
    switch ([sender tag])
    {
        case 1:
            fontNameKey = DefaultFontName;
            fontSizeKey = DefaultFontSize;
            fontName = self.defaultFontNamePopUp.titleOfSelectedItem;
            fontSize = self.defaultFontSizePopUp.titleOfSelectedItem;
            sampleText = self.defaultSampleText;
            sampleView = self.defaultFontSample;
            languageScriptTag = @SCRIPT_TAG_LATIN;
            break;
        case 2:
            fontNameKey = HebrewFontName;
            fontSizeKey = HebrewFontSize;
            fontName = self.hebrewFontNamePopUp.titleOfSelectedItem;
            fontSize = self.hebrewFontSizePopUp.titleOfSelectedItem;
            sampleText = self.hebrewSampleText;
            sampleView = self.hebrewFontSample;
            languageScriptTag = @SCRIPT_TAG_HEBREW;
            break;
        case 3:
            fontNameKey = GreekFontName;
            fontSizeKey = GreekFontSize;
            fontName = self.greekFontNamePopUp.titleOfSelectedItem;
            fontSize = self.greekFontSizePopUp.titleOfSelectedItem;
            sampleText = self.greekSampleText;
            sampleView = self.greekFontSample;
            languageScriptTag = @SCRIPT_TAG_GREEK;
            break;
        case 4:
            fontNameKey = VerseRefFontName;
            fontSizeKey = VerseRefFontSize;
            fontName = self.verseRefFontNamePopUp.titleOfSelectedItem;
            fontSize = self.verseRefFontSizePopUp.titleOfSelectedItem;
            break;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (fontNameKey != nil)
    {
        [defaults setObject:fontName forKey:fontNameKey];
    }
    if (fontSizeKey != nil)
    {
        [defaults setObject:[NSNumber numberWithInteger:[fontSize integerValue]] forKey:fontSizeKey];
    }
    [defaults setBool:(self.boldHitsButton.state == NSOnState) forKey:HitsFontBold];
    [defaults setBool:(self.boldReferencesButton.state == NSOnState) forKey:VerseRefFontBold];
    if (sampleText != nil)
    {
        [self formatSampleText:sampleText withLanguageScriptTag:languageScriptTag inTextView:sampleView];
    }
    else
    {
        [self formatAllSampleText];
    }
}

#pragma mark Advanced

- (IBAction)showUnicodeIDClicked:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = self.showUnicodeCheckbox.state == NSOnState;
    [defaults setBool:value forKey:ShowUnicodeID];
}

- (IBAction)noPromptForUnsavedClicked:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = self.noPromptForUnsavedCheckbox.state == NSOnState;
    [defaults setBool:value forKey:NoPromptForUnsaved];
}


- (IBAction)resetPreferences:(id)sender
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self loadPreferences];
}

@end
