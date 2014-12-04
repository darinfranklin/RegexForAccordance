//
//  BXAppDelegate.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 7/28/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXAppDelegate.h"
#import "BXPreferencesWindowController.h"

@interface BXAppDelegate() { }
@property BXPreferencesWindowController *preferences;
@end

@implementation BXAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
#ifdef DEBUG
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    LogDebug(@"DocumentsDirectory: %@", documentsDirectory);
    setenv("GCOV_PREFIX", [documentsDirectory cStringUsingEncoding:NSUTF8StringEncoding], 1);
#endif
    NSString *appDefaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    LogDebug(@"Loading Defaults from %@", appDefaultsPath);
    NSDictionary *appDefaults = [NSDictionary dictionaryWithContentsOfFile:appDefaultsPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (IBAction)openPreferences:(id)sender
{
    if (self.preferences == nil)
    {
        self.preferences = [[BXPreferencesWindowController alloc] init];
    }
    [self.preferences showWindow:sender];
}

@end
