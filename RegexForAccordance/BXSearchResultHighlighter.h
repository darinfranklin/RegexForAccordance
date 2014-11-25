//
//  BXSearchResultHighlighter.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 10/6/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXStatisticsDatasource.h"
#import "BXSearchResultHit.h"
#import "BXSearchSettings.h"
#import "BXSearchResultFormatter.h"

@interface BXSearchResultHighlighter : NSObject
- (id)initWithStatisticsDatasource:(BXStatisticsDatasource *)statisticsDatasource
             searchResultsTextView:(NSTextView *)searchResultsTextView
                    searchSettings:(BXSearchSettings *)searchSettings
                         formatter:(BXSearchResultFormatter *)formatter;
- (void)reset;
- (void)showNextFindIndicatorForRow:(NSInteger)row increment:(NSInteger)increment;
@end
