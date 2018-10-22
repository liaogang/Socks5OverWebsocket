//
//  ViewController.m
//  MyServer
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "ViewController.h"
#import "SOCKSProxyOverWebsocket.h"
#import "WebsocketServer.h"

NSString *bytesDescription(unsigned long long n)
{
    return [NSByteCountFormatter stringFromByteCount:n countStyle:NSByteCountFormatterCountStyleFile];
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionRefresh) userInfo:nil repeats:YES];

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)actionRefresh
{
    WebsocketConnection* connection = [WebsocketServer shared].connections.anyObject;
    
    
    
    self.uploadLabel.stringValue = bytesDescription( connection.totalBytesWritten);
    
    self.downloadLabel.stringValue =  bytesDescription( connection.totalBytesRead);
    
    self.aLabel.stringValue = [NSString stringWithFormat:@"%lu 个", connection.sessions.count ];
    
    
//    self.uploadLabel.stringValue = bytesDescription( [SOCKSProxyOverWebsocket shared].totalBytesWritten);
//
//    self.downloadLabel.stringValue =  bytesDescription( [SOCKSProxyOverWebsocket shared].totalBytesRead);
//
//    self.aLabel.stringValue = [NSString stringWithFormat:@"%lu 个",[SOCKSProxyOverWebsocket shared].connectionCount];
    
}

@end
