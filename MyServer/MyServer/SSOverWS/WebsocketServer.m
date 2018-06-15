//
//  WebsocketServer.m
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketServer.h"
#import "SOCKSProxyOverWebsocket.h"
#import "PSWebSocketServer.h"


@interface WebsocketServer ()
<PSWebSocketServerDelegate>

@property (nonatomic, strong) PSWebSocketServer *server;

@property (nonatomic,strong) SOCKSProxyOverWebsocket *socksServer;

@property (nonatomic,strong) NSMutableSet<MyPSWebSocket*>* devices;

@end

@implementation WebsocketServer
+(instancetype)shared
{
    static WebsocketServer *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[WebsocketServer alloc] initPrivate];
    });
    return s;
}



- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        self.server = [PSWebSocketServer serverWithHost:@"0.0.0.0" port:9091];
        self.server.delegate = self;
        [self.server start];
       
        
        self.devices = [NSMutableSet set];
    }
    return self;
}


-(MyPSWebSocket*)pickOneDevice
{
    return self.devices.anyObject;
}


#pragma mark - PSWebSocketServerDelegate

- (void)serverDidStart:(PSWebSocketServer *)server {
    
    NSLog(@"serverDidStart");
    
}

- (void)server:(PSWebSocketServer *)server didFailWithError:(NSError *)error {
    //[NSException raise:NSInternalInconsistencyException format:error.localizedDescription];
    
}

- (void)serverDidStop:(PSWebSocketServer *)server {
    [NSException raise:NSInternalInconsistencyException format:@"Server stopped unexpected."];
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
    
    MyPSWebSocket *device = [[MyPSWebSocket alloc] initWithInner: webSocket ];
    [self.devices addObject:device];
    
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSData *data = message;
    
    NSLog(@"websocket server did receive message: %lu bytes",(unsigned long)data.length);
    
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode");
}


@end
