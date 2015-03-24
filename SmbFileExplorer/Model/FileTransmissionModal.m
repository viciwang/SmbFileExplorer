//
//  FileTransmissionModal.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionModal.h"
#import "KxSMBProvider.h"
#import "FileTransmissionViewController.h"

@interface FileTransmissionModal ()

@property (nonatomic,copy) KxSMBBlockProgress progressBlock;
@property (nonatomic,copy) KxSMBBlock resultBlock;
@property (nonatomic,strong) KxSMBItemFile * smbFile;
@property (nonatomic,strong) NSFileHandle * fileHandle;
@end

@implementation FileTransmissionModal


// topath and frompath must't be a floder , must be a file's path.
- (instancetype)initWithTransmissionType:(FileTransmissionType)type fromPath:(NSString*)fp toPath:(NSString*)tp withInfo:(id)info
{
    self = [super init];
    if (self) {
        self.transmissionType = type;
        self.fromPath = fp;
        self.toPath = tp;
        if(type == FileTransmissionDownload)
        {
            self.toPath = [self pathWithoutConflict:self.toPath isLocalFile:YES];
            KxSMBItemStat * stat = (KxSMBItemStat *)info;
            if(stat)
            {
                self.fileBytes = stat.size;
            }
        }
        else
        {
            self.fileBytes = [self fileSizeAtPath:self.fromPath];
        }
        
        self.progressBlock = ^(KxSMBItem * item,long transferred){
            
            [[[FileTransmissionViewController shareFileTransmissionVC] ftDatasource] updateSFTItemAtPath:item.path withTransferred:transferred];
        };
        
        self.resultBlock = ^(id result){
            if ([result isKindOfClass:[NSError class]])
            {
                NSLog(@"传输出错！！！！！！！！%@",(NSError*)result );
            }
            else
            {
                [[[FileTransmissionViewController shareFileTransmissionVC] ftDatasource] removeSFTItemAtPath:nil];
            }
        };
    }
    return self;
}

-(NSString*)pathWithoutConflict:(NSString *)path isLocalFile:(BOOL)isLocalFile
{
    
    if (isLocalFile == YES)
    {
        NSFileManager * fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path])
        {
            return path;
        }
        else
        {
            NSString * name = [[path lastPathComponent] stringByDeletingPathExtension];
            NSString * extension = [path pathExtension];
            NSArray * array = [fm subpathsAtPath:[SystemStuff stringForPathOfDocumentPath]];
            NSString * temName;
            for (int i = 1; 1; i++)
            {
                temName = [NSString stringWithFormat:@"%@(%i).%@",name,i,extension];
                if (![array containsObject:temName])
                {
                    break;
                }
            }
            return [NSString stringWithFormat:@"%@/%@",[path stringByDeletingLastPathComponent],temName];
        }
    }
    else
    {
        return path;
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath
{
    if (self.transmissionType == FileTransmissionUpload)
    {
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath])
        {
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return 0;
}

-(void)begin
{
    if (self.transmissionType == FileTransmissionDownload)
    {
        self.smbFile.shouldTransmissionSuspend = NO;
        [self copySingleSMBPath:self.fromPath
                      localPath:self.toPath
                      overwrite:YES
                         offset:0
                       progress:self.progressBlock
                          block:self.resultBlock];
        
    }
    else
    {
        [self copySingleLocalPath:self.fromPath
                          SMBPath:self.toPath
                        overwrite:YES
                           offset:0
                         progress:self.progressBlock
                            block:self.resultBlock];
        
//        [[KxSMBProvider sharedSmbProvider]copyLocalPath:self.fromPath
//                                                smbPath:self.toPath
//                                              overwrite:YES
//                                               progress:self.progressBlock
//                                                  block:self.resultBlock];
    }
    self.isProcessing = YES;
}

-(void)suspend
{
    self.smbFile.shouldTransmissionSuspend = YES;
//    if (self.fileHandle)
//    {
//        
//        [self.fileHandle closeFile];
//        self.fileHandle = nil;
//    }
    [self.smbFile close];
    self.isProcessing = NO;
}


// 下载单个文件，从偏移量处开始
- (void) copySingleSMBPath:(NSString *)smbPath
                 localPath:(NSString *)localPath
                 overwrite:(BOOL)overwrite
                    offset:(off_t) offset
                  progress:(KxSMBBlockProgress)progress
                     block:(KxSMBBlock)block
{
    [[KxSMBProvider sharedSmbProvider] fetchAtPath:smbPath block:^(id result) {
        if ([result isKindOfClass:[KxSMBItemFile class]])
        {
            self.smbFile = (KxSMBItemFile*)result;
            if (self.fileHandle == nil)
            {
                if ([[NSFileManager defaultManager]fileExistsAtPath:localPath])
                {
                    self.fileHandle = [NSFileHandle fileHandleForUpdatingURL:[NSURL fileURLWithPath:localPath]
                                                          error:nil];
                }
                else
                {
                    self.fileHandle = [KxSMBProvider createLocalFile:localPath
                                                           overwrite:NO
                                                               error:nil];
                }
            }
            off_t ofs = [self.fileHandle seekToEndOfFile];
            NSLog(@"%lli",ofs);
            //KxSMBItemFile * file = (KxSMBItemFile *)result;
            [self.smbFile seekToFileOffset:ofs whence:0];
            [KxSMBProvider readSMBFile:self.smbFile
                            fileHandle:self.fileHandle
                              progress:progress
                                 block:block];
        }
        else
        {
            NSDictionary * errorMsg = [NSDictionary dictionaryWithObject:@"smbPath is not a path for smbFile"  forKey:@"ErrorMsg"];
            block([NSError errorWithDomain:@"SmbPathError" code:123 userInfo:errorMsg]);
        }
    }];
}

// 上传单个文件，从偏移量处开始
- (void) copySingleLocalPath:(NSString *)localPath
                 SMBPath:(NSString *)smbPath
                 overwrite:(BOOL)overwrite
                    offset:(off_t) offset
                  progress:(KxSMBBlockProgress)progress
                     block:(KxSMBBlock)block
{
    
    [[KxSMBProvider sharedSmbProvider] fetchAtPath:smbPath block:^(id result) {
//        if ([result isKindOfClass:[KxSMBItemFile class]])
//        {
//            self.smbFile = result;
//            
//            NSLog(@"state is -=-=--=-==-=-== :%@",self.smbFile.stat);
//            
//            NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:localPath];
//            [fh seekToFileOffset:1024];
//            
//            [self.smbFile seekToFileOffset:1024 whence:0];
//            
//           
//            [KxSMBProvider writeSMBFile:self.smbFile
//                             fileHandle:fh
//                               progress:progress
//                                  block:block];
//        }
//        else
//        {
            id rr = [[KxSMBProvider sharedSmbProvider]createFileAtPath:smbPath overwrite:NO];
            if ([rr isKindOfClass:[KxSMBItemFile class]])
            {
                self.smbFile = rr;
                NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:localPath];
                NSLog(@"state is -=-=--=-==-=-== :%@",self.smbFile.stat);
                [KxSMBProvider writeSMBFile:self.smbFile
                                 fileHandle:fh
                                   progress:progress
                                      block:block];
            }
            else
            {
                NSDictionary * errorMsg = [NSDictionary dictionaryWithObject:@"smbPath is not a path for smbFile"
                                                                      forKey:@"ErrorMsg"];
                block([NSError errorWithDomain:@"SmbPathError"
                                          code:123
                                      userInfo:errorMsg]);
            }
//        }
    }];
    
    

}

@end
