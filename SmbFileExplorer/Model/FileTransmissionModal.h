//
//  FileTransmissionModal.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemStuff.h"
#import "KxSMBProvider.h"



@class FileTransmissionViewController;

typedef enum {
    FileTransmissionUpload,
    FileTransmissionDownload
}FileTransmissionType;


@interface FileTransmissionModal : NSObject<NSCoding>

@property (nonatomic) FileTransmissionType transmissionType;
@property (nonatomic,strong) NSString * fromPath;
@property (nonatomic,strong) NSString * toPath;
@property (nonatomic) long long fileBytes;
@property (nonatomic) long long processedBytes;
@property (nonatomic) BOOL isProcessing;

- (instancetype)initWithTransmissionType:(FileTransmissionType)type fromPath:(NSString*)fp toPath:(NSString*)tp withInfo:(id)info;
-(void)begin;
-(void)suspend;
@end
