//
//  ArrayDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/4.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@end

@implementation ArrayDataSource

-(id)initWithItem:(NSMutableArray *)items
   cellIdentifier:(NSString *)identifier
configureCellBlock:(TableViewCellConfigureBlock)block
{
    self = [super init];
    if (self)
    {
        self.items = items;
        self.cellIdentifier = identifier;
        self.configureCellBlock = block;
    }
    return self;
}


-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

-(void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.items removeObjectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                             forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell,item);
    return cell;
}




@end
