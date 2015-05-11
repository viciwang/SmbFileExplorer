//
//  PersistenceManager.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const UserDefaultKeyForSmbAuthItems = @"SmbAuthItems";
static NSString * const UserDefaultKeyForUploadModal = @"UploadModal";
static NSString * const UserDefaultKeyForDownloadModal = @"DownloadModal";


@interface PersistenceManager : NSObject

+(PersistenceManager *)sharedPersistenceManager;
+(id)retrievalWithKey:(NSString *)key;
+(void)saveData:(id)data forKey:(NSString *)key;
@end
