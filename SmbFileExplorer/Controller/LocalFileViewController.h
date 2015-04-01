//
//  LocalFileViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayDataSource.h"
#import "FileTransmissionViewController.h"
#import "FileTransmissionModal.h"
#import "LocalFileCell.h"
#import "LocalFileDataSource.h"

@interface LocalFileViewController : UITableViewController<LocalFileDelegate,UIDocumentInteractionControllerDelegate>

@end
