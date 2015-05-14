//
//  SmbFileViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmbFileCell.h"
#import "SmbFilesArrayDataSource.h"
#import "SmbFileOperateViewController.h"
#import "FileTransmissionViewController.h"
#import "LocalFileViewController.h"
#import "SmbCacheFilePresentationController.h"
#import "SmbCacheFileTransitioner.h"
#import "SettingViewController.h"
#import "SmbFileDetailViewController.h"
#import "SmbFileDetailTransitioner.h"

@interface SmbFileViewController : UITableViewController<UITextFieldDelegate,FileTransmissionProtocal,SmbFileArrayDelegate,SmbFileOperateDelegate,UIDocumentInteractionControllerDelegate,UIViewControllerTransitioningDelegate,SmbFileCacheDelegate,UIPopoverPresentationControllerDelegate,SettingDelegate>

@property (nonatomic,copy) NSString * path;
+(CGPoint) locationOfFirstToolbarButtonItem;
@end
