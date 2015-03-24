//
//  SmbFileCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileCell.h"

@implementation SmbFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureForSmbFile:(KxSMBItem *)item
{
    self.textLabel.text = item.path.lastPathComponent;
    
    if ([item isKindOfClass:[KxSMBItemTree class]])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.text =  @"";
    }
    else
    {
        NSLog(@"%@  :::: mode %ld",item.path,item.stat.mode);
        self.accessoryType = UITableViewCellAccessoryDetailButton;
        self.detailTextLabel.text = [NSString stringWithFormat:@"%ld", item.stat.size];
    }
}

@end
