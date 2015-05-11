//
//  FileTransmissionPageViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/5/8.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionPageViewController.h"
#import "FileTransmissionViewController.h"

@interface FileTransmissionPageViewController ()

@end

@implementation FileTransmissionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewControllers:@[[FileTransmissionViewController shareDownloadVC]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == [FileTransmissionViewController shareUploadVC])
    {
        return [FileTransmissionViewController shareDownloadVC];
    }
    return [FileTransmissionViewController shareUploadVC];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == [FileTransmissionViewController shareUploadVC])
    {
        return [FileTransmissionViewController shareDownloadVC];
    }
    return [FileTransmissionViewController shareUploadVC];
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
