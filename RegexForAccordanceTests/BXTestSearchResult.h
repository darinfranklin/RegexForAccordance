//
//  BXTestSearchResult.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/29/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXSearchResult.h"

@interface BXTestSearchResult : BXSearchResult
- (id)initWithText:(NSString *)text book:(NSString *)book chapter:(NSUInteger)chapter verse:(NSUInteger)verse;
- (id)initWithText:(NSString *)text book:(NSString *)book;
@end
