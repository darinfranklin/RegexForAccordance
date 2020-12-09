//
//  BXVerseRefConsolidatorTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXVerseRefConsolidator.h"
#import "BXVerseRangeRef.h"


@interface BXVerseRefConsolidatorTests : XCTestCase

@end

@implementation BXVerseRefConsolidatorTests
{
    BXVerseRefConsolidator *vrc;
}

- (void)setUp
{
    [super setUp];
    vrc = [[BXVerseRefConsolidator alloc] init];
}

- (void)testBuildRefString
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1]];
    XCTAssertEqualObjects(@"Gen 1:1", vrc.currentVerseRef.stringValue);
    XCTAssertEqualObjects(@"Gen 1:1", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 1:1", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:2]];
    XCTAssertEqualObjects(@"Gen 1:1", vrc.currentVerseRef.stringValue);
    XCTAssertEqualObjects(@"Gen 1:1-2", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 1:2", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:3]];
    XCTAssertEqualObjects(@"Gen 1:1", vrc.currentVerseRef.stringValue);
    XCTAssertEqualObjects(@"Gen 1:1-3", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 1:3", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:9]];
    XCTAssertEqualObjects(@"Gen 1:1-3,9", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 1:9", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:10]];
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 1:10", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:5]];
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 2:5", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:7]];
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5,7", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Gen 2:7", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:22 verse:22]];
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5,7; Exod 22:22", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Exod 22:22", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:23 verse:33]]; // last verse of chapter
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5,7; Exod 22:22; 23:33", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Exod 23:33", vrc.lastUsedVerseRef.stringValue);
    [vrc reset];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:24 verse:1]];  // first verse of next chapter
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5,7; Exod 22:22; 23:33; 24:1", [vrc buildRefString]);
    XCTAssertEqualObjects(@"Exod 24:1", vrc.lastUsedVerseRef.stringValue);
}

- (void)testMaxLength
{
    vrc.maxLength = 21;
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:2]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:3]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:9]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:10]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:5]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:6]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:7]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:8]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:9]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:10]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:22 verse:22]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:23 verse:33]]; // last verse of chapter
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:24 verse:1]];  // first verse of next chapter
    
    XCTAssertEqualObjects(@"Gen 1:1", vrc.currentVerseRef.stringValue);
    NSString *ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"Gen 2:9", vrc.lastUsedVerseRef.stringValue);
    XCTAssertEqualObjects(@"Gen 1:1-3,9-10; 2:5-9", ref);
    XCTAssertTrue(ref.length <= vrc.maxLength);
    
    XCTAssertEqualObjects(@"Gen 2:10", vrc.currentVerseRef.stringValue);
    ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"Exod 22:22", vrc.lastUsedVerseRef.stringValue);
    XCTAssertEqualObjects(@"Gen 2:10; Exod 22:22", ref);
    XCTAssertTrue(ref.length <= vrc.maxLength);
    
    XCTAssertEqualObjects(@"Exod 23:33", vrc.currentVerseRef.stringValue);
    ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"Exod 24:1", vrc.lastUsedVerseRef.stringValue);
    XCTAssertEqualObjects(@"Exod 23:33; 24:1", ref);
    XCTAssertTrue(ref.length <= vrc.maxLength);

    XCTAssertEqualObjects(nil, vrc.currentVerseRef.stringValue);
    ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"Exod 24:1", vrc.lastUsedVerseRef.stringValue);
    XCTAssertNil(ref);
}

- (void)testVerseZero
{
    // Accordance has two verse 1:1's in Odes and Lam
    // but... LetJer starts with verse 0
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Odes" chapter:1 verse:1]]; // why not verse 1:0 ??
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Odes" chapter:1 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Odes" chapter:1 verse:2]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Sol" chapter:1 verse:7]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Sol" chapter:1 verse:8]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Sol" chapter:2 verse:0]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Sol" chapter:2 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"LetJer" chapter:0 verse:0]];
    
    XCTAssertEqualObjects(@"Odes 1:1", vrc.currentVerseRef.stringValue);
    NSString *ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"LetJer 0", vrc.lastUsedVerseRef.stringValue);
    XCTAssertEqualObjects(@"Odes 1:1-2; Sol 1:7-8; 2:0-1; LetJer 0", ref);
    XCTAssertTrue(ref.length <= vrc.maxLength);
}

