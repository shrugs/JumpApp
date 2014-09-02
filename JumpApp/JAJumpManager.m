//
//  JAJumpManager.m
//  JumpApp
//
//  Created by Matt Condon on 8/30/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "JAJumpManager.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@implementation JAJumpManager


- (JAJumpManager *)init
{
    self = [super init];
    if (self) {
        NSLog(@"YO!");
        
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        connectedSockets = [[NSMutableArray alloc] init];

        NSError *err = nil;
        if ([asyncSocket acceptOnPort:0 error:&err])
        {
            // So what port1 did the OS give us?

            UInt16 port = [asyncSocket localPort];

            // Create and publish the bonjour service.
            // Obviously you will be using your own custom service type.

            netService = [[NSNetService alloc] initWithDomain:@"local."
                                                         type:@"_readysetjump._tcp."
                                                         name:@""
                                                         port:port];

            [netService setDelegate:self];
            [netService publish];
            NSLog(@"Published...");

        }
        else
        {
            NSLog(@"Error in acceptOnPort:error: -> %@", err);
        }

        SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://localhost:6437/v5.json"]];
        [webSocket setDelegate:self];
        [webSocket open];

    }
    return self;
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"webSocketDidOpen:");
    [webSocket send:@"{\"enableGestures\":true}"];
    [webSocket send:@"{\"background\":true}"];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSMutableData *finalData = [[NSMutableData alloc] initWithData:[(NSString *)message dataUsingEncoding:NSUTF8StringEncoding]];
    [finalData appendData:[GCDAsyncSocket CRLFData]];
    for (GCDAsyncSocket *s in connectedSockets) {
        [s writeData:[NSData dataWithData:finalData] withTimeout:-1.0 tag:0];
    }
}


#pragma GCDAsyncSocket Methods

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	[connectedSockets addObject:newSocket];
    NSLog(@"count %i", (int)[connectedSockets count]);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:");
	[connectedSockets removeObject:sock];
}

- (void)netServiceDidPublish:(NSNetService *)ns
{
	NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
          [ns domain], [ns type], [ns name], (int)[ns port]);
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict
{
	// Override me to do something here...
	//
	// Note: This method in invoked on our bonjour thread.
    
	NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
          [ns domain], [ns type], [ns name], errorDict);
}



@end
