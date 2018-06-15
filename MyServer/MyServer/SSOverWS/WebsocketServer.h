//
//  WebsocketServer.h
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSWebSocket.h"
#import "MyPSWebSocket.h"

@interface WebsocketServer : NSObject
+(instancetype)shared;
-(instancetype)init NS_UNAVAILABLE;


-(MyPSWebSocket*)pickOneDevice;

@end
