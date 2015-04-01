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

@end

@implementation SmbFileTransmissionDataSource


-(id)initWithItem:(NSMutableArray *)items
   cellIdentifier:(NSString *)identifier
configureCellBlock:(TableViewCellConfigureBlock)block
{
    self = [super initWithItem:items cellIdentifier:identifier configureCellBlock:block];
    if (self)
    {

    }
    
    return self;
    
}

-(void)addSFTItem:(FileTransmissionModal *)item
{
    NSMutableArray * ma = [self.items mutableCopy];
    [ma addObject:item];
    self.items = ma;
    [self.ftVC.tableView reloadData];
    [item begin];
//    if (item.transmissionType == FileTransmissionUpload)
//    {
//        [[KxSMBProvider sharedSmbProvider]copyLocalPath:item.fromPath
//                                                smbPath:item.toPath
//                                              overwrite:YES
//                                               progress:self.progressBlock
//                                                  block:self.resultBlock];
//    }
//    else if(item.transmissionType == FileTransmissionDownload)
//    {
//        [[KxSMBProvider sharedSmbProvider]copySMBPath:item.fromPath
//                                            localPath:item.toPath
//                                            overwrite:YES
//                                             progress:self.progressBlock
//                                                block:self.resultBlock];
//    }

}


// 如果传入的path为空则删除已完成的传输，如果路径不为空则删除对应的未完成的任务
-(void)removeSFTItemAtPath:(NSString*)path
{
    for (NSInteger i = 0;i<self.items.count;i++)
    {
        FileTransmissionModal * item = [self.items objectAtIndex:i];
        if (item.processedBytes == item.fileBytes || item.fromPath == path || item.toPath == path)
        {
            NSLog(@"传输完成");
            [self.ftVC.tableView beginUpdates];
            [self.items removeObject:item];
            [self.ftVC.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.ftVC.tableView endUpdates];
            
            // 更新页面
            if (item.transmissionType == FileTransmissionUpload)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ShouldReloadPath" object:nil userInfo:@{@"Path":item.toPath}];
            }

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

-(void)suspendAllTasks
{
    for (FileTransmissionModal * modal in self.items)
    {
        [modal suspend];
    }
}


-(void)resumeAllTasks
{
    for (FileTransmissionModal * modal in self.items)
    {
        [modal begin];
    }
}

-(void)reAddAllTasks:(NSArray *)tasks
{
    for (FileTransmissionModal * modal in tasks)
    {
        [self addSFTItem:modal];
    }
}

#pragma mark UITableViewDataSourceDelegate




@end
