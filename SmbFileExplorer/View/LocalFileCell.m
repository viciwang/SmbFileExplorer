//
//  LocalFileCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "LocalFileCell.h"
#import "LocalFileDataSource.h"

@interface LocalFileCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;
@property (weak, nonatomic) id<LocalFileDelegate> delegate;
@end


@implementation LocalFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteFile:(id)sender
{
    [self.delegate deleteFileForCell:self];
}

- (IBAction)uploadFile:(UIButton *)sender
{
    [self.delegate uploadFileForCell:self];
}

- (IBAction)openFile:(UIButton *)sender
{
    [self.delegate openFileForCell:self];
}

-(void)configureForLocalFileModal:(LocalFileModal *)file andDelegate:(id<LocalFileDelegate>) delegate
{
    self.fileName.text = [file.path lastPathComponent];
    self.fileSize.text = [SystemStuff stringFromFileSizeBytes:file.fileSize];
    self.delegate = delegate;
}

@end
