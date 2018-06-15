//
//  AYFlowMgr.m
//  AYFlow
//
//  Created by liaogang on 2018/6/5.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "AYFlowMgr.h"
#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import "SOCKSProxyWSAdapter.h"
#import "WebsocketAdapter.h"




@interface AYFlowMgr ()
<SRWebSocketDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
}
@property (nonatomic,strong) SRWebSocket *webSocket;
@property (nonatomic,strong) WebsocketAdapter *adapter;
@property (nonatomic,strong) NSUUID *UUID;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation AYFlowMgr

+(instancetype)shared
{
    static AYFlowMgr *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[AYFlowMgr alloc] initPrivate];
    });
    return s;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        [self setupWebSocket];
        
      
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidActive) name:UIApplicationDidBecomeActiveNotification object:nil];
       
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeFired) userInfo:nil repeats:YES];

    }
    return self;
}

-(void)timeFired
{
    [self trySetupWebsocket];
}

-(BOOL)shouldKeepWebsocketAlive{
    return [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
}

-(void)applicationDidEnterBackground:(NSNotification*)o
{
    [_webSocket close];
    _webSocket = nil;
    
    /*
    UIApplication *application = o.object;
    
    bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        [_webSocket close];
       
        
        
        [application endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
        
    }];
    
    
    NSTimeInterval t = application.backgroundTimeRemaining - 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        
        //标记结束
        [application endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
         
    });
    */
   
}


-(void)applicationDidActive
{
    [self trySetupWebsocket];
}

-(void)trySetupWebsocket
{
    if (_webSocket) {
        if(_webSocket.readyState == SR_CONNECTING ||
           _webSocket.readyState == SR_OPEN
           ){
            //[_webSocket close];
            //alreay open
        }
        else{
            [_webSocket close];
            _webSocket = nil;
            
            
        }
        
    }
    
    if(_webSocket == nil)
    {
        [self setupWebSocket];
    }
    
}

-(void)setupWebSocket
{
    if ([self shouldKeepWebsocketAlive])
    {
        NSURL *url = [[NSURL alloc] initWithString:@"ws://192.168.0.126:9091"];
        //NSURL *url = [[NSURL alloc] initWithString:@"ws://192.168.0.146:9001"];
        self.webSocket = [[SRWebSocket alloc] initWithURL:url];
        
        self.adapter = [[WebsocketAdapter alloc] initWithWebSocket:self.webSocket];
        
        NSLog(@"to connect websocket server");
        [self.webSocket open];
    }
    
}



-(BOOL)isWebSocketOpen{
    if (_webSocket) {
        if(_webSocket.readyState == SR_OPEN)
        {
            return YES;
        }
    }
    
    return FALSE;
}



@end



