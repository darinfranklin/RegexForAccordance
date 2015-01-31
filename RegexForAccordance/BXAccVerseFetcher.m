//
//  BXAccVerseFetcher.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/3/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXAccVerseFetcher.h"
#import "BXVerse.h"
#import "BXLineSplitter.h"
#import "BXVerseRangeParser.h"
#import "BXLineParser.h"

NSUInteger const MaxLinesPerFetch = 500;

@interface BXAccVerseFetcher()
@property NSUInteger indexInCurrentFetch;
@property NSUInteger lineNumber;
@property NSString *refRangeStart;
@property NSString *refRangeEnd;
@property BXLineParser *lineParser;
@property BXLineSplitter *lineSplitter;
@end

@implementation BXAccVerseFetcher
{
    NSDictionary *_appleScriptError;
    NSArray *_availableTexts;
}

- (id) init
{
    if (self = [super init])
    {
        self.lineParser = [[BXLineParser alloc] init];
        [self reset];
    }
    return self;
}

- (void)reset
{
    self.refRangeStart = nil;
    self.refRangeEnd = nil;
    self.indexInCurrentFetch = 0;
    self.lineNumber = 0;
    _error = nil;
    _appleScriptError = nil;
    self.lineSplitter = nil;
    self.firstVerse = nil;
    self.lastVerse = nil;
}

- (NSArray *)availableTexts
{
    if (_availableTexts == nil)
    {
        NSString *src = @"tell application \"Accordance\" to «event AccdVerL»";
        LogDebug(@"%@", src);
        NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:src];
        NSDictionary *appleScriptError = nil;
        NSAppleEventDescriptor *event = [appleScript executeAndReturnError:&appleScriptError];
        if (appleScriptError)
        {
            [self logError:appleScriptError];
            _error = [self errorForAppleScriptError:appleScriptError];
        }
        NSMutableArray *list;
        if (event.descriptorType == typeAEList)
        {
            NSUInteger count = [event numberOfItems];
            list = [NSMutableArray arrayWithCapacity:count];
            for (NSUInteger i = 1; i <= count; i++)
            {
                NSAppleEventDescriptor *item = [event descriptorAtIndex:i];
                if (item.descriptorType == typeUnicodeText)
                {
                    NSString *name = [[item stringValue] substringFromIndex:1]; // first char is ''
                    [list addObject:name];
                }
            }
        }
        _availableTexts = list;
    }
    return _availableTexts;
}

