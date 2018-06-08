//
//  SOCKSProxyWSAdapter.h
//  Tether
//
//  Created by Christopher Ballinger on 11/26/13.
//  Copyright (c) 2013 Christopher Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "PSWebSocket.h"
#import "WebsocketAdapter.h"


@class SOCKSProxyWSAdapter,WebsocketSession;

@protocol SOCKSProxyWSAdapterDelegate <NSObject>
@optional
- (void) proxySocketDidDisconnect:(SOCKSProxyWSAdapter*)proxySocket withError:(NSError *)error;
- (void) proxySocket:(SOCKSProxyWSAdapter*)proxySocket didReadDataOfLength:(NSUInteger)numBytes;
- (void) proxySocket:(SOCKSProxyWSAdapter*)proxySocket didWriteDataOfLength:(NSUInteger)numBytes;
- (BOOL) proxySocket:(SOCKSProxyWSAdapter*)proxySocket
checkAuthorizationForUser:(NSString*)username
            password:(NSString*)password;
@end

@interface SOCKSProxyWSAdapter : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, readonly) uint16_t destinationPort;
@property (nonatomic, strong, readonly) NSString* destinationHost;
@property (nonatomic, weak) id<SOCKSProxyWSAdapterDelegate> delegate;
@property (nonatomic) dispatch_queue_t callbackQueue;
@property (nonatomic, readonly) NSUInteger totalBytesWritten;
@property (nonatomic, readonly) NSUInteger totalBytesRead;

- (void) disconnect;

//- (id) initWithSocket:(GCDAsyncSocket*)socket delegate:(id<SOCKSProxyWSAdapterDelegate>)delegate;
- (id) initWithWebSocket:(WebsocketSession *)proxySocket delegate:(id<SOCKSProxyWSAdapterDelegate>)delegate ;

@end
