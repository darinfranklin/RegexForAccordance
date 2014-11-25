//
//  BXFontSelectorTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/23/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXFontSelector.h"

@interface BXFontSelectorTests : XCTestCase

@end

@implementation BXFontSelectorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFonts
{
    BXFontSelector *fontSelector = [[BXFontSelector alloc] init];
    [fontSelector setCurrentFontsForLanguageScriptTag:@"Latn"];
    XCTAssertEqualObjects(fontSelector.latinFont, fontSelector.plainFont);

    [fontSelector setCurrentFontsForLanguageScriptTag:@"Hebr"];
    XCTAssertEqualObjects(fontSelector.hebrewFont, fontSelector.plainFont);
    
    [fontSelector setCurrentFontsForLanguageScriptTag:@"Grek"];
    XCTAssertEqualObjects(fontSelector.greekFont, fontSelector.plainFont);
    
    [fontSelector setCurrentFontsForLanguageScriptTag:@"Unkn"];
    XCTAssertEqualObjects(fontSelector.latinFont, fontSelector.plainFont);
}

@end
