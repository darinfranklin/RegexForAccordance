//
//  BXFilterGreekNormalizeToCompositeCharacters.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/20/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilter.h"

@interface BXFilterGreekNormalizeToCompositeCharacters : NSObject<BXFilter>
@property NSString *name;
@property NSString *languageScriptTag;
- (NSString *)filter:(NSString *)text;
@end
