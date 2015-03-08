//
//  SmbFilesArrayDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"
#import "KxSMBProvider.h"

typedef enum{
    SmbLoadedStatusError,
    SmbLoadedStatusSuccess,
    
}SmbLoadedStatus;

typedef void (^SmbLoadedBlock)(id status);


@interface SmbFilesArrayDataSource : ArrayDataSource

@property (nonatomic,copy) NSString * path;

  -(id)initWithItem:(NSMutableArray *)items
     cellIdentifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block
               path:(NSString*)path;

-(void)loadFileAndProcessByBlock:(SmbLoadedBlock)block;

@end
