//
//  SmbFileCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileCell.h"

@interface SmbFileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *fileTypePic;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedDate;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;

@end

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
    self.fileName.text = item.path.lastPathComponent;
    SystemStuff * systemStuff = [SystemStuff shareSystemStuff];
    if ([item isKindOfClass:[KxSMBItemTree class]])
    {
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.fileSize.text =  @"";
        
    }
    else
    {
       // self.accessoryType = UITableViewCellAccessoryNone;
        self.fileSize.text = [SystemStuff stringFromFileSizeBytes:item.stat.size];
    }
    self.lastModifiedDate.text = [systemStuff stringFromDate:item.stat.lastModified];
    self.fileTypePic.image = [UIImage imageNamed:[self imageNameFromFileName:self.fileName.text]];
    
}

-(NSString *)imageNameFromFileName:(NSString*)fileName
{
    return [NSString stringWithFormat:@"FileType%@",[fileName pathExtension]];
}

@end
