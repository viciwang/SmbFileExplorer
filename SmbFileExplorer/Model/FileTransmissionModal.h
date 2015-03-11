//
//  FileTransmissionModal.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FileTransmissionUpload,
    FileTransmissionDownload
}FileTransmissionType;

@interface FileTransmissionModal : NSObject
@property (nonatomic,strong) NSString * fromPath;
@property (nonatomic,strong) NSString * toPath;
@property (nonatomic) FileTransmissionType transmissionType;
@property (nonatomic) long long fileBytes;
@property (nonatomic) long long processedBytes;

- (instancetype)initWithTransmissionType:(FileTransmissionType)type fromPath:(NSString*)fp toPath:(NSString*)tp;
@end
