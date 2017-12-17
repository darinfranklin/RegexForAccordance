//
//  BXVerseRangeRef.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 12/16/17.
//  Copyright © 2017 Darin Franklin. All rights reserved.
//

#import "BXVerseRef.h"
#import "BXSearchSettings.h"

@interface BXVerseRangeRef : BXVerseRef

- (id)initWithFirstRef:(BXVerseRef *)first lastRef:(BXVerseRef *)last searchScope:(NSInteger)searchScope;
@property SearchScopeOptions searchScope;
@property (readonly) BXVerseRef *firstVerseRef;
@property (readonly) BXVerseRef *lastVerseRef;

@end
