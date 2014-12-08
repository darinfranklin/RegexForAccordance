//
//  BXStatisticsDatasource.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/16/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXStatisticsDatasource.h"
#import "BXTextLanguage.h"
#import "BXSearchResultHit.h"
#import "BXVerseRefConsolidator.h"
#import "BXGroupRowViewController.h"

NSString *const BXColumnNameKey = @"BXStatisticsKey";
NSString *const BXColumnNameHitCount = @"BXStatisticsHitCount";
NSString *const BXColumnNameLength = @"BXStatisticsLength";
NSString *const BXColumnNameRefs = @"BXStatisticsRefs";

@interface BXStatisticsDatasource ()
@property BOOL ascending;
@property (nonatomic)  NSSortDescriptor *sortDescriptor;
@property BOOL showUnicodeID;
@property NSIndexSet *prevSelectedRowIndexes;
@end

@implementation BXStatisticsDatasource

- (id) initWithStatisticsGroups:(BXStatisticsGroups *)statisticsGroups
{
    if (self = [super init])
    {
        self.statisticsGroups = statisticsGroups;
        self.ascending = YES;
        self.groupByBook = NO;
    }
    return self;
}

#pragma mark NSTableViewDelegate

// NSTableViewDelegate
- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    if (self.groupByBook)
    {
        return [self.statisticsGroups isGroupRow:row];
    }
    else
    {
        return NO;
    }
}

// NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableColumn == nil)
    {
        //group row
        BXGroupRowViewController *vc = [[BXGroupRowViewController alloc] init];
        BXStatisticsGroup *group = [self.statisticsGroups groupAtIndex:[self.statisticsGroups groupIndexForRow:row]];
        vc.groupRowView = (BXGroupRowView *)vc.view;
        vc.groupRowView.label.stringValue = group.name;
        vc.groupRowView.badge.stringValue = [NSString stringWithFormat:@"%ld|%ld",
                                             group.statistics.countOfHitKeys,
                                             group.statistics.countOfHits];
        return vc.groupRowView;
    }
    else if ([tableColumn.identifier isEqualToString:BXColumnNameRefs])
    {
        NSButton *button = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        button.target = self.searchWindowController;
        button.tag = row;
        button.toolTip = @"View in Accordance";
        button.action = @selector(openLinkFromTableView:);
        return button;
    }
    else
    {
        NSTextField *textField = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        if ([tableColumn.identifier isEqualToString:BXColumnNameKey])
        {
            textField.font = self.font;
            [textField sizeToFit];
            textField.alignment = self.alignment;
            if (self.showUnicodeID)
            {
                NSString *key = [self keyForRow:row];
                if (key.length == 1)
                {
                    textField.toolTip = [NSString stringWithFormat:@"U+%04X", [key characterAtIndex:0]];
                }
                else
                {
                    textField.toolTip = nil;
                }
            }
        }
        return textField;
    }
}

//NSTableViewDelegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    
    NSMutableIndexSet *indexesToHighlight;
    NSMutableIndexSet *indexesToUnhighlight;
    if (self.prevSelectedRowIndexes == nil)
    {
        self.prevSelectedRowIndexes = [[NSIndexSet alloc] init];
    }
    
    indexesToHighlight = [tableView.selectedRowIndexes mutableCopy];
    [indexesToHighlight removeIndexes:self.prevSelectedRowIndexes];
    
    indexesToUnhighlight = [self.prevSelectedRowIndexes mutableCopy];
    [indexesToUnhighlight removeIndexes:tableView.selectedRowIndexes];
    
    self.prevSelectedRowIndexes = [tableView.selectedRowIndexes copy];
}

#pragma mark NSTableViewDataSource

// NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    [self sortUsingDescriptor:self.sortDescriptor];
    NSUInteger rowCount;
    if (self.groupByBook)
    {
        rowCount = [self.statisticsGroups numberOfRows];
    }
    else
    {
        rowCount = self.statisticsGroups.combinedStatistics.countOfHitKeys;
    }
    // get this when the table is reloaded
    self.showUnicodeID = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowUnicodeID"];
    return rowCount;
}

