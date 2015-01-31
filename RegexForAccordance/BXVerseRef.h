//
//  BXVerseRef.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/7/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXVerseRef : NSObject

@property (readonly) NSString *book;
@property (readonly) NSInteger chapter;
@property (readonly) NSInteger verse;
@property (readonly) NSString *stringValue;
@property BOOL europeanFormat;

- (id)initWithBook:(NSString *)book chapter:(NSInteger)chapter verse:(NSInteger)verse stringValue:(NSString *)stringValue;
- (id) initWithBook:(NSString *)book chapter:(NSInteger)chapter verse:(NSInteger)verse;
- (id)initWithBook:(NSString *)book chapter:(NSInteger)chapter verse:(NSInteger)verse europeanFormat:(BOOL)european;
- (NSString *)chapterDelimiter;
- (NSString *)verseDelimiter;

@end
