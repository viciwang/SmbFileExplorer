//
//  SmbFilesArrayDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"
#import "KxSMBProvider.h"

@class SmbFileViewController;

typedef enum{
    SmbLoadedStatusError,
    SmbLoadedStatusSuccess,
    
}SmbLoadedStatus;

typedef void (^SmbLoadedBlock)(id status);
typedef void (^CompleteBlock)(id status);


@interface SmbFilesArrayDataSource : ArrayDataSource

@property (nonatomic,copy) NSString * path;
@property (nonatomic,weak) SmbFileViewController * smbFileVC;



  -(id)initWithItem:(NSMutableArray *)items
     cellIdentifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block
               path:(NSString*)path;

-(void)loadFileAndProcessByBlock:(SmbLoadedBlock)block;
-(void)addItemKind:(NSString *)fileType Named:(NSString *)name Handler:(CompleteBlock)block;
-(void)removeItemAtIndex:(NSInteger)index Handler:(CompleteBlock)block;
//-(void)renameItemAtIndex:(NSInteger)index withAuth:(SmbAuth *)auth;

@end
