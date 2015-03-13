//
//  SmbFileTransmissionDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileTransmissionDataSource.h"
#import "FileTransmissionViewController.h"

@interface  SmbFileTransmissionDataSource()

@property (nonatomic,copy) KxSMBBlockProgress progressBlock;
@property (nonatomic,copy) KxSMBBlock resultBlock;

@end

@implementation SmbFileTransmissionDataSource


-(id)initWithItem:(NSMutableArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(TableViewCellConfigureBlock)block
{
    self = [super initWithItem:items cellIdentifier:identifier configureCellBlock:block];
    if (self)
    {
        self.progressBlock = ^(KxSMBItem * item,long transferred){
            
            [[[FileTransmissionViewController shareFileTransmissionVC] ftDatasource] updateSFTItemAtPath:item.path withTransferred:transferred];
        };
        
        self.resultBlock = ^(id result){
            if ([result isKindOfClass:[NSError class]])
            {
                NSLog(@"传输出错！！！！！！！！%@",(NSError*)result );
            }
            else
            {
                [[[FileTransmissionViewController shareFileTransmissionVC] ftDatasource] removeSFTItemAtPath:nil];
            }
        };
    }
    
    return self;
    
}

-(void)addSFTItem:(FileTransmissionModal *)item
{
    NSMutableArray * ma = [self.items mutableCopy];
    [ma addObject:item];
    self.items = ma;
    [self.ftVC.tableView reloadData];
    if (item.transmissionType == FileTransmissionUpload)
    {
        [[KxSMBProvider sharedSmbProvider]copyLocalPath:item.fromPath
                                                smbPath:item.toPath
                                              overwrite:YES
                                               progress:self.progressBlock
                                                  block:self.resultBlock];
    }
    else if(item.transmissionType == FileTransmissionDownload)
    {
        [[KxSMBProvider sharedSmbProvider]copySMBPath:item.fromPath
                                            localPath:item.toPath
                                            overwrite:YES
                                             progress:self.progressBlock
                                                block:self.resultBlock];
    }

}

-(void)removeSFTItemAtPath:(NSString*)path
{
    for (NSInteger i = 0;i<self.items.count;i++)
    {
        FileTransmissionModal * item = [self.items objectAtIndex:i];
        if (item.processedBytes == item.fileBytes)
        {
            NSLog(@"传输完成");
            [self.ftVC.tableView beginUpdates];
            [self.items removeObject:item];
            [self.ftVC.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.ftVC.tableView endUpdates];
        }
    }
}

-(void)updateSFTItemAtPath:(NSString*)path withTransferred:(long)transferred
{
    for (NSInteger i = 0;i<self.items.count;i++)
    {
        FileTransmissionModal * item = [self.items objectAtIndex:i];
        [item indexOfAccessibilityElement:item];
        if (item.fromPath == path ||item.toPath == path)
        {
            //[self.ftVC.tableView beginUpdates];
            item.processedBytes = transferred;
            //[self.ftVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            FileTransmissionCell * cell = (FileTransmissionCell *)[self.ftVC.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell configureForTask:item];
           // [self.ftVC.tableView endUpdates];
        }
    }
}

-(FileTransmissionModal*)SFTItemAtIndex:(NSInteger)index
{
    return (FileTransmissionModal*)[self.items objectAtIndex:index];
}

#pragma mark UITableViewDataSourceDelegate




@end
