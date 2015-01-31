//
//  BXAppDelegate.h
//  RegexForAccordance
//
//  Created by Darin Franklin on 7/28/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BXAppDelegate : NSObject <NSApplicationDelegate>
- (IBAction)openPreferences:(id)sender;
- (IBAction)reportIssues:(id)sender;
- (IBAction)checkForUpdates:(id)sender;
- (IBAction)visitHomePage:(id)sender;
@end
