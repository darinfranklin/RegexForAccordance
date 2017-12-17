//
//  BXDocument.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/23/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXDocument.h"
#import "BXSearchWindowController.h"

NSString *const IgnoreCase = @"IgnoreCase";
NSString *const IncludeReference = @"IncludeReference";
NSString *const SearchScope = @"SearchScope";
NSString *const LeftToRightOverride = @"LeftToRightOverride";
NSString *const GroupByBook = @"GroupByBook";
NSString *const SearchPattern = @"SearchPattern";
NSString *const SearchFieldFont = @"SearchFieldFont";
NSString *const VerseRange = @"VerseRange";
NSString *const TextName = @"TextName";
NSString *const RemoveSpaces = @"RemoveSpaces";
NSString *const RemoveTrailingSpaces = @"RemoveTrailingSpaces";
NSString *const RemovePilcrows = @"RemovePilcrows";
NSString *const RemoveBracketedText = @"RemoveBracketedText";
NSString *const HebrewRemoveCantillation = @"HebrewRemoveCantillation";
NSString *const HebrewRemovePoints = @"HebrewRemovePoints";
NSString *const HebrewRemovePunctuation = @"HebrewRemovePunctuation";
NSString *const GreekRemoveDiacritics = @"GreekRemoveDiacritics";
NSString *const GreekRemovePunctuation = @"GreekRemovePunctuation";

@implementation BXDocument
{
    BXSearchWindowController *_windowController;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)isDocumentEdited
{
    if ([self.displayName hasPrefix:@"Untitled"]
        && [[NSUserDefaults standardUserDefaults] boolForKey:@"NoPromptForUnsaved"])
    {
        return NO;
    }
    else
    {
        return [super isDocumentEdited];
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.searchSettings = [[BXSearchSettings alloc] init];
        [self loadDefaultValues];
    }
    return self;
}

- (BXSearchWindowController *)windowController
{
    if (_windowController == nil)
    {
        _windowController = [[BXSearchWindowController alloc] init];
    }
    return _windowController;
}

- (void)makeWindowControllers
{
    [self addWindowController:[self windowController]];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

- (void)loadDefaultValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.searchSettings.ignoreCase = [defaults boolForKey:IgnoreCase];
    self.searchSettings.includeReference = [defaults boolForKey:IncludeReference];
    [self.searchSettings setSearchScopeString:[defaults stringForKey:SearchScope]];
    self.searchSettings.leftToRightOverride = [defaults boolForKey:LeftToRightOverride];

    self.searchSettings.removeSpaces = [defaults boolForKey:RemoveSpaces];
    self.searchSettings.removeTrailingSpaces = [defaults boolForKey:RemoveTrailingSpaces];
    self.searchSettings.removePilcrows = [defaults boolForKey:RemovePilcrows];
    self.searchSettings.removeBracketedText = [defaults boolForKey:RemoveBracketedText];
    self.searchSettings.hebrewRemoveCantillation = [defaults boolForKey:HebrewRemoveCantillation];
    self.searchSettings.hebrewRemovePoints = [defaults boolForKey:HebrewRemovePoints];
    self.searchSettings.hebrewRemovePunctuation = [defaults boolForKey:HebrewRemovePunctuation];
    self.searchSettings.greekRemoveDiacritics = [defaults boolForKey:GreekRemoveDiacritics];
    self.searchSettings.greekRemovePunctuation = [defaults boolForKey:GreekRemovePunctuation];
}

