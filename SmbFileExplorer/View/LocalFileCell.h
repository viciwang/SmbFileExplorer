//
//  LocalFileCell.h
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemStuff.h"
@class LocalFileModal;
@class  LocalFileCell;
@protocol LocalFileDelegate <NSObject>

-(void)deleteFileForCell:(LocalFileCell *)cell;
-(void)uploadFileForCell:(LocalFileCell *)cell;
-(void)openFileForCell:(LocalFileCell *)cell;

@end

@interface LocalFileCell : UITableViewCell
-(void)configureForLocalFileModal:(LocalFileModal *)file andDelegate:(id<LocalFileDelegate>) delegate;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@end
