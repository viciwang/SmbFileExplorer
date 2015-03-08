//
//  SmbAuthArrayDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/8.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbAuthArrayDataSource.h"

@implementation SmbAuthArrayDataSource

-(void)addAuthItem:(SmbAuth *)auth
{
    [self.items addObject:auth];//atIndex:self.items.count-1];
    [PersistenceManager saveData:self.items forKey:UserDefaultKeyForSmbAuthItems];
}


-(void)removeAuthAtIndex:(NSInteger)index
{
    [self.items removeObjectAtIndex:index];
    [PersistenceManager saveData:self.items forKey:UserDefaultKeyForSmbAuthItems];
}

-(void)updateAuthAtIndex:(NSInteger)index withAuth:(SmbAuth *)auth
{
    [self.items removeObjectAtIndex:index];
    [self.items insertObject:auth atIndex:index];
    [PersistenceManager saveData:self.items forKey:UserDefaultKeyForSmbAuthItems];
}


-(SmbAuth*)smbAuthAtIndex:(NSInteger)index
{
    return self.items[index];
}

#pragma mark UITableViewDataSource

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self removeAuthAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}

@end
