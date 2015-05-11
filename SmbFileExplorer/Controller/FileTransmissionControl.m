//
//  FileTransmissionControl.m
//  SmbFileExplorer
//
//  Created by wgl on 15/5/8.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionControl.h"
#import "FileTransmissionPageViewController.h"
#import "FileTransmissionViewController.h"

@interface FileTransmissionControl ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic,strong) FileTransmissionPageViewController * pageViewController;

@end

@implementation FileTransmissionControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(dismissTransmissionViewController:)];
    [self.segmentControl addTarget:self action:@selector(selectedChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectedChanged:(id)sender
{
    if(self.segmentControl.selectedSegmentIndex==0)
    {
        [self.pageViewController setViewControllers:@[[FileTransmissionViewController shareDownloadVC]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
    else
    {
        [self.pageViewController setViewControllers:@[[FileTransmissionViewController shareUploadVC]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)dismissTransmissionViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIpageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (previousViewControllers.firstObject == [FileTransmissionViewController shareUploadVC]) {
        self.segmentControl.selectedSegmentIndex = 0;
    }
    else {
        self.segmentControl.selectedSegmentIndex = 1;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.pageViewController = [segue destinationViewController];
    self.pageViewController.delegate = self;
}

@end
