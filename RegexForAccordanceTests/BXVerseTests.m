//
//  BXVerseTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 11/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BXVerse.h"

@interface BXVerseTests : XCTestCase

@end

@implementation BXVerseTests

- (void)testSearchText
{
    BXVerse *verse = [[BXVerse alloc] init];
    verse.ref = [[BXVerseRef alloc] initWithBook:@"Cocoa" chapter:1 verse:23];
    verse.text = @"And, lo, another unit test. And it came to pass.";
    XCTAssertEqualObjects(@"Cocoa 1:23 And, lo, another unit test. And it came to pass.", [verse textIncludingReference:YES]);
    XCTAssertEqualObjects(@"And, lo, another unit test. And it came to pass.", [verse textIncludingReference:NO]);
}

@end
