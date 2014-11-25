//
//  BXVerseRefConsolidatorTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXVerseRefConsolidator.h"


@interface BXVerseRefConsolidatorTests : XCTestCase

@end

@implementation BXVerseRefConsolidatorTests

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

- (void)testBuildRefString
{
    BXVerseRefConsolidator *vrc = [[BXVerseRefConsolidator alloc] init];
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
    BXVerseRefConsolidator *vrc = [[BXVerseRefConsolidator alloc] init];
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
    BXVerseRefConsolidator *vrc = [[BXVerseRefConsolidator alloc] init];
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
    BXVerseRefConsolidator *vrc = [[BXVerseRefConsolidator alloc] init];
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


@end
