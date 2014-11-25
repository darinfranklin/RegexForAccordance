//
//  BXTextLanguageTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/14/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXTextLanguage.h"

@interface BXTextLanguageTests : XCTestCase
@end

@implementation BXTextLanguageTests
{
    BXTextLanguage *lang;
}

- (void)setUp
{
    [super setUp];
    lang = [[BXTextLanguage alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTextLanguage
{
    XCTAssertEqualObjects(@SCRIPT_TAG_LATIN, [lang scriptTagForString:@""]);
    XCTAssertEqualObjects(@SCRIPT_TAG_LATIN, [lang scriptTagForString:@"abc"]);
    XCTAssertEqualObjects(@SCRIPT_TAG_HEBREW, [lang scriptTagForString:@"אבג"]);
    XCTAssertEqualObjects(@SCRIPT_TAG_GREEK, [lang scriptTagForString:@"αβγ"]);

    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:@""]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:@"abc"]);
    XCTAssertEqual(NSWritingDirectionRightToLeft, [lang writingDirectionForString:@"אבג"]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:@"αβγ"]);
}

- (void)testEnglish
{
    NSString *text = @"In the beginning God created the heaven and the earth.";
    XCTAssertEqualObjects(@"Latn", [lang scriptTagForString:text]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:text]);
}

- (void)testLatin
{
    NSString *text = @"in principio creavit Deus caelum et terram";
    XCTAssertEqualObjects(@"Latn", [lang scriptTagForString:text]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:text]);
}

- (void)testHebrew
{
    NSString *text = @"בְּרֵאשִׁ֖ית בָּרָ֣א אֱלֹהִ֑ים אֵ֥ת הַשָּׁמַ֖יִם וְאֵ֥ת הָאָֽרֶץ׃";
    XCTAssertEqualObjects(@"Hebr", [lang scriptTagForString:text]);
    XCTAssertEqual(NSWritingDirectionRightToLeft, [lang writingDirectionForString:text]);
}

- (void)testGreek
{
    NSString *text = @"Ἐν ἀρχῇ ἐποίησεν ὁ θεὸς τὸν οὐρανὸν καὶ τὴν γῆν.";
    XCTAssertEqualObjects(@"Grek", [lang scriptTagForString:text]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:text]);
}

- (void)testDefaultIsEnglish
{
    NSString *text = @"";
    XCTAssertEqualObjects(@"Latn", [lang scriptTagForString:text]);
    XCTAssertEqual(NSWritingDirectionLeftToRight, [lang writingDirectionForString:text]);
}

@end
