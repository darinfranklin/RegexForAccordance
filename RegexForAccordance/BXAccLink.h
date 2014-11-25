//
//  BXAccLink.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/31/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXVerseRef.h"

@interface BXAccLink : NSObject
@property NSURL *url;
@property BXVerseRef *firstVerseRef;
@property BXVerseRef *lastVerseRef;
- (id)initWithURL:(NSURL *)url firstVerseRef:(BXVerseRef *)first lastVerseRef:(BXVerseRef *)last;

@end
