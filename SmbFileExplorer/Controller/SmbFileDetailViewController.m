//
//  SmbFileDetailViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileDetailViewController.h"

@interface SmbFileDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *filePath;
@property (weak, nonatomic) IBOutlet UILabel *fileBuildedDate;
@property (weak, nonatomic) IBOutlet UILabel *fileLastModifiedDate;
@end

@implementation SmbFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.button addTarget:self action:@selector(doing:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)doing:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)configureUIWithKxSMBItemFile:(KxSMBItemFile *)smbFile
{
    self.fileName.text = smbFile.path.lastPathComponent;
    self.filePath.text = smbFile.path;
    //self.fileLastModifiedDate.text = [[SystemStuff shareSystemStuff] smbFile.stat.lastModified];
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
