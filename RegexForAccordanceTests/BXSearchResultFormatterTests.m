//
//  BXSearchResultFormatterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXSearchResultFormatter.h"
#import "BXLineParser.h"

@interface BXSearchResultFormatterTests : XCTestCase

@end

@implementation BXSearchResultFormatterTests

- (void)testFormatEnglish
{
    BXFontSelector *fontSelector = [[BXFontSelector alloc] init];
    BXSearchResultFormatter *formatter = [[BXSearchResultFormatter alloc] initWithFontSelector:fontSelector];
    formatter.textName = @"KJV";
    formatter.writingDirection = NSWritingDirectionLeftToRight;
    formatter.verseRefFont = fontSelector.verseRefFont;
    formatter.verseTextFont = fontSelector.latinFont;
    formatter.hitTextFont = fontSelector.latinFont;

    NSString *verseLine = @"Gen 1:1 In the beginning, God created the heavens and the earth.";
    BXSearchResult *result = [[BXSearchResult alloc] init];
    result.verse = [[[BXLineParser alloc] init] verseForLine:verseLine];
    NSRange hitRange = NSMakeRange(3, 3);
    NSTextCheckingResult *tcr = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&hitRange count:1 regularExpression:nil];
    result.hits = [NSArray arrayWithObjects:tcr, nil];
    [fontSelector setCurrentFontsForLanguageScriptTag:@"Latn"];
    NSAttributedString *decoratedLine = [formatter formatSearchResult:result];
    XCTAssertEqualObjects(@"Gen"NBSP"1:1"NBSP"In the beginning, God created the heavens and the earth.", decoratedLine.string);

    NSRange effectiveRange;
    NSDictionary *attrs;

    // First range is verse ref, not including the space after it
    attrs = [decoratedLine attributesAtIndex:6 effectiveRange:&effectiveRange];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(0, 7), effectiveRange), @"actual: %ld, %ld", effectiveRange.location, effectiveRange.length);
    XCTAssertEqualObjects(@"Gen"NBSP"1:1", [decoratedLine.string substringWithRange:effectiveRange]);
    XCTAssertEqualObjects(@"accord://read/KJV?Gen%201:1", [[attrs objectForKey:NSLinkAttributeName] absoluteString]);
    XCTAssertEqualObjects(fontSelector.verseRefFont, [attrs objectForKey:NSFontAttributeName]);
    XCTAssertEqual(2, attrs.count);

    // Next range is the NBSP after the verse, which we won't check here
    
    // Next range is the first part of the text, up to the first hit ("the")
    attrs = [decoratedLine attributesAtIndex:8 effectiveRange:&effectiveRange];
    XCTAssertEqualObjects(@"In ", [decoratedLine.string substringWithRange:effectiveRange]);
    XCTAssertTrue(NSEqualRanges(NSMakeRange(8, 3), effectiveRange), @"actual: %ld, %ld", effectiveRange.location, effectiveRange.length);
    //XCTAssertEqualObjects([NSNumber numberWithInt:0], [attrs objectForKey:NSUnderlineStyleAttributeName]);
    XCTAssertEqualObjects(fontSelector.latinFont, [attrs objectForKey:NSFontAttributeName]);
    XCTAssertEqual(1, attrs.count);

    // Next range is the word "the", and should be red
    attrs = [decoratedLine attributesAtIndex:11 effectiveRange:&effectiveRange];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(11, 3), effectiveRange), @"actual: %ld, %ld", effectiveRange.location, effectiveRange.length);
    XCTAssertEqualObjects(@"the", [decoratedLine.string substringWithRange:effectiveRange]);
    XCTAssertNotNil([attrs objectForKey:NSForegroundColorAttributeName]);
    XCTAssertEqualObjects(fontSelector.hitFont, [attrs objectForKey:NSFontAttributeName]);
    XCTAssertEqual(2, attrs.count);
    
    // Final range is the rest of the line
    attrs = [decoratedLine attributesAtIndex:15 effectiveRange:&effectiveRange];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(14, 50), effectiveRange), @"actual: %ld, %ld", effectiveRange.location, effectiveRange.length);
    XCTAssertEqualObjects(@" beginning, God created the heavens and the earth.", [decoratedLine.string substringWithRange:effectiveRange]);
    //XCTAssertEqualObjects([NSNumber numberWithInt:0], [attrs objectForKey:NSUnderlineStyleAttributeName]);
    XCTAssertEqualObjects(fontSelector.latinFont, [attrs objectForKey:NSFontAttributeName]);
    XCTAssertEqual(1, attrs.count);
}

