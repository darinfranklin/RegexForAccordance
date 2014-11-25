//
//  BXSearchFieldFormatter.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 9/1/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchFieldFormatter.h"
#import "BXTextLanguage.h"

@implementation BXSearchFieldFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj
             forString:(NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error
{
    *obj = string;
    return YES;
}

- (NSString *)editingStringForObjectValue:(id)obj
{
    NSString *string = obj;
    if (string != nil)
    {
        string = [self reformatString:string];
    }
    return string;
}

- (NSString *)stripLRO:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@LRO withString:@""];
}

- (NSString *)reformatString:(NSString *)string
{
    string = [self stripLRO:string];
    if (self.leftToRightOverride)
    {
        string = [@LRO stringByAppendingString:string];
    }
    return string;
}

- (NSString *)stringForObjectValue:(id)obj
{
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *string = obj;
        return string;
        //return [self stripLRO:string];
    }
    return nil;
}

/* Keep LRO at the front and don't move the cursor. */
- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString *__autoreleasing *)error
{
    NSString *newString = *partialStringPtr;
    BOOL isValid = YES;
    if (self.leftToRightOverride)
    {
        NSRange rangeOfLRO = [*partialStringPtr rangeOfString:@LRO];
        if ( rangeOfLRO.location != NSNotFound)
        {
            if (rangeOfLRO.location > 0)
            {
                isValid = NO;
                newString = [self reformatString:*partialStringPtr];
                if (proposedSelRangePtr->location < rangeOfLRO.location + 1)
                {
                    *proposedSelRangePtr = NSMakeRange(rangeOfLRO.location + 1, 0);
                }
            }
        }
        else
        {
            isValid = NO;
            newString = [self reformatString:*partialStringPtr];
            NSUInteger diff = newString.length - [*partialStringPtr length];
            *proposedSelRangePtr = NSMakeRange(proposedSelRangePtr->location + diff, proposedSelRangePtr->length);
        }
    }
    *partialStringPtr = newString;
    return isValid;
}


@end
