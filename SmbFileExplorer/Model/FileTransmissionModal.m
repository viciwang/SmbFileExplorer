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
        if(type == FileTransmissionDownload)
        {
            
        }
        else
        {
            self.fileBytes = [self fileSizeAtPath:self.fromPath];
        }
    }
    return self;
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



@end
