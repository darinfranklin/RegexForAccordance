//
//  BXFilterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXFilterReplace.h"
#import "BXFilterSpaces.h"
#import "BXFilterTrailingSpaces.h"
#import "BXFilterHebrewNormalizeToCompositeCharacters.h"
#import "BXFilterHebrewPoints.h"
#import "BXTextLanguage.h"
#import "BXFilterGreekNormalizeToCompositeCharacters.h"
#import "BXFilterGreekDiacritics.h"
#import "BXFilterTransliterate.h"

@interface BXFilterTests : XCTestCase

@end

@implementation BXFilterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFilter
{
    BXFilterReplace *filter;
    filter = [[BXFilterReplace alloc] init];
    [filter setName:@"Replace Vowels"];
    [filter setIgnoreCase:YES];
    [filter setSearchPattern:@"[aeiou]"];
    [filter setReplacePattern:@"X"];
    XCTAssertEqualObjects(@"Xbc dXf ghX jklmnXp qrs tXv wxyz", [filter filter:@"abc def ghi jklmnop qrs tuv wxyz"]);
}

- (void)testRemoveSpacesFilter
{
    BXFilterSpaces *f = [[BXFilterSpaces alloc] init];
    XCTAssertEqualObjects(@"abcdefghi", [f filter:@"abc def ghi"]);
}

- (void)testRemoveTrailingSpacesFilter
{
    BXFilterTrailingSpaces *f = [[BXFilterTrailingSpaces alloc] init];
    XCTAssertEqualObjects(@"abc def ghi", [f filter:@"abc def ghi \t  "]);
}

- (void)testTransliterate
{
    BXFilterTransliterate *f = [[BXFilterTransliterate alloc] initWithName:@"tl" searchPattern:@"abc" replacePattern:@"ABC"];
    XCTAssertEqualObjects(@"AzByCx", [f filter:@"azbycx"]);
}

- (void)testNormalizeHebrewComposite
{
    NSString *str = @"\uFB35";
    BXFilterHebrewNormalizeToCompositeCharacters *f = [[BXFilterHebrewNormalizeToCompositeCharacters alloc] init];
    str = [f filter:str];
    XCTAssertEqualObjects(@"\u05D5\u05BC", str);
    BXFilterHebrewPoints *f2 = [[BXFilterHebrewPoints alloc] init];
    str = [f2 filter:str];
    XCTAssertEqualObjects(@"\u05D5", str);
}

- (void)testShin
{
    BXFilterHebrewNormalizeToCompositeCharacters *f = [[BXFilterHebrewNormalizeToCompositeCharacters alloc] init];
    XCTAssertEqualObjects(@"\u05E9\u05C1", [f filter:@"\uFB2A"]); // SHIN WITH SHIN DOT
    XCTAssertEqualObjects(@"\u05E9\u05C2", [f filter:@"\uFB2B"]); // SHIN WITH SIN DOT
    XCTAssertEqualObjects(@"\u05E9\u05BC\u05C1", [f filter:@"\uFB2C"]); // SHIN WITH SIN DOT AND DAGESH
    XCTAssertEqualObjects(@"\u05E9\u05BC\u05C2", [f filter:@"\uFB2D"]); // SHIN WITH SIN DOT AND DAGESH
    XCTAssertEqualObjects(@"\u05E9\u05BC", [f filter:@"\uFB49"]); // SHIN WITH DAGESH
}

- (void)testRemovePointsFromCompositeHebrewCharacters
{
    NSString *str = @"\uFB1D\uFB2A\uFB2B\uFB2C\uFB2D\uFB2E\uFB2F\uFB30\uFB31\uFB32\uFB33\uFB34\uFB35\uFB36"
    @"\uFB38\uFB39\uFB3A\uFB3B\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46\uFB47\uFB48\uFB49\uFB4A\uFB4B"
    @"\uFB4C\uFB4D\uFB4E";
    NSString *exp = @"\u05D9\u05E9\u05E9\u05E9\u05E9\u05D0\u05D0\u05D0\u05D1\u05D2\u05D3\u05D4\u05D5\u05D6"
    @"\u05D8\u05D9\u05DA\u05DB\u05DC\u05DE\u05E0\u05E1\u05E3\u05E4\u05E6\u05E7\u05E8\u05E9\u05EA\u05D5"
    @"\u05D1\u05DB\u05E4";
    BXFilterHebrewNormalizeToCompositeCharacters *f = [[BXFilterHebrewNormalizeToCompositeCharacters alloc] init];
    str = [f filter:str];
    BXFilterHebrewPoints *f2 = [[BXFilterHebrewPoints alloc] init];
    str = [f2 filter:str];
    XCTAssertEqualObjects(exp, str);
}

- (void)testTransliterateWithMulticharMap
{
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"A1", @"a",
                         @"B1", @"b",
                         @"C1", @"c",
                         nil];
    BXFilterTransliterate *f = [[BXFilterTransliterate alloc] initWithName:@"tl" searchReplaceMap:map];
    XCTAssertEqualObjects(@"A1zB1yC1x", [f filter:@"azbycx"]);
}

- (void)testMaqefIsWordBoundary
{
    NSString *str = @"בא־ת";
    id<BXFilter> f2 = [[BXFilterReplace alloc] initWithName:@"Keep First Word Only"
                                              searchPattern:@"^(\\w*).*$" replacePattern:@"$1" ignoreCase:NO];
    str = [f2 filter:str];
    XCTAssertEqualObjects(@"בא", str);
}

