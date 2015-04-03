//
//  SettingViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *showHiddenFile;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showHiddenFile.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldShowHiddenFile"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hiddenFileSettingChanged:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:@"ShouldShowHiddenFile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSDictionary * dic = @{@"ShouldShowHiddenFile":@(sender.on)};
    if (self.settingDelegate)
    {
        [self.settingDelegate settingHadBeenChanged: @{@"ShouldShowHiddenFile":@(sender.on)}];
    }
    
    
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
