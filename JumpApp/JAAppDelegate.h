//
//  JAAppDelegate.h
//  JumpApp
//
//  Created by Matt Condon on 8/30/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JAJumpManager.h"

@interface JAAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) JAJumpManager *jumpManager;

@end