// NSTableViewDataSource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *key = [self keyForRow:row];
    BXStatistics *statistics = [self statisticsForRow:row];
    
    if (tableColumn == nil)
    {
        if (self.groupByBook)
        {
            // group row
            BXStatisticsGroup *group = [self.statisticsGroups groupAtIndex:[self.statisticsGroups groupIndexForRow:row]];
            return group.name;
        }
        else
        {
            return nil;
        }
    }
    else if ([tableColumn.identifier isEqualToString:BXColumnNameKey])
    {
        BXSearchResultHit *searchResultHit = [[statistics.distinctHits valueForKey:key] objectAtIndex:0];
        // get an actual hit substring, because key may have been converted to lower case
        NSString *displayKey = [searchResultHit.searchResult stringForHit:searchResultHit.hit];
        NSString *originalDisplayKey = displayKey;
        if (originalDisplayKey.length == 1)
        {
            if ([BXTextLanguage.hebrewCantillationCharacterSet characterIsMember:[displayKey characterAtIndex:0]]
                || [BXTextLanguage.hebrewPointsCharacterSet characterIsMember:[displayKey characterAtIndex:0]])
            {   // U+25CC DOTTED CIRCLE
                displayKey =  [@RLO @"\u25CC" stringByAppendingString:displayKey];
            }
            else if ([BXTextLanguage.greekDiacriticsCharacterSet characterIsMember:[displayKey characterAtIndex:0]])
            {
                displayKey = [@"\u25CC" stringByAppendingString:displayKey];
            }
        }
        return displayKey;
    }
    else if ([tableColumn.identifier isEqualToString:BXColumnNameHitCount])
    {
        NSString *count = [NSString stringWithFormat:@"%ld", [[statistics.distinctHits valueForKey:key] count]];
        return count;
    }
    else if ([tableColumn.identifier isEqualToString:BXColumnNameLength])
    {
        return [NSString stringWithFormat:@"%ld", key.length];
    }
    else if ([tableColumn.identifier isEqualToString:BXColumnNameRefs])
    {
        return @"";
    }
    else
    {
        LogError(@"nil value for column %@ row %ld", tableColumn.identifier, row);
        return @"??!";
    }
}


// NSTableViewDataSource
- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [self sortUsingDescriptor:[tableView.sortDescriptors objectAtIndex:0]];
    [tableView reloadData];
}

#pragma mark Misc

- (BXStatistics *)statisticsForRow:(NSUInteger)row
{
    if (self.groupByBook)
    {
        NSUInteger groupIndex = [self.statisticsGroups groupIndexForRow:row];
        return [self.statisticsGroups statisticsForGroupIndex:groupIndex];
    }
    else
    {
        return self.statisticsGroups.combinedStatistics;
    }
}

- (NSArray *)searchResultHitsForRow:(NSUInteger)row;
{
    NSString *hitKey = [self keyForRow:row];
    BXStatistics *statistics = [self statisticsForRow:row];
    NSArray *searchResultHits = [statistics searchResultHitsForHitKey:hitKey];
    return searchResultHits;
}

- (NSString *)keyForRow:(NSUInteger)row
{
    if ([self tableView:nil isGroupRow:row])
    {
        return nil;
    }
    BXStatistics *statistics = [self statisticsForRow:row];
    NSArray *sortedKeys = statistics.sortedKeys;
    if (self.groupByBook)
    {
        row = [self.statisticsGroups indexInStatisticsForRow:row];
    }
    
    if (!self.ascending)
    {
        row = sortedKeys.count - 1 - row;
    }
    if (row >= sortedKeys.count)
    {
        return nil;
    }
    return [sortedKeys objectAtIndex:row];
}

- (void)sortUsingDescriptor:(NSSortDescriptor *)sortDescriptor
{
    self.sortDescriptor = sortDescriptor;
    if ([sortDescriptor.key isEqualToString:BXColumnNameKey])
    {
        [self.statisticsGroups sortAllByHitKey];
        self.ascending = sortDescriptor.ascending;
    }
    else if ([sortDescriptor.key isEqualToString:BXColumnNameHitCount])
    {
        [self.statisticsGroups sortAllByHitCount];
        self.ascending = sortDescriptor.ascending;
    }
    else if ([sortDescriptor.key isEqualToString:BXColumnNameLength])
    {
        [self.statisticsGroups sortAllByHitKeyLength];
        self.ascending = sortDescriptor.ascending;
    }
    else if ([sortDescriptor.key isEqualToString:BXColumnNameRefs])
    {
        [self.statisticsGroups sortAllByRefs];
        self.ascending = sortDescriptor.ascending;
    }
}

// Increment index, given items count, wrapping around
- (NSUInteger)incrementIndex:(NSUInteger)index byAmount:(NSInteger)inc forCount:(NSUInteger)count
{
    NSUInteger sign = inc < 0 ? -1 : inc > 0 ? +1 : 0;
    inc *= sign;
    return (index + sign * (inc % count) + count) % count;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumnIdentifier:(NSString *)columnIdentifier row:(NSInteger)row
{
    NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:columnIdentifier];
    NSString *val = [self tableView:tableView objectValueForTableColumn:col row:row];
    return val;
}

