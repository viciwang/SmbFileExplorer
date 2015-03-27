//
//  SmbFileOperateCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/15.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileOperateCell.h"

@interface SmbFileOperateCell()

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *protertyBtn;
@property (weak, nonatomic) IBOutlet UIButton *openModeBtn;

@end

@implementation SmbFileOperateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureCellWithDelegate:(UIViewController<SmbFileOperateDelegate> *)delegate
{
    if (self.smbFileOperateDelegate == nil)
    {
        self.smbFileOperateDelegate = delegate;
        [self.downloadBtn addTarget:self.smbFileOperateDelegate
                             action:@selector(downloadSmbFile:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self.deleteBtn addTarget:self.smbFileOperateDelegate
                           action:@selector(deleteSmbFile:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [self.protertyBtn addTarget:self.smbFileOperateDelegate
                             action:@selector(showPropertyOfSmbFile:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self.openModeBtn addTarget:self.smbFileOperateDelegate
                             action:@selector(showOpenModeOfSmbFile:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
