//
//  BXSearchTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/5/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXSearch.h"
#import "BXAccVerseFetcher.h"
#import "BXFilterReplace.h"
#import "BXFilterTransliterate.h"
#import "BXFilterHebrewPoints.h"
#import "BXFilterHebrewCantillation.h"
#import "BXFilterHebrewPunctuation.h"
#import "BXFilterDecomposeCharacters.h"
#import "BXFilter.h"

@interface BXSearchTests : XCTestCase

@end

@implementation BXSearchTests

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


- (void)testSearch
{
    BXAccVerseFetcher *fetcher = [[BXAccVerseFetcher alloc] init];
    [fetcher setTextName:@"KJVS"];
    [fetcher setVerseRange:@"Job - Isaiah"];
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = fetcher;
    searcher.pattern = @"Leviathan";
    searcher.ignoreCase = YES;
    [searcher prepareSearch:nil];
    BXSearchResult *result;

    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Job 41:1", [result.verse.ref stringValue]);
    XCTAssertEqualObjects(@"¶ Canst thou draw out leviathan with an hook?"
                          " or his tongue with a cord which thou lettest down? ",
                          [[result verse] text]);

    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Ps 74:14", [result.verse.ref stringValue]);
    XCTAssertEqualObjects(@"Thou brakest the heads of leviathan in pieces,"
                          " and gavest him to be meat to the people inhabiting the wilderness. ",
                          [[result verse] text]);
    
    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Ps 104:26", [result.verse.ref stringValue]);
    XCTAssertEqualObjects(@"There go the ships: there is that leviathan, whom thou hast made to play therein. ",
                          [[result verse] text]);
    
    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Isa 27:1", [result.verse.ref stringValue]);
    XCTAssertEqualObjects(@"¶ In that day the Lord with his sore and great and strong sword"
                          " shall punish leviathan the piercing serpent,"
                          " even leviathan that crooked serpent;"
                          " and he shall slay the dragon that is in the sea. ",
                          [[result verse] text]);

    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(nil, result);
}

- (void)testSearchWithFilter
{
    BXAccVerseFetcher *fetcher = [[BXAccVerseFetcher alloc] init];
    [fetcher setTextName:@"KJVS"];
    [fetcher setVerseRange:@"Job - Isaiah"];
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = fetcher;
    searcher.pattern = @"Leviathan";
    searcher.ignoreCase = YES;
    [searcher addFilter:[[BXFilterReplace alloc] initWithName:@"Remove Spaces" searchPattern:@" " replacePattern:@"" ignoreCase:YES]];
    [searcher prepareSearch:nil];
    BXSearchResult *result;
    
    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Job 41:1", [result.verse.ref stringValue]);
    XCTAssertEqualObjects(@"¶Canstthoudrawoutleviathanwithanhook?"
                          "orhistonguewithacordwhichthoulettestdown?",
                          [[result verse] text]);
}


- (void)testMatchBeginningOfLine
{
    BXAccVerseFetcher *fetcher = [[BXAccVerseFetcher alloc] init];
    [fetcher setTextName:@"HMT-W4"];
    [fetcher setVerseRange:@"Gen"];
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = fetcher;
    searcher.pattern = @"^ב";
    searcher.ignoreCase = YES;
    [searcher addFilter:[[BXFilterHebrewPoints alloc] init]];
    [searcher addFilter:[[BXFilterHebrewCantillation alloc] init]];
    [searcher addFilter:[[BXFilterHebrewPunctuation alloc] init]];
    [searcher prepareSearch:nil];
    BXSearchResult *result;
    
    result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"Gen 1:1", [result.verse.ref stringValue]);
    XCTAssertTrue(NSEqualRanges(NSMakeRange(NSNotFound, 0), [result.verse.text rangeOfString:@LRM]));
    XCTAssertTrue(NSEqualRanges(NSMakeRange(NSNotFound, 0), [result.verse.text rangeOfString:@RLM]));
    XCTAssertEqualObjects(@"ב", [result.verse.text substringWithRange:NSMakeRange(0, 1)]);
}

