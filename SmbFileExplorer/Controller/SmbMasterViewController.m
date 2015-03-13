//
//  SmbMasterViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/3.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbMasterViewController.h"

static NSString * const SmbMasterCellIdentifier = @"SmbAuthCell";


@interface SmbMasterViewController ()

@property (nonatomic,strong) NSMutableArray * authMsgItems;
@property (nonatomic,copy)   TableViewCellConfigureBlock cellConfigBlock;
@property (nonatomic,strong) SmbAuthArrayDataSource * authArrayDataSource;
@property (nonatomic,strong) NSIndexPath * indexPathForAccessoryButtonTapped;

@end

@implementation SmbMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];

}

-(void)setupTableView
{
    self.authMsgItems = (NSMutableArray *)[PersistenceManager retrievalWithKey:UserDefaultKeyForSmbAuthItems];
    if(self.authMsgItems == nil)
    {
        self.authMsgItems = [[NSMutableArray alloc]init];
    }
    self.cellConfigBlock = ^(SmbAuthCell * cell,SmbAuth * item){
        [(SmbAuthCell*)cell configureForSmbAuth:item];
    };
    
    
    self.authArrayDataSource = [[SmbAuthArrayDataSource alloc]initWithItem:self.authMsgItems
                                                     cellIdentifier:SmbMasterCellIdentifier
                                                 configureCellBlock:self.cellConfigBlock];
    
    self.tableView.dataSource = self.authArrayDataSource;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(showSmbAuthMsgVC)];
    
    KxSMBProvider * provider = [KxSMBProvider sharedSmbProvider];
    provider.delegate = self;
    
    
    
    
}

-(void)showSmbAuthMsgVC
{
    SmbAuthMessageViewController * vc = [[UIStoryboard storyboardWithName:@"Main"
                                                                   bundle:nil]instantiateViewControllerWithIdentifier:@"SmbAuthMessage"];
    [vc configureSmbMasterVC:self IsNewAuthView:YES SmbAuth:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addSmbAuthCellForAuth:(SmbAuth*)smbAuth
{
    [self.authArrayDataSource addAuthItem:smbAuth];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.authMsgItems.count-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)updateSmbAuthCellForAuth:(SmbAuth*)smbAuth
{
    [self.authArrayDataSource updateAuthAtIndex:self.indexPathForAccessoryButtonTapped.row
                                       withAuth:smbAuth];
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathForAccessoryButtonTapped = indexPath;
    SmbAuthMessageViewController * vc = [[UIStoryboard storyboardWithName:@"Main"
                                                                   bundle:nil]instantiateViewControllerWithIdentifier:@"SmbAuthMessage"];
    [vc configureSmbMasterVC:self IsNewAuthView:NO SmbAuth:[self.authArrayDataSource smbAuthAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController  * nav = (UINavigationController *)[[self.splitViewController viewControllers]lastObject];
    SmbFileViewController * smbFileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFileViewController"];
    self.currentSmbAuth = self.authArrayDataSource.items[indexPath.row];
    
    NSString * ipString = self.currentSmbAuth.ipAddr;
    if ([NetworkManager isAHostName:self.currentSmbAuth.ipAddr])
    {
        ipString  = [NetworkManager ipAddrForHostName:ipString];
    }
    
    // the path must be the format : @"smb://%@",ipAddr;
    smbFileVC.path = [NSString stringWithFormat:@"smb://%@",ipString ];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:smbFileVC];
//    NSArray * array = [self.splitViewController viewControllers];
//    [array replaceObjectAtIndex:array.count-1 withObject:nav];
    [nav popToRootViewControllerAnimated:YES];
    [nav pushViewController:smbFileVC animated:YES];
    
}


#pragma mark - KxSMBProviderDelegate
-(KxSMBAuth *)smbAuthForServer:(NSString *)server withShare:(NSString *)share
{
    KxSMBAuth * smbAuth = [[KxSMBAuth alloc]init];
    smbAuth.username = self.currentSmbAuth.account;
    smbAuth.password = self.currentSmbAuth.password;
    smbAuth.workgroup = self.currentSmbAuth.workgroup;
    return smbAuth;
}

@end
