//
//  ArrayDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/4.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock) (id cell,id item);

@interface ArrayDataSource : NSObject  <UITableViewDataSource>

@property (nonatomic,copy) NSString * cellIdentifier;
@property (nonatomic,strong) NSMutableArray * items;
@property (nonatomic,copy) TableViewCellConfigureBlock configureCellBlock;

  -(id)initWithItem:(NSMutableArray *)items
     cellIdentifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block;

-(id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end
