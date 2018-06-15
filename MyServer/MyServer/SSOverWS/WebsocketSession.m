//
//  WebsocketSession.m
//  MyServer
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketSession.h"

typedef NS_ENUM(NSUInteger, ReaderType) {
    Invalide,
    None,
    OneTime,
    Length,
};


@interface WebsocketSession ()
{
    ReaderType readerType;
    NSUInteger readerLength;
    long readerTag;
}
@property (nonatomic, weak) MyPSWebSocket *parent;
@property (nonatomic, strong) NSMutableData *cache;
@end

@implementation WebsocketSession

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(false, @"");
    }
    return self;
}

-(instancetype)initWithMyPSWebSocket:(MyPSWebSocket*)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        self.cache = [NSMutableData data];
    }
    return self;
}

-(void)inputData:(NSData*)data
{
    [self.cache appendData:data];
    
    [self tryReader];
}

-(void)tryReader{
    
    NSUInteger cacheLength = self.cache.length ;
    if (readerType == Length) {
        
        if (cacheLength == readerLength) {
        
            NSData *temp = [self.cache copy];
            self.cache = [NSMutableData data];
            
            NSUInteger tag = readerTag;
            [self resetReader];
            
            
            [self.delegate websocketSession:self didReadData:temp withTag: tag ];
        }
        else if ( cacheLength > readerLength) {
            
            NSData *data = [self.cache subdataWithRange:NSMakeRange(0, readerLength)];
            self.cache = [[self.cache subdataWithRange: NSMakeRange(readerLength, cacheLength - readerLength)] mutableCopy];
            NSUInteger tag = readerTag;
            [self resetReader];
            
            [self.delegate websocketSession:self didReadData:data withTag: tag ];
        }
        else{
            //wait more data coming
        }
        
    }
    else if(readerType == OneTime){
        
        
        NSData *data = [self.cache copy];
        self.cache = [NSMutableData data];
        NSUInteger tag = readerTag;
        [self resetReader];
        
        
        [self.delegate websocketSession:self didReadData:data withTag: tag ];
        
    }
    
    
}

- (void) readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self readDataWithTag:tag];
}

- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self readDataToLength:length tag:tag];
}

- (void)readDataToLength:(NSUInteger)length tag:(long)tag
{
    readerType = Length;
    readerLength = length;
    readerTag = tag;
    [self tryReader];
}


-(void)resetReader{
    readerType = None;
    readerLength = 0;
}

- (void)readDataWithTag:(long)tag
{
    readerType = OneTime;
    readerLength = 0;
    readerTag = tag;
}

- (void) writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self writeData:data withTag:tag];
}

-(void)writeData:(NSData*)data withTag:(long)tag
{
    NSLog(@"write %lu bytes tunnel %d: ",(unsigned long)data.length,self.port);
    if (tag >= 10400) {
    }
    else{
        printHexData(data);
    }
    
    
    [_parent sendData:data bySession:self];
    [self.delegate websocketSession:self didWriteData:data withTag:tag];
}

-(void)createRemoteSession
{
    [_parent createRemoteSessionbySession:self];
}

-(void)disconnect
{
    [self.parent toCloseSession:self];
}
@end
