//
//  FileTransmissionCell.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionCell.h"
#import "FileTransmissionModal.h"

@implementation FileTransmissionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureForTask:(FileTransmissionModal *)task
{

    self.transmissionModal = task;
    self.progressBar.progress = (double)task.processedBytes/(double)task.fileBytes;
    self.procressedLabel.text = [NSString stringWithFormat:@"%@/%@",[self describeForByte:task.processedBytes],[self describeForByte:task.fileBytes]];
    self.processedPercentLabel.text = [NSString stringWithFormat:@"%li%%",(long)(self.progressBar.progress*100)];
    self.fileName.text = task.fromPath.lastPathComponent;
    self.fileImage.image = [UIImage imageNamed:[[SystemStuff shareSystemStuff]imageNameFromFileExtension:[self.fileName.text pathExtension]]];
}


-(NSString *)describeForByte:(unsigned long long) b
{
    CGFloat value;
    NSString *unit;
    
    if (b < 1024)
    {
        value = b;
        unit = @"B";
        
    }
    else if (b < 1048576)
    {
        value = b / 1024.f;
        unit = @"KB";
    }
    else
    {
        value = b / 1048576.f;
        unit = @"MB";
    }
    
    return [NSString stringWithFormat:@"%.2f%@",
                               value,unit];
}


- (IBAction)suspendOrResume:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    if (self.transmissionModal.isProcessing == YES)
    {
        [self.transmissionModal suspend];
        [button setImage:[UIImage imageNamed:@"manager_start.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.transmissionModal begin];
        [button setImage:[UIImage imageNamed:@"manager_stop.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)cancelTransmission:(id)sender
{
    [self.transmissionModal cancel];
}
@end
