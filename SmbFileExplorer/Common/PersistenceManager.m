//
//  PersistenceManager.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "PersistenceManager.h"

static PersistenceManager * sPersistenceManager;

@implementation PersistenceManager

+(PersistenceManager *)sharedPersistenceManager
{
    static dispatch_once_t oncePersistenceToken;
    dispatch_once(&oncePersistenceToken,^{
        sPersistenceManager = [[PersistenceManager alloc]init];
    });
    return sPersistenceManager;
}

+(id)retrievalWithKey:(NSString *)key
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data != nil)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

+(void)saveData:(id)data forKey:(NSString *)key
{
    NSData * dataForSaving = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:dataForSaving forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