- (void)testFilters
{
    BXAccVerseFetcher *fetcher = [[BXAccVerseFetcher alloc] init];
    [fetcher setTextName:@"KJVS"];
    [fetcher setVerseRange:@"Ps 104:26"];
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = fetcher;

    BXFilterReplace *filter1 = [[BXFilterReplace alloc] init];
    [filter1 setName:@"Remove Spaces"];
    [filter1 setSearchPattern:@"\\s"];
    [filter1 setReplacePattern:@""];
    [filter1 setIgnoreCase:YES];
    [searcher addFilter:filter1];
    
    BXFilterReplace *filter2 = [[BXFilterReplace alloc] init];
    [filter2 setName:@"Double punctuation"];
    [filter2 setSearchPattern:@"([:,.;?'])"];
    [filter2 setReplacePattern:@"$1$1"];
    [searcher addFilter:filter2];
    
    BXFilterTransliterate *filter3 = [[BXFilterTransliterate alloc] initWithName:@"Replace G and V" searchPattern:@"gv" replacePattern:@"!?"];
    [searcher addFilter:filter3];

    searcher.pattern = @"^";
    searcher.ignoreCase = YES;
    [searcher prepareSearch:nil];
    BXSearchResult *result = [searcher nextSearchResult];
    XCTAssertEqualObjects(@"There!otheships::thereisthatle?iathan,,whomthouhastmadetoplaytherein..", [[result verse] text]);
}

- (void)testAddRemoveFilters
{
    BXSearch *searcher = [[BXSearch alloc] init];
    XCTAssertEqual(2, searcher.filters.count);
    [searcher addFilter:[[BXFilter alloc] initWithName:@"one"]];
    [searcher addFilter:[[BXFilter alloc] initWithName:@"two"]];
    [searcher addFilter:[[BXFilter alloc] initWithName:@"three"]];
    XCTAssertEqual(5, searcher.filters.count);
    [searcher addFilter:[[BXFilter alloc] initWithName:@"one"]];
    XCTAssertEqual(5, searcher.filters.count);
    [searcher removeFilter:[[BXFilter alloc] initWithName:@"one"]];
    XCTAssertEqual(4, searcher.filters.count);
    [searcher removeFilter:[[BXFilter alloc] initWithName:@"one"]];
    XCTAssertEqual(4, searcher.filters.count);
}

- (void)testSearchFullRange
{
    BXAccVerseFetcher *fetcher = [[BXAccVerseFetcher alloc] init];
    [fetcher setTextName:@"KJVS"];
    [fetcher setVerseRange:@"Job - Isaiah"];
    BXSearch *searcher = [[BXSearch alloc] init];
    [searcher setFetcher:fetcher];
    [searcher setPattern:@"^"];
    [searcher prepareSearch:nil];
    BXSearchResult *result, *lastResult;;
    while (nil != (result = [searcher nextSearchResult]))
    {
        lastResult = result;
    }
    XCTAssertEqualObjects(@"Isa 66:24", [[[lastResult verse] ref] stringValue]);
}

- (NSString *)findFirstRefForHebrewRegex:(NSString *)pattern
{
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = [[BXAccVerseFetcher alloc] init];
    searcher.fetcher.textName = @"HMT-W4";
    searcher.fetcher.verseRange = @"Esther";
    searcher.pattern = pattern;
    [searcher addFilter:[[BXFilterHebrewPoints alloc] init]];
    [searcher addFilter:[[BXFilterHebrewCantillation alloc] init]];
    [searcher prepareSearch:nil];
    BXSearchResult *result = [searcher nextSearchResult];
    return result.verse.ref.stringValue;
}

