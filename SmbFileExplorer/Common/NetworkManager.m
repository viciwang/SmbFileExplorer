//
//  NetworkManager.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/12.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+(NSString *)ipAddrForHostName:(NSString *)hostName
{
    CFStringRef sRef =  CFStringCreateWithCString(kCFAllocatorDefault, [hostName cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);
    CFHostRef ref = CFHostCreateWithName(kCFAllocatorDefault, sRef);
    CFHostSetClient(ref, NULL, NULL);
    
    CFStreamError error;
    Boolean success =  CFHostStartInfoResolution(ref, kCFHostAddresses, &error);
    if (success)
    {
        CFArrayRef addresses = CFHostGetAddressing(ref, nil);
        
        struct sockaddr  *addr;
        char             ipAddress[INET6_ADDRSTRLEN];
        CFIndex          index, count;
        int              err;
        
        assert(addresses != NULL);
        count = CFArrayGetCount(addresses);
        for (index = 0; index < count; index++)
        {
            addr = (struct sockaddr *)CFDataGetBytePtr(CFArrayGetValueAtIndex(addresses, index));
            assert(addr != NULL);
            
            /* getnameinfo coverts an IPv4 or IPv6 address into a text string. */
            err = getnameinfo(addr, addr->sa_len, ipAddress, INET6_ADDRSTRLEN, NULL, 0, NI_NUMERICHOST);
            if (err == 0)
            {
                NSLog(@"解析到ip地址：%s\n", ipAddress);
            }
            else
            {
                NSLog(@"地址格式转换错误：%d\n", err);
            }
        }
        return    [[NSString alloc] initWithFormat:@"%s",ipAddress];//这里只返回最后一个，一般认为只有一个地址
    }
    else
    {
        return nil;
    }
}

+(BOOL) isAHostName:(NSString *)hostName
{
    if ([NetworkManager isAIpAddr:hostName])
    {
        return NO;
    }
    return YES;
}

+(BOOL) isAIpAddr:(NSString *)host
{
    NSArray * array = [host componentsSeparatedByString:@"."];
    if (array.count !=4)
    {
        return NO;
    }
    for (NSString * com in array)
    {
        NSInteger i = [com integerValue];
        if (0>i&&i>255)
        {
            return NO;
        }
    }
    return YES;
}

@end
