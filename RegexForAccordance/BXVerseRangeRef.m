//
//  BXVerseRangeRef.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 12/16/17.
//  Copyright © 2017 Darin Franklin. All rights reserved.
//

#import "BXVerseRangeRef.h"
#import "BXSearchSettings.h"

@implementation BXVerseRangeRef

- (id)initWithFirstRef:(BXVerseRef *)first lastRef:(BXVerseRef *)last searchScope:(NSInteger)searchScope
{
    if (self = [super initWithBook:first.book chapter:first.chapter verse:first.verse europeanFormat:first.europeanFormat])
    {
        _firstVerseRef = first;
        _lastVerseRef = last;
        _searchScope = searchScope;
        if (self.searchScope == SearchScopeChapter)
        {
            _firstVerseRef = [[BXVerseRef alloc] initWithBook:first.book
                                                      chapter:first.chapter
                                                        verse:0
                                               europeanFormat:first.europeanFormat];
        }
        else if (self.searchScope == SearchScopeBook)
        {
            _firstVerseRef = [[BXVerseRef alloc] initWithBook:first.book
                                                      chapter:0
                                                        verse:0
                                               europeanFormat:first.europeanFormat];
        }
        [self updateStringValue];
    }
    return self;
}

- (NSString *)formatString
{
    if (self.searchScope == SearchScopeChapter)
    {
        if (self.firstVerseRef.chapter == 0)
        {
            return [NSString stringWithFormat:@"%@", self.firstVerseRef.book];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ %ld", self.firstVerseRef.book, self.firstVerseRef.chapter];
        }
    }
    else if (self.searchScope == SearchScopeBook)
    {
        return [NSString stringWithFormat:@"%@", self.firstVerseRef.book];
    }
    else // SearchScopeVerse
    {
        return [NSString stringWithFormat:@"%@ - %@", self.firstVerseRef.stringValue, self.lastVerseRef.stringValue];
    }
}

@end
