//
//  BXSearchResultFormatter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXSearchResult.h"
#import "BXFontSelector.h"
#import "BXTextLanguage.h"

@interface BXSearchResultFormatter : NSObject

@property NSString *textName;
@property BOOL includeReference;
@property NSWritingDirection writingDirection;
@property NSFont *verseRefFont;
@property NSFont *verseTextFont;
@property NSFont *hitTextFont;

- (id)initWithFontSelector:(BXFontSelector *)fontSelector;
- (NSAttributedString *)formatSearchResult:(BXSearchResult *)result;
- (void)setWritingDirectionForLanguageScriptTag:(NSString *)scriptTag;
- (NSRange)hitRange:(NSRange)hitRange inFormattedSearchResult:(BXSearchResult *)searchResult;

@end