- (void)testVerseZeroOutOfOrder
{
    // NETS has Lam 1:1, 1:0, 1:2 in Accordance, but they are listed in correct order through AppleScript: 1:0,1,2
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Lam" chapter:1 verse:0]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Lam" chapter:1 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Lam" chapter:1 verse:2]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Lam" chapter:1 verse:3]];
    
    XCTAssertEqualObjects(@"Lam 1:0", vrc.currentVerseRef.stringValue);
    NSString *ref = [vrc buildRefString];
    XCTAssertEqualObjects(@"Lam 1:3", vrc.lastUsedVerseRef.stringValue);
    XCTAssertEqualObjects(@"Lam 1:0-3", ref);
    XCTAssertTrue(ref.length <= vrc.maxLength);
}

- (void)testSameBookChapterVerse
{
    // multiple hits in the same verse should not make the verse number repeat in the ref string
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:20]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:20]];
    XCTAssertEqualObjects(@"Gen 4:20", [vrc buildRefString]);
}

- (void)testSameBookChapterNextVerse
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:20]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:21]];
    XCTAssertEqualObjects(@"Gen 4:20-21", [vrc buildRefString]);
}

- (void)testSameBookChapterDifferentVerse
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:20]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:4 verse:22]];
    XCTAssertEqualObjects(@"Gen 4:20,22", [vrc buildRefString]);
}

- (void)testSameBookDifferentChapterNextVerse
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:2]];
    XCTAssertEqualObjects(@"Gen 1:1; 2:2", [vrc buildRefString]);
}

- (void)testNextVerseDifferentBook
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:1 verse:2]];
    XCTAssertEqualObjects(@"Gen 1:1; Exod 1:2", [vrc buildRefString]);
}

- (void)testEuropeanFormat
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:1 verse:1 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Gen" chapter:2 verse:2 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:1 verse:2 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:1 verse:3 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:1 verse:5 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Exod" chapter:1 verse:6 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Jude" chapter:0 verse:4 europeanFormat:NO]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Jude" chapter:0 verse:6 europeanFormat:NO]];
    XCTAssertEqualObjects(@"Gen 1,1; 2,2; Exod 1,2-3.5-6; Jude 4.6", [vrc buildRefString]);
}

- (void)testEuropeanFormatSingleChapterBook
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:3 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:5 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:6 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:7 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:9 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:10 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:11 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:12 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:13 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Obad" chapter:0 verse:14 europeanFormat:YES]];
    XCTAssertEqualObjects(@"Obad 3.5-7.9-14", [vrc buildRefString]);
}

- (void)testEuropeanFormatQuranBooks
{
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q2" chapter:0 verse:20 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q2" chapter:0 verse:25 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q2" chapter:0 verse:72 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q2" chapter:0 verse:87 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q3" chapter:0 verse:14 europeanFormat:YES]];
    [vrc addVerseRef:[[BXVerseRef alloc] initWithBook:@"Q3" chapter:0 verse:17 europeanFormat:YES]];
    XCTAssertEqualObjects(@"Q2 20.25.72.87; Q3 14.17", [vrc buildRefString]);
}

- (void)testSearchScopeChapterOneChapter
{
    SearchScopeOptions scope = SearchScopeChapter;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:25]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt 1", [vrc buildRefString]);
}

- (void)testSearchScopeChapter
{
    SearchScopeOptions scope = SearchScopeChapter;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:25]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:23]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:17]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt 1-3", [vrc buildRefString]);
}

- (void)testSearchScopeChapterNonContiguous
{
    SearchScopeOptions scope = SearchScopeChapter;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:25]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:23]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:17]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:48]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:38]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:39]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:49]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt 1-3; 5; Luke 3; 5-6", [vrc buildRefString]);
}

- (void)testSearchScopeChapterEuropeanNotation
{
    SearchScopeOptions scope = SearchScopeChapter;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:25 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:23 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:17 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:48 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:38 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:39 europeanFormat:YES]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:1 europeanFormat:YES]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:49 europeanFormat:YES]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt 1-3; 5; Luke 3; 5-6", [vrc buildRefString]);
}

- (void)testSearchScopeBook
{
    SearchScopeOptions scope = SearchScopeBook;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:25]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:2 verse:23]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:3 verse:17]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:5 verse:48]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:3 verse:38]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:5 verse:39]
                                                   searchScope:scope]];
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Luke" chapter:6 verse:49]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt; Luke", [vrc buildRefString]);
}

- (void)testSearchScopeBookOneBook
{
    SearchScopeOptions scope = SearchScopeBook;
    vrc.searchScope = scope;
    [vrc addVerseRef:[[BXVerseRangeRef alloc] initWithFirstRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:1 verse:1]
                                                       lastRef:[[BXVerseRef alloc] initWithBook:@"Matt" chapter:28 verse:20]
                                                   searchScope:scope]];
    XCTAssertEqualObjects(@"Matt", [vrc buildRefString]);
}

@end
