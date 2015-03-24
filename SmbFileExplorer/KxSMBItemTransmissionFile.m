//
//  KxSMBItemTransmissionFile.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/24.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "KxSMBItemTransmissionFile.h"

@interface KxSMBItemTransmissionFile()
@property (nonatomic,strong)    KxSMBItemFile * file;
@end


@implementation KxSMBItemTransmissionFile{

}


-(instancetype)initWithKxSMBItemFile:(KxSMBItemFile *)file
{
    self = [super init];
    if (self)
    {
        self.file = file;
    }
    return self;
}

- (void)readDataOfLength:(NSUInteger)length
                   block:(KxSMBBlock)block
{
    
    NSParameterAssert(block);
    
//    if (!_impl)
//        _impl = [[KxSMBFileImpl alloc] initWithPath:self.path];
//    
//    KxSMBFileImpl *p = _impl;
//    KxSMBProvider *provider = [KxSMBProvider sharedSmbProvider];
//    [provider dispatchAsync:^{
//        
//        id result = [p readDataOfLength:length];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            block(result);
//        });
//    }];
    if (!self.shouldTransmissionSuspend)
    {
        [super readDataOfLength:length block:block];
    }
    
}

@end
