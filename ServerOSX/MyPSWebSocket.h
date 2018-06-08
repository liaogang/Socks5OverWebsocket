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

@interface MyPSWebSocket : NSObject

-(instancetype)initWithInner:(PSWebSocket*)inner_;

-(WebsocketSession*)newConnectToRemote;

-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session;

@end
