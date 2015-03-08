//
//  SmbAuth.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/3.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbAuth.h"

@implementation SmbAuth

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ipAddr forKey:@"ipAddr"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.workgroup forKey:@"workgroup"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.ipAddr = [aDecoder decodeObjectForKey:@"ipAddr"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.workgroup = [aDecoder decodeObjectForKey:@"workgroup"];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.ipAddr = @"new ip";
    }
    return self;
}

-(id)initWithIpAddr:(NSString *)ipAddr
            account:(NSString *)account
           password:(NSString *)psw
          workgroup:(NSString *)wg
{
    self = [super init];
    if(self)
    {
        self.ipAddr = ipAddr;  //[NSString stringWithFormat:@"smb://%@",ipAddr];
        self.account = account;
        self.password = psw;
        self.workgroup = wg;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    SmbAuth * auth = [[SmbAuth allocWithZone:zone]init];
    auth.ipAddr = self.ipAddr;
    auth.account = self.account;
    auth.password = self.password;
    auth.workgroup = self.workgroup;
    return auth;
    
}

@end
