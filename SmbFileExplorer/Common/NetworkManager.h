//
//  NetworkManager.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/12.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import <netdb.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface NetworkManager : NSObject

+(NSString *)ipAddrForHostName:(NSString *)hostName;
+(BOOL) isAHostName:(NSString *)hostName;
@end
