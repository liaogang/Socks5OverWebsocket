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

+(instancetype)setupSDKWithWebsocketUrl:(NSString*)urlstring;

-(instancetype)init NS_UNAVAILABLE;
@end
