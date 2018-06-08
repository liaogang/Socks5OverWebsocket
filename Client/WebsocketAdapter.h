//
//  WebsocketAdapter.h
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
//#import "PSWebSocket.h"


@class WebsocketAdapter,WebsocketSession;

/*
@protocol WebSocketAdapterDelegate <NSObject>
@required;
- (void) websocketAdapter:(WebsocketAdapter *)adapter didReadData:(NSData *)data withTag:(long)tag;

- (void) websocketAdapter:(WebsocketAdapter *)adapter didWriteData:(NSData *)data withTag:(long)tag;
@end
*/

@interface WebsocketAdapter : NSObject

-(instancetype)initWithWebSocket:(SRWebSocket*)inner;

-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session;

/*
@property (nonatomic,weak) id<WebSocketAdapterDelegate> delegate;

-(void)disconnect;

-(void)disconnectAfterWriting;

- (void)readDataToLength:(NSUInteger)length tag:(long)tag;

- (void)readDataWithTag:(long)tag;

- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag ;

-(void)writeData:(NSData*)data withTag:(long)tag;

- (void) writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag ;
*/


@end
