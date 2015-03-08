//
//  SmbAuthArrayDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/8.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"
#import "PersistenceManager.h"

static NSString * const UserDefaultKeyForSmbAuthItems = @"SmbAuthItems";

@class SmbAuth;

@interface SmbAuthArrayDataSource : ArrayDataSource

-(void)addAuthItem:(SmbAuth *)auth;
-(void)removeAuthAtIndex:(NSInteger)index;
-(void)updateAuthAtIndex:(NSInteger)index withAuth:(SmbAuth *)auth;
-(SmbAuth*)smbAuthAtIndex:(NSInteger)index;

@end