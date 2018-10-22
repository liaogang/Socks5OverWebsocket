//
//  ViewController.h
//  MyServer
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *aLabel;

@property (weak) IBOutlet NSTextField *uploadLabel;

@property (weak) IBOutlet NSTextField *downloadLabel;

@property (nonatomic,strong) NSTimer *timer;


@end

