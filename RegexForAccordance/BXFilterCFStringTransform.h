//
//  BXFilterCFStringTransform.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/10/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXFilter.h"

@interface BXFilterCFStringTransform : BXFilter
@property CFStringRef transform;
- (id)initWithName:(NSString *)name transform:(CFStringRef)transform;
@end
