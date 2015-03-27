//
//  SmbFileTransmissionDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"
#import "FileTransmissionModal.h"
#import "KxSMBProvider.h"

@class FileTransmissionViewController;


@interface SmbFileTransmissionDataSource : ArrayDataSource

@property (nonatomic,weak) FileTransmissionViewController * ftVC;

-(void)addSFTItem:(FileTransmissionModal *)item;
-(void)removeSFTItemAtPath:(NSString*)path;
-(void)updateSFTItemAtPath:(NSString*)path withTransferred:(long)transferred;
-(FileTransmissionModal*)SFTItemAtIndex:(NSInteger)index;
-(void)suspendAllTasks;
-(void)resumeAllTasks;
-(void)reAddAllTasks:(NSArray *)tasks;
@end
