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

@interface SmbFileViewController : UITableViewController

@property (nonatomic,copy) NSString * path;

@end
