//
//  WebsocketSession.m
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketSession.h"
#import "WebsocketAdapter.h"
#import "SOCKSProxyWSAdapter.h"
#import "PrintHex.h"

typedef NS_ENUM(NSUInteger, ReaderType) {
    Invalide,
    None,
    OneTime,
    Length,
};

@interface WebsocketSession ()
<SOCKSProxyWSAdapterDelegate>
{
    ReaderType readerType;
    NSUInteger readerLength;
    long readerTag;
    
    BOOL disconnectAfterWriting;
}
@property (nonatomic, strong) NSMutableData *cache;

@property (nonatomic, weak) WebsocketAdapter *parent;

@property (nonatomic,strong) SOCKSProxyWSAdapter *adapter;
@end

@implementation WebsocketSession
- (instancetype)initWithParent:(WebsocketAdapter*)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        
        self.cache = [NSMutableData data];
        
        self.adapter = [[SOCKSProxyWSAdapter alloc] initWithWebSocket:self delegate: self ];
        
    }
    return self;
}

-(void)inputData:(NSData*)data
{
//    if ( readerType == OneTime) {
//        NSLog(@"input data from tunnel: %d",self.port);
//    }
//    else{
//        NSLog(@"input data from tunnel: %d",self.port);
//        //printHexData(data);
//    }
    
//    printHexData(data);
    
    [self.cache appendData:data];
    
    [self tryReader];
}

-(void)disconnect
{
    [self.parent closeSession:self];
}

-(void)disconnectAfterWriting
{
    disconnectAfterWriting = YES;
}

-(void)tryReader{
    
//    NSLog(@"tunnel %d, try reader, type: %lu, length:%lu,tag: %ld",self.port,(unsigned long)readerType,(unsigned long)readerLength,readerTag);
//
//    if (readerType == 3 && readerLength == 4  && readerTag == 10200) {
//        printf("debug\n");
//    }
    
    NSUInteger cacheLength = self.cache.length ;
    if (readerType == Length) {
        
        //NSLog(@"cache length:  %lu,reader length: %lu",(unsigned long)cacheLength,(unsigned long)readerLength);
        
        if ( cacheLength == readerLength) {
            
            //NSLog(@"cacheLength == readerLength: delegate:%p",self.delegate);
            
            NSData *copy = [self.cache copy];
            self.cache = [NSMutableData data];
            [self resetReader];
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate websocketSession:self didReadData:copy withTag: readerTag ];
            //});
            
        }
        else if ( cacheLength > readerLength) {
            
            NSData *data = [self.cache subdataWithRange:NSMakeRange(0, readerLength)];
            
            self.cache = [[self.cache subdataWithRange: NSMakeRange(readerLength, cacheLength - readerLength)] mutableCopy];
            
            //NSLog(@"cacheLength > readerLength: delegate: %@",self.delegate);
            [self resetReader];
            [self.delegate websocketSession:self didReadData:data withTag: readerTag ];
        }
        else{
            
            
        }
        
    }
    else if(readerType == OneTime){
        
        NSData *temp = [self.cache copy];
        self.cache = [NSMutableData data];
        
        //NSLog(@"resetReader one time ");
        
        [self resetReader];
        NSUInteger tag = readerTag;
        
       // dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate websocketSession:self didReadData:temp withTag: tag ];
       // });
        
    }
    
    
}


- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self readDataToLength:length tag:tag];
}

-(void)readDataToLength:(NSUInteger)length tag:(long)tag
{
    NSLog(@"tunnel:%d read data:%lu",self.port,(unsigned long)length );
    NSLog(@"readData with length");

    
    readerType = Length;
    readerLength = length;
    readerTag = tag;
    [self tryReader];
}


-(void)resetReader{
//    NSLog(@"resetReader");
    readerType = None;
    readerLength = 0;
}

- (void)readDataWithTag:(long)tag
{
//    NSLog(@"readData One Time");
    
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
//    if (tag >= 10400) {
//        NSLog(@"write %lu bytes to tunnel: %d",(unsigned long)data.length,self.port);
//    }
//    else{
//        NSLog(@"write data to tunnel: %d",self.port);
//        printHexData(data);
//    }
    
    
    
    [_parent sendData:data bySession:self];
    [self.delegate websocketSession:self didWriteData:data withTag:tag];
    
    if (disconnectAfterWriting) {
        [self disconnect];
    }
}

- (BOOL) proxySocket:(SOCKSProxyWSAdapter*)proxySocket
checkAuthorizationForUser:(NSString*)username
            password:(NSString*)password
{
    if ([username isEqualToString:@"123"] && [password isEqualToString:@"123"]) {
        return YES;
    }
    else{
        return NO;
    }

}

@end
