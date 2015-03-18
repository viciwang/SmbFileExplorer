//
//  SmbFileOperateCell.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/15.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SmbFileOperateDelegate <NSObject>

-(void)downloadSmbFile:(id)button;
-(void)deleteSmbFile:(id)button;
-(void)showPropertyOfSmbFile:(id)button;
-(void)previewSmbFile:(id)button;
-(void)showOpenModeOfSmbFile:(id)button;


@end

@interface SmbFileOperateCell : UITableViewCell


@property (nonatomic,weak) UIViewController<SmbFileOperateDelegate> * smbFileOperateDelegate;
-(void)configureCellWithDelegate:(UIViewController<SmbFileOperateDelegate> *)delegate;


@end
