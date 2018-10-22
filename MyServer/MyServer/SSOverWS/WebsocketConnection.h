//
//  MyPSWebSocket.h
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSWebSocket;
@class WebsocketSession;
@class WebsocketConnection;

@protocol WebSocketConnectionDelegate <NSObject>
-(void)websocketConnectionDisconnected:(WebsocketConnection*)connection;
@end


//代表一台连接的设备
@interface WebsocketConnection : NSObject

-(instancetype)initWithInner:(PSWebSocket*)inner_;

@property (nonatomic,weak) id<WebSocketConnectionDelegate> delegate;

-(WebsocketSession*)createSession;

-(void)createRemoteSessionbySession:(WebsocketSession*)session;

-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session;

-(void)toCloseSession:(WebsocketSession*)session;

@property (nonatomic ) unsigned long long totalBytesWritten;
@property (nonatomic ) unsigned long long totalBytesRead;
@property (nonatomic,strong) NSMutableDictionary<NSNumber*,WebsocketSession*> *sessions;

@end
