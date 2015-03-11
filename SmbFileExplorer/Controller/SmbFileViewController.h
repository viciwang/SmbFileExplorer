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
#import "CustomerPresentationController.h"
#import "FileTransmissionViewController.h"
#import "ChooseLocalFileViewController.h"

@interface SmbFileViewController : UITableViewController<UITextFieldDelegate,FileTransmissionProtocal>

@property (nonatomic,copy) NSString * path;

@end
