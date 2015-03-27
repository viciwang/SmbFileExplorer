//
//  SmbFilesArrayDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFilesArrayDataSource.h"
#import "SmbFileViewController.h"

@implementation SmbFilesArrayDataSource


-(id)initWithItem:(NSMutableArray *)items
   cellIdentifier:(NSString *)identifier
configureCellBlock:(TableViewCellConfigureBlock)block
             path:(NSString*)path
{
    self = [super initWithItem:items
                cellIdentifier:identifier
            configureCellBlock:block];
    if (self) {
        self.path  = path;
    }
    
    return self;
}

-(void)loadFileAndProcessByBlock:(SmbLoadedBlock)block
{
    KxSMBProvider *provider = [KxSMBProvider sharedSmbProvider];
    [provider fetchAtPath:self.path
                    block:^(id result)
     {
         if ([result isKindOfClass:[NSError class]])
         {
             
             block(result);
             
         }
         else
         {
             if ([result isKindOfClass:[NSArray class]])
             {
                 self.items = [result copy];
             }
             else if ([result isKindOfClass:[KxSMBItem class]])
             {
                 self.items = [[NSMutableArray alloc]initWithObjects:(KxSMBItem*)result, nil];
             }
             block(result);
         }
     }];
}


// 如果插入的filetype 是 FileTypeItemOperate,index才有作用
-(void)insertItemType:(FileType)fileType Named:(NSString *)name AtIndex:(NSInteger)index
{
    if (fileType == FileTypeKxSMBItemTree)
    {
        KxSMBProvider * provider = [KxSMBProvider sharedSmbProvider];
        id result = [provider createFolderAtPath:[self.path stringByAppendingSMBPathComponent:name]];
        if([result isKindOfClass:[KxSMBItemTree class]])
        {
            NSMutableArray * ma = [self.items mutableCopy];
            [ma addObject:(KxSMBItemTree *)result];
            self.items = [ma copy];
            [self.smbFileDelegate smbFileArrayDataSource:self didInsertItem:result intoIndex:[self.items count]-1];
        }
        else
        {
           [self.smbFileDelegate smbFileArrayDataSource:self didFailToAddSmbFile:result];
        }
    }
    
    else if(fileType == FileTypeItemOperate)
    {
        //  添加一个NSString，用于占行
        NSMutableArray * ma = [self.items mutableCopy];
        [ma insertObject:@"FileOperate" atIndex:index];
        self.items = [ma copy];
        [self.smbFileDelegate smbFileArrayDataSource:self didInsertItem:@"FileOperator" intoIndex:index];
    }

}

-(void)removeItemAtIndex:(NSInteger)index;
{
    
    id item = [self itemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    KxSMBProvider * provider = [KxSMBProvider sharedSmbProvider];
    id result;
    if ([item isKindOfClass:[KxSMBItemFile class]])
    {
        result = [provider removeAtPath:((KxSMBItemFile*)item).path];
        if(![result isKindOfClass:[NSError class]])
        {
            NSMutableArray * ma = [self.items mutableCopy];
            [ma removeObject:item];
            self.items = [ma copy];
            if (self.smbFileDelegate)
            {
                [self.smbFileDelegate smbFileArrayDataSource:self didRemoveItemAtIndex:index];
            }
        }
        else
        {
            //block(result);
            [self.smbFileDelegate smbFileArrayDataSource:self didFailToAddSmbFile:result];
        }
    }
    else if([item isKindOfClass:[KxSMBItemTree class]])
    {
        // 删除文件夹比较危险，并且难度较大，不好控制，暂时先屏蔽
        //[provider removeFolderAtPath:item.path block:block];
    }
    
    //  删除操作行
    else if ([item isKindOfClass:[NSString class]])
    {
        NSMutableArray * ma = [self.items mutableCopy];
        [ma removeObject:item];
        self.items = [ma copy];
        if (self.smbFileDelegate)
        {
            [self.smbFileDelegate smbFileArrayDataSource:self didRemoveItemAtIndex:index];
        }
    }

}


#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[NSString class]])
    {
        SmbFileOperateCell * cell = (SmbFileOperateCell *)[tableView dequeueReusableCellWithIdentifier:@"SmbFileOperateCell"
                                                                                          forIndexPath:indexPath];
        [cell configureCellWithDelegate:self.smbFileDelegate];
        return cell;
    }
    else
    {
        SmbFileCell * cell = (SmbFileCell *)[tableView dequeueReusableCellWithIdentifier:@"SmbFileCell"
                                                                            forIndexPath:indexPath];
        [cell configureForSmbFile:[self itemAtIndexPath:indexPath]];
        return cell;
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item  = [self itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[KxSMBItemFile class]])
    {
        return YES;
    }
    return NO;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self removeItemAtIndex:indexPath.row];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}




@end
