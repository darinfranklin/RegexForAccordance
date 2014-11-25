//
//  BXVerseRefConsolidator.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/8/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerseRef.h"

/* Combines a sequence of verse refs into contiguous ranges. */
@interface BXVerseRefConsolidator : NSObject
@property NSUInteger maxLength;
- (id)init;
- (id)initWithVerseRefs:(NSArray *)refs;
- (void) addVerseRef:(BXVerseRef *)ref;
- (void) addVerseRefs:(NSArray *)refs;

/* Builds a string of verse references with length <= maxLength.  Call again to get the next chunk.
   Returns nil if no more verses. */
- (NSString *)buildRefString;
- (BXVerseRef *)currentVerseRef;
- (BXVerseRef *)lastUsedVerseRef;

/* reset the index so that buildRefString starts from the beginning */
- (void)reset;

@end