- (void)testFormatHebrew
{
    BXFontSelector *fontSelector = [[BXFontSelector alloc] init];
    BXSearchResultFormatter *formatter = [[BXSearchResultFormatter alloc] initWithFontSelector:fontSelector];
    [fontSelector setCurrentFontsForLanguageScriptTag:@SCRIPT_TAG_HEBREW];
    formatter.textName = @"HMT-W4";
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    formatter.verseRefFont = fontSelector.verseRefFont;
    formatter.verseTextFont = fontSelector.hebrewFont;
    formatter.hitTextFont = fontSelector.hebrewFont;
    NSString *verseLine = @"Gen 1:1 בְּרֵאשִׁ֖ית בָּרָ֣א אֱלֹהִ֑ים אֵ֥ת הַשָּׁמַ֖יִם וְאֵ֥ת הָאָֽרֶץ׃";
    NSString *expectedLine = @"" LRE "Gen" NBSP "1:1" PDF RLO NBSP "בְּרֵאשִׁ֖ית בָּרָ֣א אֱלֹהִ֑ים אֵ֥ת הַשָּׁמַ֖יִם וְאֵ֥ת הָאָֽרֶץ׃";
    BXSearchResult *result = [[BXSearchResult alloc] init];
    result.verse = [[[BXLineParser alloc] init] verseForLine:verseLine];
    NSString *hitWord = @"בָּרָ֣א";
    NSRange hitWordRange = [verseLine rangeOfString:hitWord]; // second word
    NSTextCheckingResult *tcr = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&hitWordRange count:1 regularExpression:nil];
    result.hits = [NSArray arrayWithObjects:tcr, nil];
    [fontSelector setCurrentFontsForLanguageScriptTag:@"Hebr"];
    NSAttributedString *decoratedLine = [formatter formatSearchResult:result];
    XCTAssertEqualObjects(expectedLine, decoratedLine.string);
    NSRange effectiveRange;
    NSDictionary *attrs;

    // First range is verse ref, not including the space after it, and not including LRE and PDF
    attrs = [decoratedLine attributesAtIndex:7 effectiveRange:&effectiveRange];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(1, 7), effectiveRange), @"actual: %ld, %ld", effectiveRange.location, effectiveRange.length);
    XCTAssertEqualObjects(@"Gen" NBSP "1:1", [decoratedLine.string substringWithRange:effectiveRange]);
    XCTAssertEqualObjects(@"accord://read/HMT-W4?Gen%201:1", [[attrs objectForKey:NSLinkAttributeName] absoluteString]);
    XCTAssertEqualObjects(fontSelector.verseRefFont, [attrs objectForKey:NSFontAttributeName]);
    XCTAssertEqual(2, attrs.count);
}

- (void)testHitRangeInFormattedSearchResult
{
    BXSearchResultFormatter *formatter = [[BXSearchResultFormatter alloc] init];
    NSString *line = @"Foo 1:1 Abc";
    BXSearchResult *searchResult = [[BXSearchResult alloc] init];
    searchResult.verse = [[[BXLineParser alloc] init] verseForLine:line];
    NSRange range;
    
    formatter.includeReference = NO;
    formatter.writingDirection = NSWritingDirectionLeftToRight;
    range = [formatter hitRange:NSMakeRange(0, 3) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(8, 3), range), @"actual: %ld, %ld", range.location, range.length);
    
    formatter.includeReference = NO;
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    range = [formatter hitRange:NSMakeRange(0, 3) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(11, 3), range), @"actual: %ld, %ld", range.location, range.length);

    formatter.includeReference = YES;
    formatter.writingDirection = NSWritingDirectionLeftToRight;
    range = [formatter hitRange:NSMakeRange(0, 11) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(0, 11), range), @"actual: %ld, %ld", range.location, range.length);
    
    formatter.includeReference = YES;
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    range = [formatter hitRange:NSMakeRange(0, 11) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(1, 13), range), @"actual: %ld, %ld", range.location, range.length);
    
    formatter.includeReference = YES;
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    range = [formatter hitRange:NSMakeRange(0, 3) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(1, 3), range), @"actual: %ld, %ld", range.location, range.length);
    
    formatter.includeReference = YES;
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    range = [formatter hitRange:NSMakeRange(6, 3) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(7, 5), range), @"actual: %ld, %ld", range.location, range.length);
    
    formatter.includeReference = YES;
    formatter.writingDirection = NSWritingDirectionRightToLeft;
    range = [formatter hitRange:NSMakeRange(8, 3) inFormattedSearchResult:searchResult];
    XCTAssertTrue(NSEqualRanges(NSMakeRange(11, 3), range), @"actual: %ld, %ld", range.location, range.length);

}


@end
