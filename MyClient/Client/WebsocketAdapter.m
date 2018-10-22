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


#define CMD_CLOSE   0x00
#define CMD_Create  0x01
#define CMD_Forward 0x10



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

    uint8_t cmd;
    memcpy(&cmd, [data bytes], 1);

    uint16_t rawPort ;
    memcpy(&rawPort, [data bytes]+1, 2);
    uint16_t destinationPort = NSSwapBigShortToHost(rawPort);
    
    
    NSData *sessionData = [data subdataWithRange:NSMakeRange(3, data.length - 3)];
    
    NSLog(@"websocket session data");
    printHexData(sessionData);
    
    if (cmd == CMD_Create )
    {
        WebsocketSession *newSession = [[WebsocketSession alloc] initWithParent:self];
        newSession.port = destinationPort;
        
        self.sessions[@(destinationPort)] = newSession;
        
        [newSession inputData:sessionData];
        
    }
    else if( cmd == CMD_Forward )
    {
        WebsocketSession *session = [self findSessionByPort:destinationPort];
        [session inputData:sessionData];
    }
    else if( cmd == CMD_CLOSE )
    {
        WebsocketSession *session = [self findSessionByPort:destinationPort];
        [self closeSession:session];
    }
    else{
        NSLog(@"Error unknown cmd");
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
    uint8_t cmd = CMD_Forward;
    
    uint16_t port = htons(session.port);
    
    NSMutableData *temp = [NSMutableData data];
    [temp appendBytes:&cmd length: 1];
    [temp appendBytes:&port length:2];
    [temp appendData:data];
    
    [inner send:temp];
}


-(void)closeSession:(WebsocketSession*)session
{
    uint8_t cmd = CMD_CLOSE;
    
    uint16_t port = htons(session.port);
    
    NSMutableData *temp = [NSMutableData data];
    [temp appendBytes:&cmd length: 1];
    [temp appendBytes:&port length:2];
    
    [inner send:temp];
    
    
    [self.sessions removeObjectForKey:@(session.port)];
}

@end