- (void)testHebrewRegex
{
    XCTAssertEqualObjects(@"Esth 5:4",  [self findFirstRefForHebrewRegex:@"\\bי\\w*\\W+ה\\w*\\W+ו\\w*\\W+ה\\w*\\b"]);
    XCTAssertEqualObjects(@"Esth 1:20", [self findFirstRefForHebrewRegex:@"\\bה\\w*\\W+ו\\w*\\W+ה\\w*\\W+י\\w*\\b"]);
    XCTAssertEqualObjects(@"Esth 7:7",  [self findFirstRefForHebrewRegex:@"\\b\\w*י\\W+\\w*ה\\W+\\w*ו\\W+\\w*ה\\b"]);
    XCTAssertEqualObjects(@"Esth 5:13", [self findFirstRefForHebrewRegex:@"\\b\\w*ה\\W+\\w*ו\\W+\\w*ה\\W+\\w*י\\b"]);
}

- (void)testSpecialCharactersInJob
{
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = [[BXAccVerseFetcher alloc] init];
    searcher.fetcher.textName = @"LXX1";
    searcher.fetcher.verseRange = @"Job 12:9";
    searcher.pattern = @"^";
    [searcher prepareSearch:nil];
    BXSearchResult *result = [searcher nextSearchResult];
    // NOTE: ϗ should be ※ (U+203B);  V should be ⸔ (U+2E14)
    NSString *exp = @"ϗ τίς οὐκ ἔγνω ἐν πᾶσι τούτοιςϗ ὅτι χεὶρ κυρίου ἐποίησεν ταῦτα; V ";
    exp = [[[BXFilterDecomposeCharacters alloc] init] filter:exp];
    XCTAssertTrue([result.verse.text rangeOfString:@"ϗ"].location != NSNotFound);
    XCTAssertTrue([result.verse.text rangeOfString:@"V"].location != NSNotFound);
    //XCTAssertEqualObjects(exp, result.verse.text);
}


- (void)testInvalidRegexIgnoreError
{
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = [[BXAccVerseFetcher alloc] init];
    searcher.fetcher.textName = @"LXX1";
    searcher.fetcher.verseRange = @"Job 12:9";
    searcher.pattern = @"[[[";
    NSError *error;
    BOOL success = [searcher prepareSearch:&error];
    XCTAssertFalse(success);
    XCTAssertEqualObjects(nil, [searcher nextSearchResult]);
}

- (void)testInvalidRegexError
{
    BXSearch *searcher = [[BXSearch alloc] init];
    searcher.fetcher = [[BXAccVerseFetcher alloc] init];
    searcher.fetcher.textName = @"LXX1";
    searcher.fetcher.verseRange = @"Job 12:9";
    searcher.pattern = @"[[[";
    NSError *error;
    BOOL success = [searcher prepareSearch:&error];
    XCTAssertFalse(success);
    XCTAssertEqual(2048, error.code);
    XCTAssertEqualObjects(nil, [searcher nextSearchResult]);
}

// Test works, but Accordance blocks with an error dialog.
//- (void)testInvalidRangeError
//{
//    BXSearch *searcher = [[BXSearch alloc] init];
//    searcher.fetcher = [[BXAccVerseFetcher alloc] init];
//    searcher.fetcher.textName = @"LXX1";
//    searcher.fetcher.verseReferences = @"Matt 1:1";
//    searcher.pattern = @"^";
//    NSError *error;
//    BOOL success = [searcher prepareSearch:&error];
//    XCTAssertTrue(success);
//    XCTAssertEqualObjects(nil, [searcher nextSearchResult]);
//    error = searcher.error;
//    XCTAssertEqual(-1, error.code);
//}

@end

// \bי\w*\W+ה\w*\W+ו\w*\W+ה\w*\b Esth 5:4
// \bה\w*\W+ו\w*\W+ה\w*\W+י\w*\b Esth 1:20
// \b\w*י\W+\w*ה\W+\w*ו\W+\w*ה\b Esth 7:7
// \b\w*ה\W+\w*ו\W+\w*ה\W+\w*י\b Esth 5:13
// \b(\s*\w\s*)(\s*\w\s*)(\s*\w\s*)\3\2\1\b  palindromes

