//
//  JAAppDelegate.m
//  JumpApp
//
//  Created by Matt Condon on 8/30/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "JAAppDelegate.h"

@implementation JAAppDelegate

@synthesize jumpManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    jumpManager = [[JAJumpManager alloc] init];
}

@end
