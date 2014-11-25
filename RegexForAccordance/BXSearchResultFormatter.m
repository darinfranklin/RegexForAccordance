//
//  BXSearchResultFormatter.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchResultFormatter.h"
#import "BXAccVerseURL.h"

@interface BXSearchResultFormatter ()
@property BXFontSelector *fontSelector;
@end

@implementation BXSearchResultFormatter

- (id)initWithFontSelector:(BXFontSelector *)fontSelector
{
    if (self = [super init])
    {
        self.fontSelector = fontSelector;
    }
    return self;
}

- (NSAttributedString *)formatSearchResult:(BXSearchResult *)searchResult
{
    self.verseRefFont = self.fontSelector.verseRefFont;
    self.verseTextFont = self.fontSelector.plainFont;
    self.hitTextFont = self.fontSelector.hitFont;
    NSString *refString = searchResult.verse.ref.stringValue;
    NSRange refRange = NSMakeRange(0, refString.length);
    NSUInteger refFormattedLength = refString.length;
    NSUInteger spaceLength = 1;
    NSString *displayLineFormat;
    if (self.writingDirection == NSWritingDirectionRightToLeft)
    {
        displayLineFormat = @LRE @"%@" PDF    RLO NBSP @"%@";
        refRange.location = 1;
        refFormattedLength += 2;
        spaceLength += 1;
    }
    else
    {
        displayLineFormat = @"%@" NBSP @"%@";
    }
    
    NSString *displayRef = [refString stringByReplacingOccurrencesOfString:@" " withString:@NBSP];
    NSString *displayLine = [NSString stringWithFormat:displayLineFormat, displayRef, searchResult.verse.text];
    NSURL *accVerseURL = [[[BXAccVerseURL alloc] init] urlForVerseRef:refString inText:self.textName];
    NSMutableAttributedString *decoratedDisplayLine = [[NSMutableAttributedString alloc] initWithString:displayLine];
    
    // Verse Reference Font
    NSRange rangeOfRefAndSpace = NSMakeRange(refRange.location, refRange.length + spaceLength);
    [decoratedDisplayLine addAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         self.verseRefFont, NSFontAttributeName,
                                         nil]
                                  range:rangeOfRefAndSpace];
    
    // Verse Reference Link
    [decoratedDisplayLine addAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         accVerseURL, NSLinkAttributeName,
                                         nil]
                                  range:refRange];
    
    // Verse Text Font
    [decoratedDisplayLine addAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         self.verseTextFont, NSFontAttributeName,
                                         nil]
                                  range:NSMakeRange(0 + refFormattedLength + spaceLength,
                                                    decoratedDisplayLine.length - refFormattedLength - spaceLength)];

    
    // Hit Font and Color
    for (NSTextCheckingResult *hit in searchResult.hits)
    {
        if (hit.range.length > 0)
        {
            NSRange range = hit.range;
            range = [self hitRange:range inFormattedSearchResult:searchResult];
            // Don't start an attribute in the middle of a composed character sequence. SBOD!
            range = [decoratedDisplayLine.string rangeOfComposedCharacterSequencesForRange:range];

            // Hit Font
            if (range.location >= NSMaxRange(refRange))
            {
                [decoratedDisplayLine addAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                     self.hitTextFont, NSFontAttributeName,
                                                     nil]
                                              range:range];
            }
            
            // Hit Color
            [decoratedDisplayLine addAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                 self.fontSelector.hitTextColor, NSForegroundColorAttributeName,
                                                 nil]
                                          range:range];
            //  (color does not change for verse reference links)
        }
    }
     
    return decoratedDisplayLine;
}

- (NSRange)hitRange:(NSRange)hitRange inFormattedSearchResult:(BXSearchResult *)searchResult
{
    NSRange range = hitRange;
    NSString *refString = searchResult.verse.ref.stringValue;
    NSRange refRange = NSMakeRange(0, refString.length);

    // Adjust hit range to match formatted display line
    if (self.includeReference)
    {
        if (self.writingDirection == NSWritingDirectionRightToLeft)
        {
            // offset for LRE PDF RLO
            if (range.location < NSMaxRange(refRange))
            {
                range.location += 1; // LRE
                if (NSMaxRange(range) > refRange.length)
                {
                    range.length += 2; // PDF RLO
                }
            }
            else
            {
                range.location += 3; // LRE PDF RLO
            }
        }
    }
    else
    {
        // search did not include reference, so offset by length of reference and space
        range.location += refRange.length + 1;
        if (self.writingDirection == NSWritingDirectionRightToLeft)
        {
            range.location += 3; // LRE PDF RLO
        }
    }
    return range;
}


- (void)setWritingDirectionForLanguageScriptTag:(NSString *)scriptTag
{
    if ([scriptTag isEqualToString:@SCRIPT_TAG_HEBREW])
    {
        self.writingDirection =  NSWritingDirectionRightToLeft;
    }
    else
    {
        self.writingDirection =  NSWritingDirectionLeftToRight;
    }
}

@end
