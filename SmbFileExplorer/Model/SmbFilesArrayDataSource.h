//
//  SmbFilesArrayDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"
#import "KxSMBProvider.h"
#import "SmbFileCell.h"
#import "SmbFileOperateCell.h"

@class SmbFileViewController;
@class SmbFilesArrayDataSource;

typedef enum{
    SmbLoadedStatusError,
    SmbLoadedStatusSuccess,
    
}SmbLoadedStatus;

typedef enum{
    FileTypeKxSMBItemTree,
    FileTypeKxSMBItemFile,
    FileTypeItemOperate,
}FileType;

@protocol SmbFileArrayDelegate <NSObject>

-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didRemoveItemAtIndex:(NSInteger)index;
-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didInsertItem:(id)item intoIndex:(NSInteger)index;
-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didFailToAddSmbFile:(NSError *)error;

@end

typedef void (^SmbLoadedBlock)(id status);
typedef void (^CompleteBlock)(id status);


@interface SmbFilesArrayDataSource : ArrayDataSource

@property (nonatomic,copy) NSString * path;
@property (nonatomic,weak) UITableViewController<SmbFileArrayDelegate,SmbFileOperateDelegate> * smbFileDelegate;



  -(id)initWithItem:(NSMutableArray *)items
     cellIdentifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block
               path:(NSString*)path;

-(void)loadFileAndProcessByBlock:(SmbLoadedBlock)block;
-(void)insertItemType:(FileType)fileType Named:(NSString *)name AtIndex:(NSInteger)index;
-(void)removeItemAtIndex:(NSInteger)index;
//-(void)renameItemAtIndex:(NSInteger)index withAuth:(SmbAuth *)auth;

@end

