//
//  BXFilterTests.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXFilterReplace.h"
#import "BXFilterSpaces.h"
#import "BXFilterTrailingSpaces.h"
#import "BXFilterDecomposeCharacters.h"
#import "BXFilterHebrewPoints.h"
#import "BXFilterHebrewCantillation.h"
#import "BXTextLanguage.h"
#import "BXFilterGreekDiacritics.h"
#import "BXFilterTransliterate.h"
#import "BXFilterHebrewPunctuation.h"
#import "BXFilterGreekPunctuation.h"
#import "BXFilterPilcrows.h"

@interface BXFilterTests : XCTestCase

@end

@implementation BXFilterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFilter
{
    BXFilterReplace *filter;
    filter = [[BXFilterReplace alloc] init];
    [filter setName:@"Replace Vowels"];
    [filter setIgnoreCase:YES];
    [filter setSearchPattern:@"[aeiou]"];
    [filter setReplacePattern:@"X"];
    XCTAssertEqualObjects(@"Xbc dXf ghX jklmnXp qrs tXv wxyz", [filter filter:@"abc def ghi jklmnop qrs tuv wxyz"]);
}

- (void)testRemoveSpacesFilter
{
    BXFilterSpaces *f = [[BXFilterSpaces alloc] init];
    XCTAssertEqualObjects(@"abcdefghi", [f filter:@"abc def ghi"]);
}

- (void)testRemoveTrailingSpacesFilter
{
    BXFilterTrailingSpaces *f = [[BXFilterTrailingSpaces alloc] init];
    XCTAssertEqualObjects(@"abc def ghi", [f filter:@"abc def ghi \t  "]);
}

- (void)testTransliterate
{
    BXFilterTransliterate *f = [[BXFilterTransliterate alloc] initWithName:@"tl" searchPattern:@"abc" replacePattern:@"ABC"];
    XCTAssertEqualObjects(@"AzByCx", [f filter:@"azbycx"]);
}

- (void)testDecomposeHebrewCharacters
{
    NSString *str = @"\uFB35";
    BXFilterDecomposeCharacters *f = [[BXFilterDecomposeCharacters alloc] init];
    str = [f filter:str];
    XCTAssertEqualObjects(@"\u05D5\u05BC", str);
    BXFilterHebrewPoints *f2 = [[BXFilterHebrewPoints alloc] init];
    str = [f2 filter:str];
    XCTAssertEqualObjects(@"\u05D5", str);
}

- (void)testShin
{
    BXFilterDecomposeCharacters *f = [[BXFilterDecomposeCharacters alloc] init];
    XCTAssertEqualObjects(@"\u05E9\u05C1", [f filter:@"\uFB2A"]); // SHIN WITH SHIN DOT
    XCTAssertEqualObjects(@"\u05E9\u05C2", [f filter:@"\uFB2B"]); // SHIN WITH SIN DOT
    XCTAssertEqualObjects(@"\u05E9\u05BC\u05C1", [f filter:@"\uFB2C"]); // SHIN WITH SIN DOT AND DAGESH
    XCTAssertEqualObjects(@"\u05E9\u05BC\u05C2", [f filter:@"\uFB2D"]); // SHIN WITH SIN DOT AND DAGESH
    XCTAssertEqualObjects(@"\u05E9\u05BC", [f filter:@"\uFB49"]); // SHIN WITH DAGESH
}

- (void)testRemovePointsFromCompositeHebrewCharacters
{
    NSString *str = @"\uFB1D\uFB2A\uFB2B\uFB2C\uFB2D\uFB2E\uFB2F\uFB30\uFB31\uFB32\uFB33\uFB34\uFB35\uFB36"
    @"\uFB38\uFB39\uFB3A\uFB3B\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46\uFB47\uFB48\uFB49\uFB4A\uFB4B"
    @"\uFB4C\uFB4D\uFB4E";
    NSString *exp = @"\u05D9\u05E9\u05E9\u05E9\u05E9\u05D0\u05D0\u05D0\u05D1\u05D2\u05D3\u05D4\u05D5\u05D6"
    @"\u05D8\u05D9\u05DA\u05DB\u05DC\u05DE\u05E0\u05E1\u05E3\u05E4\u05E6\u05E7\u05E8\u05E9\u05EA\u05D5"
    @"\u05D1\u05DB\u05E4";
    BXFilterDecomposeCharacters *f = [[BXFilterDecomposeCharacters alloc] init];
    str = [f filter:str];
    BXFilterHebrewPoints *f2 = [[BXFilterHebrewPoints alloc] init];
    str = [f2 filter:str];
    XCTAssertEqualObjects(exp, str);
}

