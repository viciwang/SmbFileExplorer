//
//  FileTransmissionModal.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionModal.h"

@implementation FileTransmissionModal

- (instancetype)initWithTransmissionType:(FileTransmissionType)type fromPath:(NSString*)fp toPath:(NSString*)tp
{
    self = [super init];
    if (self) {
        self.transmissionType = type;
        self.fromPath = fp;
        self.toPath = tp;
    }
    return self;
}

@end
