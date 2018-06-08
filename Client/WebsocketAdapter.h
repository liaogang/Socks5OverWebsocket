//
//  WebsocketAdapter.h
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"


@class WebsocketSession;

@interface WebsocketAdapter : NSObject

-(instancetype)initWithWebSocket:(SRWebSocket*)inner;

-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session;

@end
