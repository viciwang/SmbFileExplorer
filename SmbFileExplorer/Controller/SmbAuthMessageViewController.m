//
//  SmbAuthMessageViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbAuthMessageViewController.h"
#import "SmbMasterViewController.h"

@interface SmbAuthMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddr;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *workgroup;

@property (nonatomic,weak) SmbMasterViewController * smbMasterVC;
@property (nonatomic) BOOL isNewAuthView;
@property (nonatomic,copy) SmbAuth * smbAuth;

@end

@implementation SmbAuthMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

-(void)configureSmbMasterVC:(SmbMasterViewController*)vc IsNewAuthView:(BOOL)flag SmbAuth:(SmbAuth *)smbAuth
{
    self.smbMasterVC = vc;
    self.isNewAuthView = flag;
    self.smbAuth = smbAuth;
}

-(void)configure
{
    if(self.isNewAuthView == NO || self.smbAuth !=nil)
    {
        self.ipAddr.text = self.smbAuth.ipAddr;
        self.account.text = self.smbAuth.account;
        self.password.text = self.smbAuth.password;
        self.workgroup.text = self.smbAuth.workgroup;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionOK:(id)sender
{
    SmbAuth * auth = [self generateSmbAuth];
    if (auth==nil)
    {
        return;
    }
    if (self.isNewAuthView)
    {
        [self.smbMasterVC addSmbAuthCellForAuth:auth];
    }
    else
    {
        [self.smbMasterVC updateSmbAuthCellForAuth:auth];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(SmbAuth*)generateSmbAuth
{
    return [[SmbAuth alloc]initWithIpAddr:self.ipAddr.text
                                  account:self.account.text
                                 password:self.password.text
                                workgroup:self.workgroup.text];
}



- (IBAction)actionCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
