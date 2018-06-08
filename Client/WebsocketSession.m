//
//  WebsocketSession.m
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "WebsocketSession.h"
#import "WebsocketAdapter.h"

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
@property (nonatomic, strong) NSMutableData *cache;
@property (nonatomic, weak) WebsocketAdapter *parent;
@end

@implementation WebsocketSession
- (instancetype)initWithParent:(WebsocketAdapter*)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        
               self.cache = [NSMutableData data];
        
    }
    return self;
}











-(void)tryReader{
    
    NSUInteger cacheLength = self.cache.length ;
    if (readerType == Length) {
        
        if (cacheLength == readerLength) {
            [self.delegate websocketSession:self didReadData:self.cache withTag: readerTag ];
            self.cache = [NSMutableData data];
            [self resetReader];
        }
        else if ( cacheLength > readerLength) {
            
            NSData *data = [self.cache subdataWithRange:NSMakeRange(0, readerLength)];
            
            self.cache = [[self.cache subdataWithRange: NSMakeRange(readerLength, cacheLength - readerLength)] mutableCopy];
            
            [self.delegate websocketSession:self didReadData:data withTag: readerTag ];
            [self resetReader];
        }
        else{
            
            
        }
        
    }
    else if(readerType == OneTime){
        
        [self.delegate websocketSession:self didReadData:self.cache withTag: readerTag ];
        self.cache = [NSMutableData data];
        
        [self resetReader];
    }
    
    
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
}


- (void) writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self writeData:data withTag:tag];
}

-(void)writeData:(NSData*)data withTag:(long)tag
{
    [_parent sendData:data bySession:self];
    [self.delegate websocketSession:self didWriteData:data withTag:tag];
}


@end
