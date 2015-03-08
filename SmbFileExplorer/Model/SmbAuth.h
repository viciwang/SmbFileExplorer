//
//  SmbAuth.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/3.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmbAuth : NSObject <NSCoding,NSCopying>

@property (nonatomic,copy) NSString * ipAddr;
@property (nonatomic,copy) NSString * account;
@property (nonatomic,copy) NSString * password;
@property (nonatomic,copy) NSString * workgroup;

-(id)initWithIpAddr:(NSString *)ipAddr
            account:(NSString *)account
           password:(NSString *)psw
          workgroup:(NSString *)wg;



@end
