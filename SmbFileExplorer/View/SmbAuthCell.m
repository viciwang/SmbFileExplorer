//
//  SmbAuthCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbAuthCell.h"


@implementation SmbAuthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)configureForSmbAuth:(SmbAuth *)auth
{
    self.textLabel.text = auth.ipAddr;
}

@end
