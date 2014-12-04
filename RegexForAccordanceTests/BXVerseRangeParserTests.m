//
//  BXVerseRangeParserTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXVerseRangeParser.h"

@interface BXVerseRangeParserTests : XCTestCase

@end

@implementation BXVerseRangeParserTests

- (void)testRefs:(NSString *)refs expectStart:(NSString *)start expectEnd:(NSString *)end
{
    BXVerseRangeParser *p = [[BXVerseRangeParser alloc] init];
    [p parseVerseRefs:refs];
    XCTAssertEqualObjects(start, p.refRangeStart);
    XCTAssertEqualObjects(end, p.refRangeEnd);
}

- (void)testVerseRefsForEndpoint
{
    [self testRefs:@"Gen 1:1" expectStart:@"Gen 1:1" expectEnd:nil];
    [self testRefs:@"Gen 1:1,2" expectStart:@"Gen 1:1,2" expectEnd:nil];
    [self testRefs:@"Gen 1:1;Exod 3:4" expectStart:@"Gen 1:1;Exod 3:4" expectEnd:nil];
    [self testRefs:@"Gen 1:1-3, Exod 3:4" expectStart:@"Gen 1:1-3, Exod 3:4" expectEnd:nil];
    [self testRefs:@"Job - Ezek" expectStart:@"Job" expectEnd:@"Ezek"];
    [self testRefs:@"Job 1:7 - Ezek 13" expectStart:@"Job 1:7" expectEnd:@"Ezek 13"];
    [self testRefs:@"Ps 2 - 150:6" expectStart:@"Ps 2" expectEnd:@"150:6"];
    [self testRefs:@"Job" expectStart:@"Job" expectEnd:@"Job"];
    [self testRefs:@"Gen-" expectStart:@"Gen" expectEnd:nil];
    [self testRefs:@"Gen- " expectStart:@"Gen" expectEnd:@""];
    [self testRefs:@"Gen - " expectStart:@"Gen" expectEnd:@""];

    [self testRefs:@"Ps 2 - 150" expectStart:@"Ps 2" expectEnd:@"Ps 150"];
    [self testRefs:@"Jude 2 - 7" expectStart:@"Jude 2" expectEnd:@"Jude 7"];
}

@end