- (NSArray *)searchResultsForRow:(NSInteger)row
{
    NSArray *searchResultHits = [self searchResultHitsForRow:row];
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    __block NSString *prevVerseRef = nil;
    [searchResultHits enumerateObjectsUsingBlock:^(id searchResultHit, NSUInteger idx, BOOL *stop)
     {
         BXSearchResult *searchResult = [searchResultHit searchResult];
         NSString *verseRef = searchResult.verse.ref.stringValue;
         if (![prevVerseRef isEqualToString:verseRef])
         {
             [searchResults addObject:searchResult];
             prevVerseRef = verseRef;
         }
     }];
    return searchResults;
}

- (NSString *)refsForRow:(NSInteger)row
{
    NSArray *searchResultHits = [self searchResultHitsForRow:row];
    BXVerseRefConsolidator *vrc = [[BXVerseRefConsolidator alloc] init];
    [searchResultHits enumerateObjectsUsingBlock:^(id searchResultHit, NSUInteger idx, BOOL *stop)
     {
         [vrc addVerseRef:[searchResultHit searchResult].verse.ref];
     }];
    return [vrc buildRefString];
}

- (void)copySelectedRowsFromTableView:(NSTableView *)tableView
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    NSMutableAttributedString *tsv = [[NSMutableAttributedString alloc] init];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];

    NSIndexSet *selectedRowIndexes = [tableView selectedRowIndexes];
    [selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop)
     {
         // Column headers
         if (tsv.length == 0)
         {
             NSMutableAttributedString *line = [[NSMutableAttributedString alloc] init];
             if (self.groupByBook)
             {
                 [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"Book" attributes:nil]];
             }
             for (NSTableColumn *column in [tableView tableColumns])
             {
                 if (![[tableView tableColumnWithIdentifier:column.identifier] isHidden])
                 {
                     if (line.length > 0)
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t" attributes:nil]];
                     }
                     if ([column.identifier isEqualTo:BXColumnNameKey])
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"Hit" attributes:nil]];
                     }
                     else if ([column.identifier isEqualTo:BXColumnNameHitCount])
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"Count" attributes:nil]];
                     }
                     else if ([column.identifier isEqualTo:BXColumnNameLength])
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"Length" attributes:nil]];
                     }
                     else if ([column.identifier isEqualTo:BXColumnNameRefs])
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"References" attributes:nil]];
                     }
                 }
             }
             [tsv appendAttributedString:line];
             [tsv appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
         }
         
         // Data
         if (![self tableView:tableView isGroupRow:row])
         {
             NSMutableAttributedString *line = [[NSMutableAttributedString alloc] init];
             if (self.groupByBook)
             {
                 BXStatisticsGroup *group = [self.statisticsGroups groupAtIndex:[self.statisticsGroups groupIndexForRow:row]];
                 [line appendAttributedString:[[NSAttributedString alloc] initWithString:group.name attributes:nil]];
             }
             // row data
             for (NSTableColumn *column in [tableView tableColumns])
             {
                 if (![[tableView tableColumnWithIdentifier:column.identifier] isHidden])
                 {
                     if (line.length > 0)
                     {
                         [line appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t" attributes:nil]];
                     }
                     
                     NSString *val;
                     if ([column.identifier isEqualTo:BXColumnNameRefs])
                     {
                         val = [self refsForRow:row];
                     }
                     else
                     {
                         val = [self tableView:tableView objectValueForTableColumnIdentifier:column.identifier row:row];
                     }
                     if ([column.identifier isEqualTo:BXColumnNameKey] &&
                         self.alignment == NSRightTextAlignment)
                     {
                         val = [NSString stringWithFormat:@RLO "%@" PDF, val];
                     }

                     NSDictionary *attributes = [column.identifier isEqualTo:BXColumnNameKey] ? attr : nil;
                     [line appendAttributedString:[[NSAttributedString alloc] initWithString:val attributes:attributes]];
                 }
             }
             [tsv appendAttributedString:line];
             [tsv appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
         }
     }];

    [pasteboard writeObjects:[NSArray arrayWithObject:tsv]];
}

- (void)setGroupByBook:(BOOL)groupByBook
{
    if (groupByBook != _groupByBook)
    {
        [self clearSelectedRowIndexes];
        _groupByBook = groupByBook;
    }
}

- (void)clearSelectedRowIndexes
{
    self.prevSelectedRowIndexes = nil;
}

@end
