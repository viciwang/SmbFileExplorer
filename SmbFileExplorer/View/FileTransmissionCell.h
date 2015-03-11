//
//  FileTransmissionCell.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileTransmissionModal.h"

@interface FileTransmissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *procressedLabel;
@property (weak, nonatomic) IBOutlet UILabel *processedPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileName;

-(void)configureForTask:(FileTransmissionModal *)task;

@end
