//
//  WebsocketSession.h
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebsocketSession;

@protocol WebsocketSessionDelegate <NSObject>
@required;
- (void) websocketSession:(WebsocketSession *)session didReadData:(NSData *)data withTag:(long)tag;

- (void) websocketSession:(WebsocketSession *)session didWriteData:(NSData *)data withTag:(long)tag;
@end

@class WebsocketAdapter;

@interface WebsocketSession : NSObject

-(instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithParent:(WebsocketAdapter*)parent;

@property (nonatomic ) uint16_t port;

-(void)inputData:(NSData*)data;

@property (nonatomic,weak) id<WebsocketSessionDelegate> delegate;

-(void)disconnect;

-(void)disconnectAfterWriting;

- (void)readDataToLength:(NSUInteger)length tag:(long)tag;

- (void)readDataWithTag:(long)tag;

- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag ;

-(void)writeData:(NSData*)data withTag:(long)tag;

- (void) writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag ;

@end
