//
//  BXSearchSettings.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 10/5/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NSCellStateValue cellStateValueForBool(BOOL b);

@interface BXSearchSettings : NSObject
@property BOOL ignoreCase;
@property BOOL includeReference;
@property BOOL groupByBook;
@property NSString *textName;
@property NSString *verseRange;
@property BOOL leftToRightOverride;
@property NSString *searchPattern;
@property NSString *searchFieldFont;

@property BOOL removeSpaces;
@property BOOL removeTrailingSpaces;
@property BOOL removePilcrows;
@property BOOL hebrewRemoveCantillation;
@property BOOL hebrewRemovePoints;
@property BOOL hebrewRemovePunctuation;
@property BOOL greekRemoveDiacritics;
@property BOOL greekRemovePunctuation;

@end