- (void)testTransliterateWithMulticharMap
{
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"A1", @"a",
                         @"B1", @"b",
                         @"C1", @"c",
                         nil];
    BXFilterTransliterate *f = [[BXFilterTransliterate alloc] initWithName:@"tl" searchReplaceMap:map];
    XCTAssertEqualObjects(@"A1zB1yC1x", [f filter:@"azbycx"]);
}

- (void)testMaqefIsWordBoundary
{
    NSString *str = @"בא־ת";
    BXFilter *f2 = [[BXFilterReplace alloc] initWithName:@"Keep First Word Only"
                                              searchPattern:@"^(\\w*).*$" replacePattern:@"$1" ignoreCase:NO];
    str = [f2 filter:str];
    XCTAssertEqualObjects(@"בא", str);
}

- (void)testHebrewMaqaf
{
    NSString *str = @"עַל־פְּנֵ֣י";
    BXFilter *firstWordOnlyFilter = [[BXFilterReplace alloc] initWithName:@"Keep First Word Only"
                                                               searchPattern:@"^(\\w+).*$" replacePattern:@"$1" ignoreCase:NO];
    NSString *result = [firstWordOnlyFilter filter:str];
    XCTAssertEqualObjects(@"עַל", result);
}

- (void)testHebrewRemovePunctuation
{
    NSString *str = @"א\u05BEב\u05C0ג\u05C3ד\u05C4ה\u05C5ו\u05C6ז";
    NSString *exp = @"אבגדהוז";
    XCTAssertEqualObjects(exp, [[[BXFilterHebrewPunctuation alloc] init] filter:str]);
}

- (void)testGreekRemovePunctuation
{
    NSString *str = @"α.β,γ;δ·ε᾿ζ«η»θ_ι-κ\u2014λ";
    NSString *exp = @"αβγδεζηθικλ";
    XCTAssertEqualObjects(exp, [[[BXFilterGreekPunctuation alloc] init] filter:str]);
}

- (void)testRemovePilcrow
{
    NSString *str = @"¶ α¶ ¶β¶  .";
    NSString *exp = @"α¶β ."; // "¶ " replaced by ""
    XCTAssertEqualObjects(exp, [[[BXFilterPilcrows alloc] init] filter:str]);
}

