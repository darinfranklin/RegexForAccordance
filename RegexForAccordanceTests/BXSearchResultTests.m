//
//  BXSearchResultTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 12/1/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BXSearchResult.h"
#import "BXVerse.h"

@interface BXSearchResultTests : XCTestCase

@end

@implementation BXSearchResultTests

- (void)testStringForHit
{
    BXSearchResult *searchResult = [[BXSearchResult alloc] init];
    searchResult.verse = [[BXVerse alloc] init];
    searchResult.verse.text = @"Gen 1:1 In the beginning";
    searchResult.rangeOfDisplayLine = NSMakeRange(0, searchResult.verse.text.length);
    searchResult.rangeOfSearch = NSMakeRange(0, searchResult.verse.text.length);
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"" options:0 error:NULL];
    NSRange range0 = NSMakeRange(11, 3);
    NSTextCheckingResult *hit0 = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&range0 count:1 regularExpression:regex];
    NSRange range1 = NSMakeRange(0, 3);
    NSTextCheckingResult *hit1 = [NSTextCheckingResult regularExpressionCheckingResultWithRanges:&range1 count:1 regularExpression:regex];
    searchResult.hits = [NSArray arrayWithObjects:hit0, hit1, nil];
    XCTAssertEqualObjects(@"the", [searchResult stringForHit:hit0]);
    NSArray *hits = [searchResult hitsEqualToString:@"the"];
    NSArray *expectedHits = [NSArray arrayWithObject:hit0];
    XCTAssertEqualObjects(expectedHits, hits);
}

@end
