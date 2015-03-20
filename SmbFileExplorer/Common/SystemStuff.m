//
//  SystemStuff.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/18.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SystemStuff.h"

@implementation SystemStuff


+(NSString*)stringForPathOfDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
