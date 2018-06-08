//
//  MyPSWebSocket.m
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "MyPSWebSocket.h"
#import "PSWebSocket.h"
#import "WebsocketSession.h"




@interface MyPSWebSocket ()
<PSWebSocketDelegate>
{
    PSWebSocket *inner;
    
    uint16_t portBegin;

}


@property (nonatomic,strong) NSMutableDictionary<NSNumber*,WebsocketSession*> *sessions;

@end

@implementation MyPSWebSocket
-(instancetype)initWithInner:(PSWebSocket*)inner_
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

- (void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    
}

- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}

-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session
{
    uint16_t port = htons(session.port);
    NSUInteger portLength = 2;

    
    NSMutableData *temp = [[NSMutableData alloc] initWithBytes:&port length: portLength ];
    [temp appendData:data];
    
    [inner send:temp];
}

-(WebsocketSession*)newConnectToRemote
{
    WebsocketSession *session = [WebsocketSession new];
    session.port =  portBegin;
    portBegin++;
    return session;
}

- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"didReceiveMessage");
    NSData *data = message;
    
    //printHexData(data);
   
    uint16_t rawPort ;
    memcpy(&rawPort, [data bytes], 2);
    uint16_t destinationPort = NSSwapBigShortToHost(rawPort);
    
    
    
    NSData *sessionData = [data subdataWithRange:NSMakeRange(2, data.length)];
    
    WebsocketSession *session = [self findSessionByPort:destinationPort];
    
    [session inputData:sessionData];

}


-(WebsocketSession *)findSessionByPort:(uint16_t)port
{
    WebsocketSession *session = self.sessions[@(port)];
    return session;
}


- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}


@end
