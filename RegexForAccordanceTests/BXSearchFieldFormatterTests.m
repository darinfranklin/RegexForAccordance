//
//  BXSearchFieldFormatterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/28/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXSearchFieldFormatter.h"


@interface BXSearchFieldFormatterTests : XCTestCase

@end

@implementation BXSearchFieldFormatterTests

- (void)testAddLRO
{
    BXSearchFieldFormatter *formatter = [[BXSearchFieldFormatter alloc] init];
    formatter.leftToRightOverride = YES;
    XCTAssertEqualObjects(@LRO, [formatter editingStringForObjectValue:@""]);
    XCTAssertEqualObjects(@LRO @"a", [formatter editingStringForObjectValue:@"a"]);
    XCTAssertEqualObjects(@LRO @"ab", [formatter editingStringForObjectValue:@"ab"]);
    XCTAssertEqualObjects(@LRO @"a", [formatter editingStringForObjectValue:@LRO @"a"]);
}


- (void)testRemoveLRO
{
    BXSearchFieldFormatter *formatter = [[BXSearchFieldFormatter alloc] init];
    XCTAssertEqualObjects(@"", [formatter editingStringForObjectValue:@""]);
    XCTAssertEqualObjects(@"a", [formatter editingStringForObjectValue:@"a"]);
    XCTAssertEqualObjects(@"", [formatter editingStringForObjectValue:@LRO]);
    XCTAssertEqualObjects(@"", [formatter editingStringForObjectValue:@LRO @""]);
    XCTAssertEqualObjects(@"a", [formatter editingStringForObjectValue:@LRO @"a"]);
    XCTAssertEqualObjects(@"", [formatter editingStringForObjectValue:@LRO @LRO]);
    XCTAssertEqualObjects(@"ab", [formatter editingStringForObjectValue:@LRO @LRO @LRO @LRO @"ab"]);
}

- (void)testPartialString:(NSString *)partialString proposedRange:(NSRange)proposedRange
           expectedString:(NSString *)expectedString expectedRange:(NSRange)expectedRange
{
    BOOL expectedIsValid = [expectedString isEqualToString:partialString];
    NSString *errorString;
    BXSearchFieldFormatter *formatter = [[BXSearchFieldFormatter alloc] init];
    formatter.leftToRightOverride = YES;
    BOOL isValid = [formatter isPartialStringValid:&partialString
                             proposedSelectedRange:&proposedRange
                                    originalString:@""
                             originalSelectedRange:NSMakeRange(0, 0)
                                  errorDescription:&errorString];
    XCTAssertEqual(expectedIsValid, isValid);
    XCTAssertEqualObjects(expectedString, partialString);
    XCTAssertTrue(NSEqualRanges(expectedRange, proposedRange),
                  @"expected (%ld,%ld); actual (%ld,%ld)",
                  expectedRange.location, expectedRange.length,
                  proposedRange.location, proposedRange.length);
    XCTAssertNil(errorString);
}

- (void)testPartialStringInsertCharBeforeLRO
{
    [self testPartialString:@"a" LRO @"bc" proposedRange:NSMakeRange(1, 0)
             expectedString:@LRO @"abc" expectedRange:NSMakeRange(2, 0)];
}

- (void)testPartialStringPasteCharsBeforeLRO
{
    [self testPartialString:@"ab" LRO @"c" proposedRange:NSMakeRange(2, 0)
             expectedString:@LRO @"abc" expectedRange:NSMakeRange(3, 0)];
}

- (void)testPartialStringPasteWholeString
{
    [self testPartialString:@"ab" LRO @"c" proposedRange:NSMakeRange(4, 0)
             expectedString:@LRO @"abc" expectedRange:NSMakeRange(4, 0)];
}

- (void)testPartialStringLROMissing
{
    [self testPartialString:@"abc" proposedRange:NSMakeRange(3, 0)
             expectedString:@LRO @"abc" expectedRange:NSMakeRange(4, 0)];
}

@end
