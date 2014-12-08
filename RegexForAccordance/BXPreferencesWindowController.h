//
//  BXPreferencesWindowController.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/31/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BXPreferencesWindowController : NSWindowController <NSWindowDelegate>
@property IBOutlet NSTextView *defaultFontSample;
@property IBOutlet NSTextView *hebrewFontSample;
@property IBOutlet NSTextView *greekFontSample;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSToolbar *toolbar;
@property (weak) IBOutlet NSButton *showUnicodeCheckbox;

@property (weak) IBOutlet NSPopUpButton *defaultFontNamePopUp;
@property (weak) IBOutlet NSPopUpButton *hebrewFontNamePopUp;
@property (weak) IBOutlet NSPopUpButton *greekFontNamePopUp;
@property (weak) IBOutlet NSPopUpButton *verseRefFontNamePopUp;
@property (weak) IBOutlet NSPopUpButton *defaultFontSizePopUp;
@property (weak) IBOutlet NSPopUpButton *hebrewFontSizePopUp;
@property (weak) IBOutlet NSPopUpButton *greekFontSizePopUp;
@property (weak) IBOutlet NSPopUpButton *verseRefFontSizePopUp;
@property (weak) IBOutlet NSButton *boldHitsButton;
@property (weak) IBOutlet NSButton *boldReferencesButton;

- (IBAction)selectTab:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (IBAction)showUnicodeIDClicked:(id)sender;

- (IBAction)changeFont:(id)sender;

@end