- (NSString *)fetchVersesFromText:(NSString *)textName withVerseRange:(NSString *)verseRefs
{
    _error = nil;
    if ([[verseRefs stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        _error = [self errorForInvalidRange:verseRefs inTextName:textName errorCode:-1001];
        return nil;
    }
    else
    {
        NSString *src = [NSString stringWithFormat:@"tell application \"Accordance\" to «event AccdTxRf» {\"%@\", \"%@\", false}",
                         self.textName, verseRefs];
        LogDebug(@"%@", src);
        NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:src];
        NSDictionary *appleScriptError;
        NSAppleEventDescriptor *event = [appleScript executeAndReturnError:&appleScriptError];
        if (appleScriptError != nil)
        {
            [self logError:appleScriptError];
            NSInteger errorNumber = [[appleScriptError valueForKey:NSAppleScriptErrorNumber] integerValue];
            if (errorNumber == -1)
            {
                // -1: invalid Range or invalid Text
                _error = [self errorForInvalidRange:verseRefs inTextName:textName errorCode:errorNumber];
            }
            else
            {
                _error = [self errorForAppleScriptError:appleScriptError];
            }
            return nil;
        }
        else if ([event.stringValue hasPrefix:@"ERR-"])
        {
            LogDebug(@"Script error: %@", event.stringValue);
            _error = [self errorForScriptErrorMessage:event.stringValue];
            return nil;
        }
        else
        {
            return event.stringValue;
        }
    }
}

- (void)fetch
{
    if (self.verseRange == nil)
    {
        LogWarning(@"Fetcher verseRange is nil");
        _error = [self errorForInvalidRange:self.verseRange inTextName:self.textName errorCode:-1];
    }
    else if (self.textName == nil)
    {
        LogWarning(@"Fetcher textName is nil");
        _error = [self errorForInvalidRange:self.verseRange inTextName:self.textName errorCode:-1];
    }
    else
    {
        if (self.refRangeStart == nil)
        {
            BXVerseRangeParser *rangeParser = [[BXVerseRangeParser alloc] init];
            [rangeParser parseVerseRefs:self.verseRange];
            self.refRangeStart = rangeParser.refRangeStart;
            self.refRangeEnd = rangeParser.refRangeEnd;
            // refRangeEnd will be nil if verseRange has commas or semicolons
        }
        NSString *refs = self.refRangeStart;
        if (self.refRangeStart != nil && self.refRangeEnd != nil)
        {
            if ([self.refRangeStart isEqualToString:self.refRangeEnd])
            {
                refs = [NSString stringWithFormat:@"%@", self.refRangeStart];
            }
            else
            {
                refs = [NSString stringWithFormat:@"%@ - %@", self.refRangeStart, self.refRangeEnd];
            }
        }
        NSString *lines = [self fetchVersesFromText:self.textName withVerseRange:refs];
        if (_error == nil)
        {
            // BXLineSplitter holds a NSArray of 500 lines, plus the original block of text obtained from AppleScript.  Every time we fetch a new batch of lines, we need to release the previous batch.
            // BXSearch has an autorelease pool around its loop. We set a flag here to tell BXSearch to exit its loop and autorelease pool temporarily so that the memory that was previously allocated in the pool will be freed.
            self.hasGarbage = (self.lineSplitter != nil);
            self.lineSplitter = [[BXLineSplitter alloc] initWithString:lines delimiter:@"\r"];
        }
    }
}

- (BXVerse *)nextVerse
{
    if (self.lineSplitter == nil)
    {
        [self fetch];
    }
    else if (self.indexInCurrentFetch != 0 && self.indexInCurrentFetch % MaxLinesPerFetch == 0)
    {
        if (self.refRangeEnd != nil)
        {
            [self fetch];
            // Line 1 is a repeat of line 500 in previous fetch.
            [self.lineSplitter nextLine];
            self.indexInCurrentFetch = 1;
        }
        else
        {
            _error = [self errorForVerseLimit];
        }
    }
    NSString *line = [self.lineSplitter nextLine];
    BXVerse *verse;
    if (line != nil)
    {
        verse = [self.lineParser verseForLine:line];
        self.lineNumber += 1;
        verse.lineNumber = self.lineNumber;
        self.indexInCurrentFetch += 1;
        self.refRangeStart = verse.ref.stringValue ?: @"NULL";
        if (self.firstVerse == nil)
        {
            self.firstVerse = verse;
        }
        self.lastVerse = verse;
    }
    // Some verses have additional lines when "Citation > Suppress Poetry" is turned off.
    while (![self.lineParser lineHasVerseReference:[self.lineSplitter peekAtNextLine]])
    {
        NSString *nextLine = [self.lineSplitter nextLine];
        if (nextLine == nil || nextLine.length == 0)
        {
            break;
        }
        verse.text = [verse.text stringByAppendingString:@"\n"];
        verse.text = [verse.text stringByAppendingString:nextLine];
    }
    return verse;
}

- (NSString *)peekAtNextLine
{
    if (self.lineSplitter == nil)
    {
        [self fetch];
        if (_error != nil)
        {
            return nil;
        }
    }
    NSString *line = [self.lineSplitter peekAtNextLine];
    return line;
}

- (NSUInteger)lineCount
{
    return self.lineNumber;
}

#pragma mark Errors


- (void)logError:(NSDictionary *)errorInfo
{
    // Accordance got an error: An error of type -1 has occurred. -1 Accordance An error of type -1 has occurred. NSRange: {33, 44}
    LogError(@"%@ %@ %@ %@ %@",
             [errorInfo valueForKey:NSAppleScriptErrorMessage],     // Accordance got an error: An error of type -1 has occurred.
             [errorInfo valueForKey:NSAppleScriptErrorNumber],      // -1
             [errorInfo valueForKey:NSAppleScriptErrorAppName],     // Accordance
             [errorInfo valueForKey:NSAppleScriptErrorBriefMessage],// An error of type -1 has occurred.
             [errorInfo valueForKey:NSAppleScriptErrorRange]);      // NSRange: {33, 44}
}

- (NSError *)errorForInvalidRange:(NSString *)verseRefs inTextName:(NSString *)textName errorCode:(NSInteger)code
{
    NSDictionary *userInfo
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"The range \"%@\" is invalid for %@.", verseRefs, textName], NSLocalizedDescriptionKey,
       @"Enter a range that is valid for the selected text name.", NSLocalizedRecoverySuggestionErrorKey,
       nil];
    NSError *error = [NSError errorWithDomain:@"BXErrorDomain" code:code userInfo:userInfo];
    return error;
}

- (NSError *)errorForVerseLimit
{
    NSDictionary *userInfo
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"Accordance returned the first 500 verses only."
        " The last verse searched was %@.", self.lastVerse.ref.stringValue], NSLocalizedDescriptionKey,
       @"Try a verse range without commas or semicolons.", NSLocalizedRecoverySuggestionErrorKey,
       nil];
    NSError *error = [NSError errorWithDomain:@"BXErrorDomain" code:BXFetchLimitError userInfo:userInfo];
    return error;
}

- (NSError *)errorForAppleScriptError:(NSDictionary *)appleScriptError
{
    NSDictionary *userInfo
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"Unable to communicate with Accordance. %@ (Error %@)",
        [appleScriptError valueForKey:NSAppleScriptErrorMessage], [appleScriptError valueForKey:NSAppleScriptErrorNumber]
        ], NSLocalizedDescriptionKey,
       @"", NSLocalizedRecoverySuggestionErrorKey,
       nil];
    NSInteger errorNumber = [[appleScriptError valueForKey:NSAppleScriptErrorNumber] integerValue];
    NSError *error = [NSError errorWithDomain:@"BXErrorDomain" code:errorNumber userInfo:userInfo];
    return error;
}

- (NSError *)errorForScriptErrorMessage:(NSString *)errMessage
{
    NSDictionary *userInfo
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [NSString stringWithFormat:@"%@", [errMessage substringFromIndex:4] ], NSLocalizedDescriptionKey,
       @"Enter a range that is valid for the selected text name.", NSLocalizedRecoverySuggestionErrorKey,
       nil];
    NSError *error = [NSError errorWithDomain:@"BXErrorDomain" code:BXFetchLimitError userInfo:userInfo];
    return error;
}


@end
