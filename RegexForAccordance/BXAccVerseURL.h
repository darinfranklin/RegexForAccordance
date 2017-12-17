//
//  BXAccVerseURL.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXSearchSettings.h"

@interface BXAccVerseURL : NSObject

/* Formats a URL with the given verse references. ref can be a single verse or a list: John 1:1,2-4; 4:5; Acts 2:1. */
- (NSURL *)urlForVerseRef:(NSString *)ref inText:(NSString *)text;

/* Formats searchResults into one or more "accord://" URL's. Because Accordance crashes if the URL is too long, we divide it into several URL's.
 Returns NSArray of BXAccLink objects, which contain the url and the first and last verse in the range. */
- (NSArray *)linksForSearchResults:(NSArray *)searchResults textName:(NSString *)textName;
- (NSArray *)linksForSearchResults:(NSArray *)searchResults textName:(NSString *)textName searchScope:(SearchScopeOptions)searchScope;

@end
