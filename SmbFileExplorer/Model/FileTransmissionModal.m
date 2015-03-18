//
//  FileTransmissionModal.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionModal.h"
#import "KxSMBProvider.h"

@implementation FileTransmissionModal


// topath and frompath must't be a floder , must be a fiel's path.
- (instancetype)initWithTransmissionType:(FileTransmissionType)type fromPath:(NSString*)fp toPath:(NSString*)tp withInfo:(id)info
{
    self = [super init];
    if (self) {
        self.transmissionType = type;
        self.fromPath = fp;
        self.toPath = tp;
        if(type == FileTransmissionDownload)
        {
            self.toPath = [self pathWithoutConflict:self.toPath isLocalFile:YES];
            KxSMBItemStat * stat = (KxSMBItemStat *)info;
            if(stat)
            {
                self.fileBytes = stat.size;
            }
        }
        else
        {
            self.fileBytes = [self fileSizeAtPath:self.fromPath];
        }
    }
    return self;
}

-(NSString*)pathWithoutConflict:(NSString *)path isLocalFile:(BOOL)isLocalFile
{
    
    if (isLocalFile == YES)
    {
        NSFileManager * fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path])
        {
            return path;
        }
        else
        {
            NSString * name = [[path lastPathComponent] stringByDeletingPathExtension];
            NSString * extension = [path pathExtension];
            NSArray * array = [fm subpathsAtPath:[SystemStuff stringForPathOfDocumentPath]];
            NSString * temName;
            for (int i = 1; 1; i++)
            {
                temName = [NSString stringWithFormat:@"%@(%i).%@",name,i,extension];
                if (![array containsObject:temName])
                {
                    break;
                }
            }
            return [NSString stringWithFormat:@"%@/%@",[path stringByDeletingLastPathComponent],temName];
        }
    }
    else
    {
        return path;
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath
{
    if (self.transmissionType == FileTransmissionUpload)
    {
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath])
        {
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return 0;
}



@end
