//
//  SystemStuff.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/18.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SystemStuff.h"

@interface SystemStuff ()

@property (nonatomic,strong) NSDateFormatter * dateFormatter;

@end


static SystemStuff * gSystemStuff;

@implementation SystemStuff

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [self.dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    return self;
}

+(SystemStuff *)shareSystemStuff
{
    static dispatch_once_t onceSystemStuff;
    dispatch_once(&onceSystemStuff, ^{
        gSystemStuff = [[SystemStuff alloc] init];
    });
    return gSystemStuff;
}

-(NSString*) stringFromDate:(NSDate *)date
{
    return [self.dateFormatter stringFromDate:date];
}

-(NSString*) stringFromFileSizeBytes:(long long)size
{
    long long value;
    NSString * unit = @"B";
    if (size < 1024)
    {
        value = size;
        unit = @"B";
        
    }
    else if (size < 1048576)
    {
        value = size / 1024.f;
        unit = @"KB";
    }
    else
    {
        value = size / 1048576.f;
        unit = @"MB";
    }
    return [NSString stringWithFormat:@"%lli %@",value,unit];
    
}

+(NSString*)stringForPathOfDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
