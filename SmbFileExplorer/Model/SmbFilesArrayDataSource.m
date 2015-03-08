//
//  SmbFilesArrayDataSource.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFilesArrayDataSource.h"

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


@end
