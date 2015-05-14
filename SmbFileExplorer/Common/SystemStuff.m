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
@property (nonatomic,strong) NSDictionary * fileExtensionImageDic;

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
        [gSystemStuff imageDictionaryInit];

    });
    return gSystemStuff;
}

- (void)imageDictionaryInit
{
    self.fileExtensionImageDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"file_doc.png",@"doc",
                              @"file_doc.png",@"docx",
                              @"file_pdf",@"pdf",
                              @"file_exc",@"xls",
                              @"file_exc",@"xlsx",
                              @"file_ppt",@"ppt",
                              @"file_image",@"png",
                              @"file_image",@"jpg",
                              @"file_image",@"jpeg",
                              @"file_image",@"bmp",
                              @"file_pdf",@"pdf",
                              @"file_rar",@"rar",
                              @"file_rar",@"zip",
                              @"file_folder",@"folder",nil];
    //@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil
}

-(NSString*) stringFromDate:(NSDate *)date
{
    return [self.dateFormatter stringFromDate:date];
}

+(NSString*) stringFromFileSizeBytes:(long long)size
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





- (NSString *)imageNameFromFileExtension:(NSString*)fileExtension
{
    if([fileExtension isEqualToString:@""])
    {
        fileExtension = @"folder";
    }
    NSString * pic = [[SystemStuff shareSystemStuff].fileExtensionImageDic objectForKey:fileExtension];
    if (pic==nil)
    {
        pic = @"file_unknow.png";
    }
    return pic;
}

+ (void)beginPathAnimation:(UIView *)v beginPoint:(CGPoint)beginPoint endPoint:(CGPoint)endPoint delegate:(id)delegate
{
    v.center = beginPoint;
    [[[UIApplication sharedApplication]keyWindow] addSubview:v];
    
    float x = v.center.x;
    float y = v.center.y;
    
    // create a CGPath that implements two arcs (a bounce)
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,x,y);
    CGPathAddCurveToPoint(thePath,NULL,x+200,y-200,
                          x+400,y,
                          endPoint.x,endPoint.y);
    
    CAKeyframeAnimation * theAnimation;
    
    // create the animation object, specifying the position property as the key path
    // the key path is relative to the target animation object (in this case a CALayer)
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path = thePath;
    
    // set the duration to 5.0 seconds
    theAnimation.duration=1.0;
    
    if (delegate) {
         theAnimation.delegate = delegate;
    }
    
    [v.layer addAnimation:theAnimation forKey:@"animation"];
    // release the path
    CFRelease(thePath);
}



@end
