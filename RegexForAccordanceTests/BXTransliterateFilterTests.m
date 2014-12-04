//
//  BXTransliterateFilterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXFilterTransliterate.h"

@interface BXTransliterateFilterTests : XCTestCase

@end

@implementation BXTransliterateFilterTests

- (void)testFilter
{
    BXFilterTransliterate *filter;
    filter = [[BXFilterTransliterate alloc] initWithName:@"Uppercase Vowels" searchPattern:@"[aeiou]" replacePattern:@"{AEIOU}"];
    XCTAssertEqualObjects(@"Abc {dEf} ghI jklmnOp qrs tUv wxyz", [filter filter:@"abc [def] ghi jklmnop qrs tuv wxyz"]);
}

@end
