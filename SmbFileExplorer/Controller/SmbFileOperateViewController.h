//
//  SmbFileOperateViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/9.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxSMBProvider.h"

@interface SmbFileOperateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (nonatomic, strong) KxSMBItemFile* smbFile;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadStatus;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@end
