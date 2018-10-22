//
//  ViewController.m
//  Client
//
//  Created by liaogang on 2018/6/7.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "ViewController.h"
//#import "SOCKSProxyWSAdapter.h"
#import "AYFlowMgr.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;

@property (nonatomic,strong) NSTimer *timer;
@end

NSString *bytesDescription(unsigned long long n);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionRefresh) userInfo:nil repeats:YES];
}


- (void)actionRefresh
{
    self.uploadLabel.text = bytesDescription([AYFlowMgr shared].totalBytesRead);
    
    self.downloadLabel.text =  bytesDescription( [AYFlowMgr shared].totalBytesWritten);
    
    self.aLabel.text = [NSString stringWithFormat:@"%lu 个",[AYFlowMgr shared].activeConnections];
}

@end


NSString *bytesDescription(unsigned long long n)
{
    return [NSByteCountFormatter stringFromByteCount:n countStyle:NSByteCountFormatterCountStyleFile];
}

