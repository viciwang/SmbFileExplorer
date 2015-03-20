//
//  SmbFileOperateViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/9.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxSMBProvider.h"
@class SmbFileViewController;

@protocol SmbFileCacheDelegate <NSObject>

-(void)fileHasCachedInPath:(NSString *)path;

@end

@interface SmbFileOperateViewController : UIViewController<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (nonatomic, strong) KxSMBItemFile* smbFile;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) id<SmbFileCacheDelegate> delegate;
@property (nonatomic,strong) NSString * filePath;

-(void)configureWithSmbFile:(KxSMBItemFile *)smbFile delegate:(id<SmbFileCacheDelegate>)delegate;
@end
