//
//  LocalFileDataSource.h
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ArrayDataSource.h"

@interface LocalFileModal : NSObject
@property (nonatomic,strong) NSString * path;
@property (nonatomic) UInt64 fileSize;

@end

@interface LocalFileDataSource : ArrayDataSource

-(BOOL)removeFileAtIndex:(NSInteger) index;

@end