- (void)testGreekCompositeCharacters
{
    NSString *str = @"\u0386\u0388\u0389\u038A\u038C\u038E\u038F\u0390" // CAPITAL + TONOS
    "\u03AA\u03AB" // DIALYTIKA
    "\u03AC\u03AD\u03AE\u03AF\u03B0" // SMALL + TONOS
    "\u03CA\u03CB" // SMALL + DIALYTIKA
    "\u03CC\u03CD\u03CE"; // SMALL + TONOS
    NSString *exp = @"\u0391\u0301\u0395\u0301\u0397\u0301\u0399\u0301\u039F\u0301\u03A5\u0301\u03A9\u0301\u03B9\u0308\u0301"
    "\u0399\u0308\u03A5\u0308"
    "\u03B1\u0301\u03B5\u0301\u03B7\u0301\u03B9\u0301\u03C5\u0308\u0301"
    "\u03B9\u0308\u03C5\u0308"
    "\u03BF\u0301\u03C5\u0301\u03C9\u0301";
    NSString *act = [[[BXFilterDecomposeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekCompositeCharactersMore
{
    // [α-ωΑ-Ωϊϋ] are the only characters in [\u0370-\u03FF] that Accordance has in GNT-T
    NSString *str = @"ϊϋ";
    XCTAssertEqualObjects(@"\u03CA\u03CB", str);
    XCTAssertEqual(2, str.length);
    NSLog(@"%@ %ld =%04x%04x", str, str.length, [str characterAtIndex:0], [str characterAtIndex:1]);
    NSString *exp = @"\u03B9\u0308\u03C5\u0308";
    NSString *act = [[[BXFilterDecomposeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekDiacriticsFilterDoesNotRemoveNonDiacritics
{
    // iota subscript 0345 matches iota 03B9
    NSString *str = @"αβγδεζηθικλμνξοπρστυφχψω ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ;.,;·᾿¶\u2014ῳ";
    BXFilterGreekDiacritics *f = [[BXFilterGreekDiacritics alloc] init];
    NSString *act = [f filter:str];
    XCTAssertEqualObjects(str, act);
}

- (void)decomposeSingleCharacter:(NSString *)str expected:(NSString *)exp
{
    XCTAssertEqual(1, str.length);
    NSLog(@"%@ %ld =%04X", str, str.length, [str characterAtIndex:0]);
    NSString *act = [[[BXFilterDecomposeCharacters alloc] init] filter:str];
    XCTAssertEqualObjects(exp, act);
}

- (void)testGreekCompositeCharacters1F00Block
{
    [self decomposeSingleCharacter:@"\u1F08" expected:@"\u0391\u0313"]; // Alpha with psili -> Alpha psili
    [self decomposeSingleCharacter:@"\u1F71" expected:@"\u03B1\u0301"]; // alpha with oxia -> alpha acute
    [self decomposeSingleCharacter:@"\u03AC" expected:@"\u03B1\u0301"]; // alpha with tonos -> alpha acute
    [self decomposeSingleCharacter:@"\u1F73" expected:@"\u03B5\u0301"]; // epsilon with oxia -> epsilon acute
    [self decomposeSingleCharacter:@"\u1F75" expected:@"\u03B7\u0301"]; // eta with oxia -> eta acute
    [self decomposeSingleCharacter:@"\u03AE" expected:@"\u03B7\u0301"]; // eta with tonos -> eta acute
    [self decomposeSingleCharacter:@"\u1F77" expected:@"\u03B9\u0301"]; // iota with oxia -> iota acute
    [self decomposeSingleCharacter:@"\u03CA" expected:@"\u03B9\u0308"]; // iota with dialytica -> iota dialytica
    [self decomposeSingleCharacter:@"\u1FD3" expected:@"\u03B9\u0308\u0301"]; // iota with dialytica and oxia -> iota dialytica acute
    [self decomposeSingleCharacter:@"\u1F79" expected:@"\u03BF\u0301"]; // omicron with oxia -> omicron acute
    [self decomposeSingleCharacter:@"\u1F7B" expected:@"\u03C5\u0301"]; // upsilon with oxia -> upsilon acute
    [self decomposeSingleCharacter:@"\u03CB" expected:@"\u03C5\u0308"]; // upsilon with dialytica -> upsilon dialytica
    [self decomposeSingleCharacter:@"\u1FE3" expected:@"\u03C5\u0308\u0301"]; // upsilon with dialytica and oxia -> upsilon dialytica acute
    [self decomposeSingleCharacter:@"\u03CE" expected:@"\u03C9\u0301"]; // omega with tonos -> omega acute
    [self decomposeSingleCharacter:@"\u1F7D" expected:@"\u03C9\u0301"]; // omega with oxia -> omega acute
}

- (void)testGreekCompositeCharacters0370Block
{
    // \u03AF iota with tonos - as entered with Greek keyboard
    [self decomposeSingleCharacter:@"\u03AF" expected:@"\u03B9\u0301"];
}

- (void)testIfTextFieldChangesCompositeCharacters
{
    NSTextField *tf = [[NSTextField alloc] init];
    tf.stringValue = @"\u03B9\u0301";
    XCTAssertEqualObjects(@"\u03B9\u0301", tf.stringValue);
}


- (void)testPerformanceOfFilter:(BXFilter *)filter withString:(NSString *)string expecting:(NSString *)expected
{
    XCTAssertEqualObjects(expected, [filter filter:string]);
    [self measureBlock:^{
        for (int i = 0; i < 10000; i++)
        {
            [filter filter:string];
        }
    }];
}


- (void)testPerformanceOfRemoveSpaces
{
    [self testPerformanceOfFilter:[[BXFilterSpaces alloc] init]
                             withString:@"And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters. "                              expecting:@"Andtheearthwaswithoutform,andvoid;anddarknesswasuponthefaceofthedeep.AndtheSpiritofGodmoveduponthefaceofthewaters."];
}

- (void)testPerformanceOfRemoveTrailingSpaces
{
    [self testPerformanceOfFilter:[[BXFilterTrailingSpaces alloc] init]
                             withString:@"And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.  "
                              expecting:@"And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters."];
}

- (void)testPerformanceOfRemovePilcrows
{
    [self testPerformanceOfFilter:[[BXFilterPilcrows alloc] init]
                       withString:@"¶ The sons of Merari: ¶ Mahli and Mushi. ¶ The sons of Mahli: ¶ Eleazar and Kish. "
                        expecting:@"The sons of Merari: Mahli and Mushi. The sons of Mahli: Eleazar and Kish. "];
}

- (void)testPerformanceOfRemoveGreekDiacritics
{
    [self testPerformanceOfFilter:[[BXFilterGreekDiacritics alloc] init]
                             withString:@"κἀγὼ οὐκ ᾔδειν αὐτόν, ἀλλ᾿ ὁ πέμψας με βαπτίζειν ἐν ὕδατι ἐκεῖνός μοι εἶπεν· ἐφ᾿ ὃν ἂν ἴδῃς τὸ πνεῦμα καταβαῖνον καὶ μένον ἐπ᾿ αὐτόν, οὗτός ἐστιν ὁ βαπτίζων ἐν πνεύματι ἁγίῳ."
                              expecting:@"καγω ουκ ῃδειν αυτον, αλλ᾿ ο πεμψας με βαπτιζειν εν υδατι εκεινος μοι ειπεν· εφ᾿ ον αν ιδῃς το πνευμα καταβαινον και μενον επ᾿ αυτον, ουτος εστιν ο βαπτιζων εν πνευματι αγιῳ."];
}

- (void)testPerformanceOfRemoveHebrewCantillation
{
    [self testPerformanceOfFilter:[[BXFilterHebrewCantillation alloc] init]
                       withString:@"יְהוָ֣ה ׀ אֱלֹהֵ֣י הַשָּׁמַ֗יִם אֲשֶׁ֨ר לְקָחַ֜נִי מִבֵּ֣ית אָבִי֮ וּמֵאֶ֣רֶץ מֽוֹלַדְתִּי֒ וַאֲשֶׁ֨ר דִּבֶּר־לִ֜י וַאֲשֶׁ֤ר נִֽשְׁבַּֽע־לִי֙ לֵאמֹ֔ר לְזַ֨רְעֲךָ֔ אֶתֵּ֖ן אֶת־הָאָ֣רֶץ הַזֹּ֑את ה֗וּא יִשְׁלַ֤ח מַלְאָכוֹ֙ לְפָנֶ֔יךָ וְלָקַחְתָּ֥ אִשָּׁ֛ה לִבְנִ֖י מִשָּֽׁם׃"
                        expecting:@"יְהוָה ׀ אֱלֹהֵי הַשָּׁמַיִם אֲשֶׁר לְקָחַנִי מִבֵּית אָבִי וּמֵאֶרֶץ מֽוֹלַדְתִּי וַאֲשֶׁר דִּבֶּר־לִי וַאֲשֶׁר נִֽשְׁבַּֽע־לִי לֵאמֹר לְזַרְעֲךָ אֶתֵּן אֶת־הָאָרֶץ הַזֹּאת הוּא יִשְׁלַח מַלְאָכוֹ לְפָנֶיךָ וְלָקַחְתָּ אִשָּׁה לִבְנִי מִשָּֽׁם׃"];
}

- (void)testPerformanceOfRemoveHebrewPoints
{
    [self testPerformanceOfFilter:[[BXFilterHebrewPoints alloc] init]
                       withString:@"יְהוָ֣ה ׀ אֱלֹהֵ֣י הַשָּׁמַ֗יִם אֲשֶׁ֨ר לְקָחַ֜נִי מִבֵּ֣ית אָבִי֮ וּמֵאֶ֣רֶץ מֽוֹלַדְתִּי֒ וַאֲשֶׁ֨ר דִּבֶּר־לִ֜י וַאֲשֶׁ֤ר נִֽשְׁבַּֽע־לִי֙ לֵאמֹ֔ר לְזַ֨רְעֲךָ֔ אֶתֵּ֖ן אֶת־הָאָ֣רֶץ הַזֹּ֑את ה֗וּא יִשְׁלַ֤ח מַלְאָכוֹ֙ לְפָנֶ֔יךָ וְלָקַחְתָּ֥ אִשָּׁ֛ה לִבְנִ֖י מִשָּֽׁם׃"
                        expecting:@"יהו֣ה ׀ אלה֣י השמ֗ים אש֨ר לקח֜ני מב֣ית אבי֮ ומא֣רץ מולדתי֒ ואש֨ר דבר־ל֜י ואש֤ר נשבע־לי֙ לאמ֔ר לז֨רעך֔ את֖ן את־הא֣רץ הז֑את ה֗וא ישל֤ח מלאכו֙ לפנ֔יך ולקחת֥ אש֛ה לבנ֖י משם׃"];
}

@end
