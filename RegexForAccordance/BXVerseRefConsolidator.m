//
//  BXVerseRefConsolidator.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXVerseRefConsolidator.h"

@interface BXVerseRefConsolidator ()

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

- (NSString *)buildRefString
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *pending = nil;
    NSInteger verse = -1; // some chapters have verse 0
    NSInteger chapter = 0;
    NSString *book = nil;
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
        else if ((ref.verse == verse || ref.verse == verse + 1) && ref.chapter == chapter && [ref.book isEqualToString:book])
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
        else if (ref.verse != verse + 1 && ref.chapter == chapter && [ref.book isEqualToString:book])
        {
            if (pending != nil)
            {
                [str appendString:pending];
                pending = nil;
            }
            verse = ref.verse;
            [nextPart appendString:[NSString stringWithFormat:@",%ld", verse]];
        }
        else if (ref.verse != verse + 1 && ref.chapter != chapter && [ref.book isEqualToString:book])
        {
            if (pending != nil)
            {
                [str appendString:pending];
                pending = nil;
            }
            verse = ref.verse;
            chapter = ref.chapter;
            [nextPart appendString:[NSString stringWithFormat:@"; %ld:%ld", ref.chapter, ref.verse]];
        }
        else
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
