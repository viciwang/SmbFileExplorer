//
//  ChooseLocalFileViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "ChooseLocalFileViewController.h"
#import "LocalFileViewController.h"

@interface ChooseLocalFileViewController ()

@end

@implementation ChooseLocalFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIViewController* vc in self.childViewControllers) {
        LocalFileViewController * lf = (LocalFileViewController*)vc;
        lf.clfVC = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
