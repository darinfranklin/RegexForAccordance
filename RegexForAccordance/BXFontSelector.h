//
//  BXFontSelector.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTextLanguage.h"

@interface BXFontSelector : NSObject
/* script identifies the language of the text: Hebr, Grek, or Latn.
 Standard tag values: http://tools.ietf.org/html/bcp47#section-2.2.3
 */
- (void)setCurrentFontsForLanguageScriptTag:(NSString *)script;
- (NSFont *)latinFont;
- (NSFont *)greekFont;
- (NSFont *)hebrewFont;
- (NSFont *)plainFont;
- (NSFont *)verseRefFont;
- (NSFont *)hitFont;
- (NSColor *)hitTextColor;
- (NSFont *)systemFont;

@end
