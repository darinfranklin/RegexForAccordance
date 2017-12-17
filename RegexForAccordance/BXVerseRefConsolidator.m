//
//  BXVerseRefConsolidator.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXVerseRefConsolidator.h"

@interface BXVerseRefConsolidator ()
@property NSString *chapterDelimiter;
@property NSString *verseDelimiter;
@end

@implementation BXVerseRefConsolidator
{
    NSMutableArray *_verseRefs;
    NSUInteger _verseRefIndex;
}

- (id)init
{
    if (self = [super init])
    {
        _verseRefs = [[NSMutableArray alloc] init];
        _verseRefIndex = 0;
        BXVerseRef *tempNonEuropeanFormatVerseRef = [[BXVerseRef alloc] init];
        self.chapterDelimiter = tempNonEuropeanFormatVerseRef.chapterDelimiter;
        self.verseDelimiter = tempNonEuropeanFormatVerseRef.verseDelimiter;
        self.maxLength = 1023;
    }
    return self;
}

- (id)initWithVerseRefs:(NSArray *)refs
{
    if (self = [self init])
    {
        [self addVerseRefs:refs];
    }
    return self;
}

- (void)addVerseRef:(BXVerseRef *)ref
{
    [_verseRefs addObject:ref];
}

- (void)addVerseRefs:(NSArray *)refs
{
    [_verseRefs addObjectsFromArray:refs];
}

- (void)reset
{
    _verseRefIndex = 0;
}

- (BXVerseRef *)currentVerseRef
{
    if (_verseRefIndex >= _verseRefs.count)
    {
        return nil;
    }
    return [_verseRefs objectAtIndex:_verseRefIndex];
}

- (BXVerseRef *)lastUsedVerseRef
{
    if (_verseRefIndex == 0)
    {
        return nil;
    }
    return [_verseRefs objectAtIndex:_verseRefIndex - 1];
}

// Use European format if one of the verse refs has that format.
// If all the verses are from single-chapter books like Obadiah or Jude, then we can't detect which format Accordance wants.
// The default is non-European format.
- (void)setDelimiters
{
    [_verseRefs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        BXVerseRef *ref = obj;
        if (ref.europeanFormat)
        {
            self.chapterDelimiter = ref.chapterDelimiter;
            self.verseDelimiter = ref.verseDelimiter;
            *stop = YES;
        }
    }];
}

- (NSString *)buildRefString
{
    if (self.searchScope == SearchScopeChapter)
    {
        return [self buildRefStringChapterScope];
    }
    else if (self.searchScope == SearchScopeBook)
    {
        return [self buildRefStringBookScope];
    }
    else
    {
        return [self buildRefStringVerseScope];
    }
}

// Gen 1-3, 5; Exod 3
- (NSString *)buildRefStringChapterScope
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *pending = nil;
    NSInteger chapter = 0;
    NSString *book = nil;
    [self setDelimiters];
    while (_verseRefIndex < _verseRefs.count)
    {
        BXVerseRef *ref = [_verseRefs objectAtIndex:_verseRefIndex++];
        NSMutableString *nextPart = [[NSMutableString alloc] init];
        if (![ref.book isEqualToString:book]) // new book or first book
        {
            if (pending != nil)
            {
                [str appendString:pending];
                pending = nil;
            }
            if (book != nil)
            {
                [nextPart appendString:@"; "];
            }
            [nextPart appendString:ref.stringValue]; // Gen 1
            book = ref.book;
            chapter = ref.chapter;
        }
        else // same book
        {
            if (ref.chapter == chapter + 1) // next chapter
            {
                pending = [NSString stringWithFormat:@"-%ld", ref.chapter];
            }
            else // skipped chapters
            {
                if (pending != nil)
                {
                    [str appendString:pending];
                    pending = nil;
                }
                [nextPart appendString:[NSString stringWithFormat:@"; %ld", ref.chapter]];
            }
            chapter = ref.chapter;
        }
        if (str.length + nextPart.length > self.maxLength)
        {
            _verseRefIndex--;
            break;
        }
        [str appendString:nextPart];
    }
    if (pending != nil)
    {
        [str appendString:pending];
    }
    if (str.length == 0)
    {
        str = nil;
    }
    return str;
}

// Gen; Exod; Rev
- (NSString *)buildRefStringBookScope
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *book = nil;
    [self setDelimiters];
    while (_verseRefIndex < _verseRefs.count)
    {
        BXVerseRef *ref = [_verseRefs objectAtIndex:_verseRefIndex++];
        if (![ref.book isEqualToString:book]) // new book or first book
        {
            if (book != nil)
            {
                [str appendString:@"; "];
            }
            [str appendString:ref.stringValue]; // Gen
            book = ref.book;
        }
    }
    if (str.length == 0)
    {
        str = nil;
    }
    return str;
}


- (NSString *)buildRefStringVerseScope
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *pending = nil;
    NSInteger verse = -1; // some chapters have verse 0
    NSInteger chapter = 0;
    NSString *book = nil;
    [self setDelimiters];
    while (_verseRefIndex < _verseRefs.count)
    {
        BXVerseRef *ref = [_verseRefs objectAtIndex:_verseRefIndex++];
        NSMutableString *nextPart = [[NSMutableString alloc] init];
        if (verse == -1)
        {
            [nextPart appendString:ref.stringValue];
            verse = ref.verse;
            chapter = ref.chapter;
            book = ref.book;
            pending = nil;
        }
        else if ([ref.book isEqualToString:book])
        {
            if (ref.chapter == chapter)
            {
                if (ref.verse == verse) // same book, chapter, and verse
                {
                    // Do nothing. Verse is repeated.
                }
                else if (ref.verse == verse + 1) // same book and chapter, next verse
                {
                    NSString *prevPending = pending;
                    pending = [NSString stringWithFormat:@"-%ld", ref.verse];
                    if (str.length + pending.length > self.maxLength)
                    {
                        pending = nil;
                        _verseRefIndex--;
                        if (prevPending != nil)
                        {
                            [str appendString:prevPending];
                        }
                        break;
                    }
                    verse = ref.verse;
                }
                else // same book and chapter, different verse
                {
                    if (pending != nil)
                    {
                        [str appendString:pending];
                        pending = nil;
                    }
                    verse = ref.verse;
                    [nextPart appendString:[NSString stringWithFormat:@"%@%ld", self.verseDelimiter, verse]];
                }
            }
            else // same book, different chapter
            {
                if (pending != nil)
                {
                    [str appendString:pending];
                    pending = nil;
                }
                verse = ref.verse;
                chapter = ref.chapter;
                [nextPart appendString:[NSString stringWithFormat:@"; %ld%@%ld", ref.chapter, self.chapterDelimiter, ref.verse]];
            }
        }
        else // different book
        {
            if (pending != nil)
            {
                [str appendString:pending];
            }
            [nextPart appendString:[NSString stringWithFormat:@"; %@", ref.stringValue]];
            verse = ref.verse;
            chapter = ref.chapter;
            book = ref.book;
            pending = nil;
        }
        if (str.length + nextPart.length > self.maxLength)
        {
            _verseRefIndex--;
            break;
        }
        [str appendString:nextPart];
    }
    
    if (pending != nil)
    {
        [str appendString:pending];
    }
    if (str.length == 0)
    {
        str = nil;
    }
    return str;
}

@end
