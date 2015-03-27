//
//  SystemStuff.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/18.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SystemStuff : NSObject

+(SystemStuff *)shareSystemStuff;
+(NSString*)stringForPathOfDocumentPath;
-(NSString*) stringFromDate:(NSDate *)date;
-(NSString*) stringFromFileSizeBytes:(long long)size;
@end
