//
//  WebsocketAdapter.m
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketAdapter.h"
#import "PrintHex.h"
#import "WebsocketSession.h"




@interface WebsocketAdapter ()
<SRWebSocketDelegate>
{
    SRWebSocket *inner;
}
@property (nonatomic,strong) NSMutableDictionary<NSNumber*,WebsocketSession*> *sessions;
@end

@implementation WebsocketAdapter
-(instancetype)initWithWebSocket:(SRWebSocket*)inner_
{
    self = [super init];
    if (self) {
        
        inner = inner_;
        inner.delegate = self;

        self.sessions = [NSMutableDictionary dictionary];
        
    }
    return self;
}

-(void)disconnect
{
    [inner close];
}


-(void)disconnectAfterWriting
{
    [inner close];
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *data = message;

    
    uint16_t rawPort ;
    memcpy(&rawPort, [data bytes], 2);
    uint16_t destinationPort = NSSwapBigShortToHost(rawPort);
    

    
    
    NSData *sessionData = [data subdataWithRange:NSMakeRange(2, data.length - 2)];
    
    
    
    WebsocketSession *session = [self findSessionByPort:destinationPort];
    if (session) {
        [session inputData:sessionData];
    }
    else{
        
        WebsocketSession *newSession = [[WebsocketSession alloc] initWithParent:self];
        newSession.port = destinationPort;
 
        self.sessions[@(destinationPort)] = newSession;
        
        [newSession inputData:sessionData];
    }
    
    
}





-(WebsocketSession *)findSessionByPort:(uint16_t)port
{
    WebsocketSession *session = self.sessions[@(port)];
    return session;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed: %@",reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"WebSocket received pong");
}



-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session
{
    uint16_t port = htons(session.port);
    NSUInteger portLength = 2;
    
    
    NSMutableData *temp = [[NSMutableData alloc] initWithBytes:&port length: portLength ];
    [temp appendData:data];
    
    [inner send:temp];
}


@end

