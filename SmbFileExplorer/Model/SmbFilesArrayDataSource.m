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

-(void)addItemKind:(NSString *)fileType Named:(NSString *)name Handler:(CompleteBlock)block;
{
    if ([fileType isEqualToString:NSStringFromClass([KxSMBItemTree class])])
    {
        KxSMBProvider * provider = [KxSMBProvider sharedSmbProvider];
        id result = [provider createFolderAtPath:[self.path stringByAppendingSMBPathComponent:name]];
        if([result isKindOfClass:[KxSMBItemTree class]])
        {
            NSMutableArray * ma = [self.items mutableCopy];
            [ma addObject:(KxSMBItemTree *)result];
            self.items = [ma copy];
        }
        block(result);
    }
    else
    {
        
    }

}

-(void)removeItemAtIndex:(NSInteger)index Handler:(CompleteBlock)block;
{
    
    KxSMBItem * item = [self.items objectAtIndex:index];
    KxSMBProvider * provider = [KxSMBProvider sharedSmbProvider];
    id result;
    if ([item isKindOfClass:[KxSMBItemFile class]])
    {
        result = [provider removeAtPath:item.path];
        if(![result isKindOfClass:[NSError class]])
        {
            NSMutableArray * ma = [self.items mutableCopy];
            [ma removeObjectAtIndex:index];
            self.items = [ma copy];
            [self.smbFileVC.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            block(result);
        }
    }
    else if([item isKindOfClass:[KxSMBItemTree class]])
    {
        // 删除文件夹比较危险，并且难度较大，不好控制，暂时先屏蔽
        //[provider removeFolderAtPath:item.path block:block];
    }

}


#pragma mark UITableViewDataSource

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.items objectAtIndex:indexPath.row]isKindOfClass:[KxSMBItemFile class]])
    {
            return YES;
    }
    return NO;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteFile" object:indexPath];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}


@end
