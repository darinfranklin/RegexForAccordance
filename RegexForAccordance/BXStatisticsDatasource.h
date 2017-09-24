//
//  BXStatisticsDatasource.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/16/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BXStatisticsGroups.h"
#import "BXSearchWindowController.h"

extern NSString *const BXColumnNameKey;
extern NSString *const BXColumnNameHitCount;
extern NSString *const BXColumnNameLength;
extern NSString *const BXColumnNameRefs;

@interface BXStatisticsDatasource : NSObject<NSTableViewDataSource,NSTableViewDelegate>
@property BXStatisticsGroups *statisticsGroups;
@property NSTextAlignment alignment;
@property NSFont *font;
@property (nonatomic) BOOL groupByBook;
@property BXSearchWindowController *searchWindowController;
@property (weak) IBOutlet NSView *groupRowView;

- (id) initWithStatisticsGroups:(BXStatisticsGroups *)statisticsGroups;
- (NSArray *)searchResultHitsForRow:(NSUInteger)row;
- (NSString *)keyForRow:(NSUInteger)row;
- (NSUInteger)incrementIndex:(NSUInteger)index byAmount:(NSInteger)inc forCount:(NSUInteger)count;
- (BOOL)isGroupRow:(NSInteger)row;

#pragma mark NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)copySelectedRowsFromTableView:(NSTableView *)tableView;
- (NSString *)refsForRow:(NSInteger)row;
- (NSArray *)searchResultsForRow:(NSInteger)row;

#pragma mark NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors;

@end