- (void)testHebrewMaqaf
{
    NSString *str = @"עַל־פְּנֵ֣י";
    id<BXFilter> firstWordOnlyFilter = [[BXFilterReplace alloc] initWithName:@"Keep First Word Only"
                                                               searchPattern:@"^(\\w+).*$" replacePattern:@"$1" ignoreCase:NO];
    NSString *result = [firstWordOnlyFilter filter:str];
    XCTAssertEqualObjects(@"עַל", result);
}

- (void)testGreekCompositeCharacters
{
    NSString *str = @"\u0386\u0388\u0389\u038A\u038C\u038E\u038F\u0390" // CAPITAL + TONOS
    "\u03AA\u03AB" // DIALYTIKA
    "\u03AC\u03AD\u03AE\u03AF\u03B0" // SMALL + TONOS
    "\u03CA\u03CB" // SMALL + DIALYTIKA
    "\u03CC\u03CD\u03CE"; // SMALL + TONOS
    NSString *exp = @"\u0391\u0301\u0395\u0301\u0397\u0301\u0399\u0301\u039F\u0301\u03A5\u0301\u03A9\u0301\u03B9\u0308\u0301"
    "\u0399\u0308\u03A5\u0308"
    "\u03B1\u0301\u03B5\u0301\u03B7\u0301\u03B9\u0301\u03C5\u0308\u0301"
    "\u03B9\u0308\u03C5\u0308"
    "\u03BF\u0301\u03C5\u0301\u03C9\u0301";
    NSString *act = [[[BXFilterGreekNormalizeToCompositeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekCompositeCharactersMore
{
    // [α-ωΑ-Ωϊϋ] are the only characters in [\u0370-\u03FF] that Accordance has in GNT-T
    NSString *str = @"ϊϋ";
    XCTAssertEqualObjects(@"\u03CA\u03CB", str);
    XCTAssertEqual(2, str.length);
    NSLog(@"%@ %ld =%04x%04x", str, str.length, [str characterAtIndex:0], [str characterAtIndex:1]);
    NSString *exp = @"\u03B9\u0308\u03C5\u0308";
    NSString *act = [[[BXFilterGreekNormalizeToCompositeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekDiacriticsFilterDoesNotRemoveNonDiacritics
{
    // iota subscript 0345 matches iota 03B9
    NSString *str = @"αβγδεζηθικλμνξοπρστυφχψω ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ;.,;·᾿¶\u2014ῳ";
    BXFilterGreekDiacritics *f = [[BXFilterGreekDiacritics alloc] init];
    XCTAssertEqualObjects(@"[" GRK_DIACRITICS "]", f.searchPattern);
    XCTAssertEqualObjects(@"", f.replacePattern);
    NSString *act = [f filter:str];
    XCTAssertEqualObjects(str, act);
}

- (void)normalizeSingleCharacter:(NSString *)str expected:(NSString *)exp
{
    XCTAssertEqual(1, str.length);
    NSLog(@"%@ %ld =%04X", str, str.length, [str characterAtIndex:0]);
    NSString *act = [[[BXFilterGreekNormalizeToCompositeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekCompositeCharacters1F00Block
{
    [self normalizeSingleCharacter:@"\u1F08" expected:@"\u0391\u0313"]; // Alpha with psili -> Alpha psili
    [self normalizeSingleCharacter:@"\u1F71" expected:@"\u03B1\u0301"]; // alpha with oxia -> alpha acute
    [self normalizeSingleCharacter:@"\u03AC" expected:@"\u03B1\u0301"]; // alpha with tonos -> alpha acute
    [self normalizeSingleCharacter:@"\u1F73" expected:@"\u03B5\u0301"]; // epsilon with oxia -> epsilon acute
    [self normalizeSingleCharacter:@"\u1F75" expected:@"\u03B7\u0301"]; // eta with oxia -> eta acute
    [self normalizeSingleCharacter:@"\u03AE" expected:@"\u03B7\u0301"]; // eta with tonos -> eta acute
    [self normalizeSingleCharacter:@"\u1F77" expected:@"\u03B9\u0301"]; // iota with oxia -> iota acute
    [self normalizeSingleCharacter:@"\u03CA" expected:@"\u03B9\u0308"]; // iota with dialytica -> iota dialytica
    [self normalizeSingleCharacter:@"\u1FD3" expected:@"\u03B9\u0308\u0301"]; // iota with dialytica and oxia -> iota dialytica acute
    [self normalizeSingleCharacter:@"\u1F79" expected:@"\u03BF\u0301"]; // omicron with oxia -> omicron acute
    [self normalizeSingleCharacter:@"\u1F7B" expected:@"\u03C5\u0301"]; // upsilon with oxia -> upsilon acute
    [self normalizeSingleCharacter:@"\u03CB" expected:@"\u03C5\u0308"]; // upsilon with dialytica -> upsilon dialytica
    [self normalizeSingleCharacter:@"\u1FE3" expected:@"\u03C5\u0308\u0301"]; // upsilon with dialytica and oxia -> upsilon dialytica acute
    [self normalizeSingleCharacter:@"\u03CE" expected:@"\u03C9\u0301"]; // omega with tonos -> omega acute
    [self normalizeSingleCharacter:@"\u1F7D" expected:@"\u03C9\u0301"]; // omega with oxia -> omega acute
}

- (void)testGreekCompositeCharacters0370Block
{
    // \u03AF iota with tonos - as entered with Greek keyboard
    [self normalizeSingleCharacter:@"\u03AF" expected:@"\u03B9\u0301"];
}

- (void)testIfTextFieldChangesCompositeCharacters
{
    NSTextField *tf = [[NSTextField alloc] init];
    tf.stringValue = @"\u03B9\u0301";
    XCTAssertEqualObjects(@"\u03B9\u0301", tf.stringValue);
}

@end
