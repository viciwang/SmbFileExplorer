//
//  LocalFileDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "LocalFileDataSource.h"


@implementation LocalFileModal


@end

@implementation LocalFileDataSource

-(BOOL)removeFileAtIndex:(NSInteger) index
{
    LocalFileModal * file = (LocalFileModal *)[self itemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSError * error;
    if([[NSFileManager defaultManager] removeItemAtPath:file.path error:&error])
    {
        [self.items removeObject:file];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
