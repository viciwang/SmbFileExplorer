//
//  SmbFileOperateViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/9.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileOperateViewController.h"

@interface SmbFileOperateViewController ()

@property (nonatomic,strong) NSFileHandle * fileHandle;
//@property (nonatomic,strong) NSString * filePath;
@property (nonatomic,strong) NSDate * timestamp;
@property (nonatomic) long downloadedBytes;

@end

@implementation SmbFileOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadProgress.progress = 0.0;
    [self beginDownload];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginDownload
{
    if (!self.fileHandle)
    {
        
        NSString *folder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                NSUserDomainMask,
                                                                YES) lastObject];
        NSString *filename = self.smbFile.path.lastPathComponent;
        self.filePath = [folder stringByAppendingPathComponent:filename];
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        if ([fm fileExistsAtPath:self.filePath])
            [fm removeItemAtPath:self.filePath error:nil];
        [fm createFileAtPath:self.filePath contents:nil attributes:nil];
        
        NSLog(@"%@",self.filePath);
        
        NSError *error;
        self.fileHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:self.filePath]
                                                            error:&error];
        
        if (self.fileHandle)
        {
            
            [self.downloadButton setTitle:@"取消" forState:UIControlStateNormal];
            self.downloadLabel.text = @"正在开始 ..";
            
            //self.downloadStatus = 0;
            self.downloadProgress.progress = 0;
            self.downloadProgress.hidden = NO;
            self.timestamp = [NSDate date];
            [self downloadFile];
            
        }
        else
        {
            self.downloadLabel.text = [NSString stringWithFormat:@"下载失败: %@", error.localizedDescription];
        }
        
    }
    else
    {
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        //self.downloadLabel.text = @"取消";
        [self closeFiles];
    }

}

- (IBAction)cancel:(id)sender
{
    [self closeFiles];
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)downloadFile
{
    __weak __typeof(self) weakSelf = self;
    [self.smbFile readDataOfLength:32768
                             block:^(id result)
     {
         SmbFileOperateViewController *p = weakSelf;
         //if (p && p.isViewLoaded && p.view.window) {
         if (p) {
             [p updateDownloadStatus:result];
         }
     }];
}

- (void) closeFiles
{
    if (self.fileHandle) {
        
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    
    [self.smbFile close];
}

-(void) updateDownloadStatus: (id) result
{
    if ([result isKindOfClass:[NSError class]])
    {
        
        NSError *error = result;
        
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        self.downloadLabel.text = [NSString stringWithFormat:@"下载失败: %@", error.localizedDescription];
        self.downloadProgress.hidden = YES;
        [self closeFiles];
        
    }
    else if ([result isKindOfClass:[NSData class]])
    {
        
        NSData *data = result;
        
        if (data.length == 0)
        {
            [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
            [self closeFiles];
        }
        else
        {
            NSTimeInterval time = -[self.timestamp timeIntervalSinceNow];
            self.downloadedBytes += data.length;
            self.downloadProgress.progress = (float)self.downloadedBytes / (float)self.smbFile.stat.size;
            CGFloat value;
            NSString *unit;
            
            if (self.downloadedBytes < 1024)
            {
                value = self.downloadedBytes;
                unit = @"B";
                
            }
            else if (self.downloadedBytes < 1048576)
            {
                value = self.downloadedBytes / 1024.f;
                unit = @"KB";
            }
            else
            {
                value = self.downloadedBytes / 1048576.f;
                unit = @"MB";
            }
            
            self.downloadLabel.text = [NSString stringWithFormat:@"已下载 %.1f%@ (%.1f%%) %.2f%@s",
                                       value, unit,
                                       self.downloadProgress.progress * 100.f,
                                       value / time, unit];
            if (self.fileHandle)
            {
                
                [self.fileHandle writeData:data];
                
                if(self.downloadedBytes == self.smbFile.stat.size)
                {
                    [self closeFiles];
                    self.downloadLabel.text = [NSString stringWithFormat:@"下载完成  %.1f%@",value,unit];
                    //[self dismissViewControllerAnimated:YES completion:nil];

                    [self fileHasCachedInPath:self.filePath];

                }
                else
                {
                    [self downloadFile];
                }
            }
        }
    }
    else
    {
        
        NSAssert(false, @"bugcheck");
    }
}

-(void)fileHasCachedInPath:(NSString *)path
{
    NSURL * url = [NSURL fileURLWithPath:path];
    UIDocumentInteractionController * dVC = [UIDocumentInteractionController interactionControllerWithURL:url];
    // [dVC setDelegate:self];
    
    //[dVC presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    //[dVC presentOpenInMenuFromRect:[b.viewForBaselineLayout convertRect:b.frame toView:self.view] inView:self.view animated:YES];
    dVC.delegate = self;
    [dVC presentPreviewAnimated:YES];
}


-(void)configureWithSmbFile:(KxSMBItemFile *)smbFile delegate:(id<SmbFileCacheDelegate>)delegate
{
    self.smbFile = smbFile;
    self.delegate = delegate;
    [self setModalPresentationStyle:UIModalPresentationCustom];
}

#pragma mark UIDocumentInteractionControllerDelegate

-(void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
