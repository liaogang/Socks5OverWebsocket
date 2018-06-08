//
//  SOCKSProxySocketOverWS.h
//  Tether
//
//  Created by Christopher Ballinger on 11/26/13.
//  Copyright (c) 2013 Christopher Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>


@class SOCKSProxySocketOverWS;

@protocol SOCKSProxySocketOverWSDelegate <NSObject>
@optional
- (void) proxySocketDidDisconnect:(SOCKSProxySocketOverWS*)proxySocket withError:(NSError *)error;
- (void) proxySocket:(SOCKSProxySocketOverWS*)proxySocket didReadDataOfLength:(NSUInteger)numBytes;
- (void) proxySocket:(SOCKSProxySocketOverWS*)proxySocket didWriteDataOfLength:(NSUInteger)numBytes;
- (BOOL) proxySocket:(SOCKSProxySocketOverWS*)proxySocket
checkAuthorizationForUser:(NSString*)username
            password:(NSString*)password;
@end

@interface SOCKSProxySocketOverWS : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, readonly) uint16_t destinationPort;
@property (nonatomic, strong, readonly) NSString* destinationHost;
@property (nonatomic, weak) id<SOCKSProxySocketOverWSDelegate> delegate;
@property (nonatomic) dispatch_queue_t callbackQueue;
@property (nonatomic, readonly) NSUInteger totalBytesWritten;
@property (nonatomic, readonly) NSUInteger totalBytesRead;

- (void) disconnect;

- (id) initWithSocket:(GCDAsyncSocket*)socket delegate:(id<SOCKSProxySocketOverWSDelegate>)delegate;

@end
