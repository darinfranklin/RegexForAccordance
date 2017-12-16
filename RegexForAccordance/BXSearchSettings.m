//
//  BXSearchSettings.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 10/5/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchSettings.h"

NSCellStateValue cellStateValueForBool(BOOL b)
{
    return b ? NSOnState : NSOffState;
}

@implementation BXSearchSettings

- (NSString *)searchScopeString
{
	NSString *theScope = @"";
	
	switch (self.searchScope)
	{
		case SearchScopeChapter:
			theScope = @"Chapter";
			break;
		case SearchScopeBook:
			theScope = @"Book";
			break;
		default:
			theScope = @"Verse";
			break;
	}
	
    return theScope;
}


- (void)setSearchScopeString:(NSString *)scopeString
{
	if ([scopeString isEqualToString:@"Chapter"])
		self.searchScope = SearchScopeChapter;
	else if ([scopeString isEqualToString:@"Book"])
		self.searchScope = SearchScopeBook;
	else
		self.searchScope = SearchScopeVerse;
}

@end
