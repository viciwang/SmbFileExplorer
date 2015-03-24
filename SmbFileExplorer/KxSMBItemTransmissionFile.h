//
//  KxSMBItemTransmissionFile.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/24.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "KxSMBProvider.h"

// 为了能暂停下载，而重写KxSMBItem中的部分类
@interface KxSMBItemTransmissionFile : KxSMBItemFile

@property (atomic) BOOL shouldTransmissionSuspend;
-(instancetype)initWithKxSMBItemFile:(KxSMBItemFile *)file;
@end