- (void)loadDocumentContents:(NSDictionary *)documentContents
{
    if (documentContents != nil)
    {
        NSNumber *number;
        if (nil != (number = [documentContents objectForKey:IgnoreCase]))
        {
            self.searchSettings.ignoreCase = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:IncludeReference]))
        {
            self.searchSettings.includeReference = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:GroupByBook]))
        {
            self.searchSettings.groupByBook = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:LeftToRightOverride]))
        {
            self.searchSettings.leftToRightOverride = number.boolValue;
        }
        NSString *string;
        if (nil != (string = [documentContents objectForKey:TextName]))
        {
            self.searchSettings.textName = string;
            LogDebug(@"textName=%@", self.searchSettings.textName);
        }
        if (nil != (string = [documentContents objectForKey:VerseRange]))
        {
            self.searchSettings.verseRange = string;
        }
        if (nil != (string = [documentContents objectForKey:SearchScope]))
        {
    		[self.searchSettings setSearchScopeString:string];
        }
        if (nil != (string = [documentContents objectForKey:SearchPattern]))
        {
            self.searchSettings.searchPattern = string;
        }
        if (nil != (string = [documentContents objectForKey:SearchFieldFont]))
        {
            self.searchSettings.searchFieldFont = string;
        }

        // Filters
        if (nil != (number = [documentContents objectForKey:RemoveSpaces]))
        {
            self.searchSettings.removeSpaces = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:RemoveTrailingSpaces]))
        {
            self.searchSettings.removeTrailingSpaces = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:RemovePilcrows]))
        {
            self.searchSettings.removePilcrows = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:RemoveBracketedText]))
        {
            self.searchSettings.removeBracketedText = number.boolValue;
        }
        
        if (nil != (number = [documentContents objectForKey:HebrewRemoveCantillation]))
        {
            self.searchSettings.hebrewRemoveCantillation = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:HebrewRemovePoints]))
        {
            self.searchSettings.hebrewRemovePoints = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:HebrewRemovePunctuation]))
        {
            self.searchSettings.hebrewRemovePunctuation = number.boolValue;
        }
        
        if (nil != (number = [documentContents objectForKey:GreekRemoveDiacritics]))
        {
            self.searchSettings.greekRemoveDiacritics = number.boolValue;
        }
        if (nil != (number = [documentContents objectForKey:GreekRemovePunctuation]))
        {
            self.searchSettings.greekRemovePunctuation = number.boolValue;
        }
    }
}

- (void)setObject:(id)object forKey:(NSString *)key inDictionary:(NSMutableDictionary *)dict
{
    if (object != nil)
    {
        [dict setObject:object forKey:key];
    }
}

- (NSDictionary *)searchSettingsDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.groupByBook] forKey:GroupByBook];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.ignoreCase] forKey:IgnoreCase];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.includeReference] forKey:IncludeReference];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.leftToRightOverride] forKey:LeftToRightOverride];
    [self setObject:self.searchSettings.searchPattern forKey:SearchPattern inDictionary:dict];
    [self setObject:self.searchSettings.verseRange forKey:VerseRange inDictionary:dict];
    [self setObject:self.searchSettings.textName forKey:TextName inDictionary:dict];
    [self setObject:self.searchSettings.searchFieldFont forKey:SearchFieldFont inDictionary:dict];
    [self setObject:self.searchSettings.searchScopeString forKey:SearchScope inDictionary:dict];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.removeSpaces] forKey:RemoveSpaces];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.removeTrailingSpaces] forKey:RemoveTrailingSpaces];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.removePilcrows] forKey:RemovePilcrows];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.removeBracketedText] forKey:RemoveBracketedText];
    
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.hebrewRemoveCantillation] forKey:HebrewRemoveCantillation];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.hebrewRemovePoints] forKey:HebrewRemovePoints];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.hebrewRemovePunctuation] forKey:HebrewRemovePunctuation];
    
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.greekRemoveDiacritics] forKey:GreekRemoveDiacritics];
    [dict setObject:[NSNumber numberWithBool:self.searchSettings.greekRemovePunctuation] forKey:GreekRemovePunctuation];
    return dict;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    LogDebug(@"Saving document \"%@\" %@", self.displayName, typeName);
    NSDictionary *documentContents = [self searchSettingsDictionary];
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:documentContents
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:outError];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    LogDebug(@"Reading document \"%@\" %@", self.displayName, typeName);
    NSDictionary *documentContents = [NSPropertyListSerialization propertyListWithData:data
                                                                               options:0
                                                                                format:NULL
                                                                                 error:outError];
    [self loadDocumentContents:documentContents];
    return documentContents != nil;
}

- (BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    BOOL success = [super revertToContentsOfURL:url ofType:typeName error:outError];
    LogDebug(@"reverted=%@", success ? @"YES" : @"NO");
    if (success)
    {
        [self.windowController documentDidChange];
    }
    return success;
}

@end
