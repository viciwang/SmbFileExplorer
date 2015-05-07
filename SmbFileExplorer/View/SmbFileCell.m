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

static NSDictionary * gFileExtensionImageDic;

@implementation SmbFileCell


+(NSDictionary *)FileExtensionImageDic
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gFileExtensionImageDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"file_doc.png",@"doc",
                                  @"file_doc.png",@"docx",
                                  @"file_pdf",@"pdf",
                                  @"file_exc",@"xls",
                                  @"file_exc",@"xlsx",
                                  @"file_ppt",@"ppt",
                                  @"file_image",@"png",
                                  @"file_image",@"jpg",
                                  @"file_image",@"jpeg",
                                  @"file_image",@"bmp",
                                  @"file_pdf",@"pdf",
                                  @"file_rar",@"rar",
                                  @"file_rar",@"zip",
                                  @"file_folder",@"folder",nil];
        //@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil
    });
    return gFileExtensionImageDic;
}

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
    NSString * fileExtension = [self.fileName.text pathExtension];
    self.fileTypePic.image = [UIImage imageNamed:[self imageNameFromFileExtension:fileExtension]];
    
}

-(NSString *)imageNameFromFileExtension:(NSString*)fileExtension
{
    if([fileExtension isEqualToString:@""])
    {
        fileExtension = @"folder";
    }
    NSString * pic = [[SmbFileCell FileExtensionImageDic]objectForKey:fileExtension];
    if (pic==nil)
    {
        pic = @"file_unknow.png";
    }
    return pic;
}

@end
