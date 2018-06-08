//
//  PrintHex.m
//  Client
//
//  Created by liaogang on 2018/6/8.
//  Copyright © 2018年 liaogang. All rights reserved.
//

#import "PrintHex.h"

void printBufferToHex(Byte *buffer,int length)
{
    NSString *str = @"";
    
    for (int i = 0; i < length; i ++) {
        str = [str stringByAppendingFormat:@" %02x", buffer[i] ];
    }
    
    NSLog(@"%@",str);
}

void printHexData(NSData *data)
{
    printBufferToHex(data.bytes, data.length);
}
