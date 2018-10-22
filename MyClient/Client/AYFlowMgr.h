//
//  AYFlowMgr.h
//  AYFlow
//
//  Created by liaogang on 2018/6/5.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString *wsServer;
// @"ws://192.168.0.126:9091"


@interface AYFlowMgr : NSObject

+(instancetype)shared;
-(instancetype)init NS_UNAVAILABLE;

-(void)setupSDKWithWebsocketUrl:(NSString*)urlstring;


-(unsigned long long)totalBytesWritten;
-(unsigned long long)totalBytesRead;
-(NSUInteger)activeConnections;

@end
