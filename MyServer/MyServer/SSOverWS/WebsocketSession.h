//
//  WebsocketSession.h
//  MyServer
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebsocketConnection.h"


@class WebsocketSession;

@protocol WebsocketSessionDelegate <NSObject>
@required;
- (void) websocketSession:(WebsocketSession *)session didReadData:(NSData *)data withTag:(long)tag;

- (void) websocketSession:(WebsocketSession *)session didWriteData:(NSData *)data withTag:(long)tag;
@end

/**
 *   Websocket session is tunnel in connection marked with port
 */
@interface WebsocketSession : NSObject

-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithWebSocketConnection:(WebsocketConnection*)parent;

@property (nonatomic,strong) id<WebsocketSessionDelegate> delegate;

@property (nonatomic ) uint16_t port;

-(void)establishToRemote;

-(void)inputData:(NSData*)data;

- (void) writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag ;
- (void) readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag ;
- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag;

-(void)disconnect;

@end
