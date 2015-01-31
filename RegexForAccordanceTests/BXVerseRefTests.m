//
//  BXVerseRefTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 9/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXVerseRef.h"

@interface BXVerseRefTests : XCTestCase

@end

@implementation BXVerseRefTests

- (void)testFormatVerseRef
{
    XCTAssertEqualObjects(@"Gen 1:1", [[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1].stringValue);
    XCTAssertEqualObjects(@"Ps 3:0", [[BXVerseRef alloc] initWithBook:@"Ps" chapter:3 verse:0].stringValue);
    XCTAssertEqualObjects(@"Jude 7",   [[BXVerseRef alloc] initWithBook:@"Jude" chapter:0 verse:7].stringValue);
}

- (void)testEuropeanFormat
{
    BXVerseRef *ref = [[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1 europeanFormat:YES];
    XCTAssertEqualObjects(@"Gen 1,1", [ref stringValue]);
}

- (void)testPerformanceFormatVerseRef
{
    [self measureBlock:^{
        for (int i = 0; i < 50000; i++)
        {
            XCTAssertEqualObjects(@"Gen 1:1", [[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1].stringValue);
        }
    }];
}

@end
