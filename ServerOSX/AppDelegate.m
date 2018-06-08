//
//  AppDelegate.m
//  ServerOSX
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "AppDelegate.h"
#import "WebsocketServer.h"
#import "SOCKSProxyOverWebsocket.h"


@interface AppDelegate ()
@property (nonatomic,strong) SOCKSProxyOverWebsocket *socksServer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    //start socks server
    //self.socksServer = [[SOCKSProxy alloc] init];
    //    [self.socksServer addAuthorizedUser:@"lg" password:@"123123123"];
    //[self.socksServer startProxyOnPort: 8050 ];
    self.socksServer = [[SOCKSProxyOverWebsocket alloc] init];
    [self.socksServer startProxyOnPort:9090];
        
    [WebsocketServer shared]; //9091
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



@end
