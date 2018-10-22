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
<PSWebSocketServerDelegate,
WebSocketConnectionDelegate>

@property (nonatomic, strong) PSWebSocketServer *server;

@property (nonatomic,strong) SOCKSProxyOverWebsocket *socksServer;


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

        self.connections = [NSMutableSet set];
    }
    return self;
}


-(WebsocketConnection*)chooseConnectionByClientHost:(NSString*)clientHost
{
    //todo ,by host
    return self.connections.anyObject;
}

#pragma mark - WebsocketConnectionDelegate

-(void)websocketConnectionDisconnected:(WebsocketConnection*)connection
{
    [self.connections removeObject:connection];
}

#pragma mark - PSWebSocketServerDelegate

- (void)serverDidStart:(PSWebSocketServer *)server {
    
    NSLog(@"Websocket server Started");
    
}

- (void)server:(PSWebSocketServer *)server didFailWithError:(NSError *)error {
    //[NSException raise:NSInternalInconsistencyException format:error.localizedDescription];
}

- (void)serverDidStop:(PSWebSocketServer *)server {
    [NSException raise:NSInternalInconsistencyException format:@"Server stopped unexpected."];
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"WebsocketServer webSocketDidOpen");
    
    WebsocketConnection *connection = [[WebsocketConnection alloc] initWithInner: webSocket ];
    connection.delegate = self;
    [self.connections addObject: connection ];
    
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSData *data = message;

    NSLog(@"error!  WebsocketServer websocket server did receive message: %lu bytes",(unsigned long)data.length);
    
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WebsocketServer didFailWithError");
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebsocketServer didCloseWithCode");
}


@end
