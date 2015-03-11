//
//  SmbFileTransmissionDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileTransmissionDataSource.h"


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
        __weak typeof(self) weakSelf = self;
        self.progressBlock = ^(KxSMBItem * item,long transferred){
            [weakSelf updateSFTItemAtPath:item.path withTransferred:transferred];
        };
        
        self.resultBlock = ^(id result){
            if ([result isKindOfClass:[NSError class]])
            {
                NSLog(@"传输出错！！！！！！！！%@",(NSError*)result );
            }
            else
            {
                [weakSelf removeSFTItemAtPath:nil];
            }
        };
    }
    
    return self;
    
}

-(void)addSFTItem:(FileTransmissionModal *)item
{
    [self.items addObject:item];
    if (item.transmissionType == FileTransmissionUpload)
    {
        [[KxSMBProvider sharedSmbProvider]copyLocalPath:item.fromPath
                                                smbPath:item.toPath
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
        [item indexOfAccessibilityElement:item];
        if (item.processedBytes == item.fileBytes)
        {
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
            [self.ftVC.tableView beginUpdates];
            item.processedBytes = transferred;
            [self.ftVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.ftVC.tableView endUpdates];
        }
    }
}

-(FileTransmissionModal*)SFTItemAtIndex:(NSInteger)index
{
    return nil;
}



@end
