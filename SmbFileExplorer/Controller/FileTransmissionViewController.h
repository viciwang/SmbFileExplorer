//
//  FileTransmissionViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmbFileTransmissionDataSource.h"
#import "FileTransmissionModal.h"
#import "FileTransmissionCell.h"

@class SmbFileViewController;

@protocol FileTransmissionProtocal <NSObject>

-(NSString*)currentSMBPath;

@end

@interface FileTransmissionViewController : UITableViewController

@property (nonatomic,strong) id<FileTransmissionProtocal> delegate;

+(FileTransmissionViewController*)shareFileTransmissionVC;
-(void)addTask:(FileTransmissionModal *)modal;


@end
