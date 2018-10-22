//
//  WebsocketConnection.m
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketConnection.h"
#import "PSWebSocket.h"
#import "WebsocketSession.h"

#define CMD_CLOSE   0x00
#define CMD_Create  0x01
#define CMD_Forward 0x10


@interface WebsocketConnection ()
<PSWebSocketDelegate>
{
    PSWebSocket *inner;
    
    uint16_t portBegin;
}

@property (nonatomic,strong) NSMutableDictionary<NSNumber*,WebsocketSession*> *sessions;

@end


@implementation WebsocketConnection
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



-(void)createRemoteSessionbySession:(WebsocketSession*)session
{
    uint8_t cmd = CMD_Create;
    
    uint16_t port = htons(session.port);
    
    NSMutableData *temp = [NSMutableData data];
    [temp appendBytes:&cmd length:1];
    [temp appendBytes:&port length:2];
    
    [inner send:temp];
}


-(void)sendData:(NSData*)data bySession:(WebsocketSession*)session
{
    uint8_t cmd = CMD_Forward;
    
    uint16_t port = htons(session.port);
    
    NSMutableData *temp = [NSMutableData data];
    [temp appendBytes:&cmd length:1];
    [temp appendBytes:&port length:2];
    
    [temp appendData:data];
    
    [inner send:temp];
}

-(WebsocketSession*)createSession
{
    WebsocketSession *session = [[WebsocketSession alloc] initWithWebSocketConnection:self];
    session.port =  portBegin;
    self.sessions[@(portBegin)] = session;
    
    portBegin++;

    return session;
}

- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *data = message;
    
//    NSLog(@"didReceiveMessage: %lu bytes",(unsigned long)data.length);
//    printHexData(data);
   
    uint8_t cmd;
    memcpy(&cmd, [data bytes], 1);
    
    uint16_t rawPort ;
    memcpy(&rawPort, [data bytes]+1, 2);
    uint16_t destinationPort = NSSwapBigShortToHost(rawPort);
    
    
    if (cmd == CMD_CLOSE ) {
        WebsocketSession *session = [self findSessionByPort:destinationPort];
        [self sessionClosed:session];
    }
    else if( cmd == CMD_Forward)
    {
        NSData *sessionData = [data subdataWithRange:NSMakeRange(3, data.length - 3)];
        
        WebsocketSession *session = [self findSessionByPort:destinationPort];
        
        [session inputData:sessionData];
        
    }
    else{
        NSLog(@"Error cmd");
    }
    

}

-(void)sessionClosed:(WebsocketSession*)session
{
    [self.sessions removeObjectForKey:@(session.port)];
}

-(void)toCloseSession:(WebsocketSession*)session
{
    uint8_t cmd = CMD_CLOSE;
    
    uint16_t port = htons(session.port);
    
    NSMutableData *temp = [NSMutableData data];
    [temp appendBytes:&cmd length: 1];
    [temp appendBytes:&port length:2];
    
    [inner send:temp];
    
    [self.sessions removeObjectForKey:@(session.port)];
}


-(WebsocketSession *)findSessionByPort:(uint16_t)port
{
    WebsocketSession *session = self.sessions[@(port)];
    return session;
}


- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Websocket Connection didCloseWithCode");
    
    NSAssert(self.delegate, @"");
    
    [self.delegate websocketConnectionDisconnected:self];
}

- (void)webSocketDidFlushOutput:(PSWebSocket *)webSocket
{
    
}

- (void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    NSLog(@"WebsocketConnection webSocketDidOpen");
    NSAssert(false, @"never could be here");
}

- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"WebsocketConnection didFailWithError");
    [self.delegate websocketConnectionDisconnected:self];
}

@end
