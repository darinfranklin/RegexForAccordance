//
//  BXDocument.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/23/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXSearchSettings.h"

extern NSString *const IgnoreCase;
extern NSString *const IncludeReference;
extern NSString *const SearchScope;
extern NSString *const LeftToRightOverride;
extern NSString *const GroupByBook;
extern NSString *const SearchPattern;
extern NSString *const VerseRange;
extern NSString *const TextName;
extern NSString *const RemoveSpaces;
extern NSString *const RemoveTrailingSpaces;
extern NSString *const HebrewRemoveCantillation;
extern NSString *const HebrewRemovePoints;
extern NSString *const HebrewRemovePunctuation;
extern NSString *const GreekRemoveDiacritics;
extern NSString *const GreekRemovePunctuation;

@interface BXDocument : NSDocument
@property BXSearchSettings *searchSettings;
@end
