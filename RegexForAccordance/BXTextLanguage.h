//
//  BXTextLanguage.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZWSP "\u200B" // ZERO-WIDTH SPACE
#define NBSP "\u00A0" // NO-BREAK SPACE
#define LRE "\u202A" // LEFT-TO-RIGHT EMBEDDING
#define RLE "\u202B" // RIGHT-TO-LEFT EMBEDDING
#define PDF "\u202C" // POP DIRECTIONAL FORMATTING
#define LRO "\u202D" // LEFT-TO-RIGHT OVERRIDE
#define RLO "\u202E" // RIGHT-TO-LEFT OVERRIDE
#define LRM "\u200E" // LEFT-TO-RIGHT MARK
#define RLM "\u200F" // RIGHT-TO-LEFT MARK

#define HEB_CANTIL "\\u0591-\\u05AF"
#define HEB_POINTS "\\u05B0-\\u05BD\\u05BF\\u05C1\\u05C2\\u05C7" // SHIN DOT U+05C1; SIN DOT U+05C2
#define HEB_PUNCTS "\\u05BE\\u05C0\\u05C3-\\u05C6"
#define HEB_LETTERS "\\u05D0-\\u05EA"

#define GRK_DIACRITICS "\\u0300-\\u0344\u0346-\\u036F" // U+0345 is iota subscript, which regex matches to iota U+03B9
#define GRK_PUNCTS ".,;·᾿«»_\\u002D\\u2014" // U+2014 EM DASH; U+002D -
#define GRK_LETTERS "\\u0391-\\u03C9"

#define SCRIPT_TAG_HEBREW  "Hebr"
#define SCRIPT_TAG_GREEK   "Grek"
#define SCRIPT_TAG_LATIN   "Latn"

@interface BXTextLanguage : NSObject

/* Script Tag is a four-character code that identifies the language: Hebr, Grek, Latn */
- (NSString *)scriptTagForString:(NSString *)text;
- (NSWritingDirection)writingDirectionForString:(NSString *)text;
- (NSWritingDirection)writingDirectionForLanguageScriptTag:(NSString *)script;
+ (NSCharacterSet *)hebrewCantillationCharacterSet;
+ (NSCharacterSet *)hebrewPointsCharacterSet;
+ (NSCharacterSet *)greekDiacriticsCharacterSet;
@end
