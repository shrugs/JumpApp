//
//  JAJumpManager.h
//  JumpApp
//
//  Created by Matt Condon on 8/30/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRWebSocket.h"

@class GCDAsyncSocket;

@interface JAJumpManager : NSObject <NSNetServiceDelegate, SRWebSocketDelegate>
{
    NSMutableArray *connectedSockets;
    NSNetService *netService;
    GCDAsyncSocket *asyncSocket;
}
@end
