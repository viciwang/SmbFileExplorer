//
//  SmbFileViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileViewController.h"

static NSString * const SmbFileCellIdentifier = @"SmbFileCell";

@interface SmbFileViewController ()

@property (nonatomic,strong) NSMutableArray * fileItems;
@property (nonatomic,copy)   TableViewCellConfigureBlock cellConfigBlock;
@property (nonatomic,strong) SmbFilesArrayDataSource * fileArrayDataSource;
@property (nonatomic,strong) NSString * fileName;

@end

@implementation SmbFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self reloadPath];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //  一定要remove，不然会调用多次
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteFileAction:) name:@"DeleteFile" object:nil];
    [FileTransmissionViewController shareFileTransmissionVC].delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setupTableView
{
    if(NSClassFromString(@"UIRefreshControl"))
    {
        UIRefreshControl * refreshControl = [[UIRefreshControl alloc]init];
        [refreshControl addTarget:self action:@selector(reloadPath) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    }
    
    self.cellConfigBlock = ^(SmbFileCell * cell,KxSMBItem * item){
        [(SmbFileCell*)cell configureForSmbFile:item];
    };
    self.fileArrayDataSource = [[SmbFilesArrayDataSource alloc]initWithItem:[NSMutableArray array]
                                                     cellIdentifier:SmbFileCellIdentifier
                                                 configureCellBlock:self.cellConfigBlock
                                                               path:self.path];
    
    self.tableView.dataSource = self.fileArrayDataSource;
    self.fileArrayDataSource.smbFileVC = self;
    
    UIBarButtonItem * barButtonItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolderAction)];
    UIBarButtonItem * barButtonItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(addFileAction)];
    UIBarButtonItem * barButtonItem3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showTransmissionAction)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:barButtonItem1,barButtonItem2,barButtonItem3, nil];
    
}

-(void)showTransmissionAction
{
    UIPopoverController * p = [[UIPopoverController alloc]initWithContentViewController:[FileTransmissionViewController shareFileTransmissionVC]];
    [p presentPopoverFromBarButtonItem:[self.navigationItem.rightBarButtonItems lastObject] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    // [self presentViewController:[FileTransmissionViewController shareFileTransmissionVC] animated:YES completion:nil];
}

-(void)addFolderAction
{
 //   UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FolderNameForm"];
// //   vc.view.backgroundColor = [UIColor greenColor];
////    vc.view.bounds = CGRectMake(0, 0, 100, 200);
////    UIPopoverController * po = [[UIPopoverController alloc]initWithContentViewController:vc];
////    po.popoverContentSize = CGSizeMake(100, 100);
////    [po presentPopoverFromRect:CGRectMake(100, 100, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    vc.modalPresentationStyle = UIModalPresentationFormSheet;
//    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
//    
//    self.presentationController presentationStyle;
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"新文件夹的名字" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf.fileArrayDataSource addItemKind:NSStringFromClass([KxSMBItemTree class]) Named:weakSelf.fileName Handler:^(id status){
            if ([status isKindOfClass:[KxSMBItemTree class]])
            {
                [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.fileArrayDataSource.items.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fileArrayDataSource.items.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            else
            {
                    
            }
        }];
    }];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:actionOK];
    [ac addAction:actionCancel];
    [ac addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.delegate = weakSelf;
    }];
    
    [self presentViewController:ac animated:YES completion:nil];

    
}

-(void)addFileAction
{
    ChooseLocalFileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseLocalFile"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(void)deleteFileAction:(NSNotification *)notification
{
    NSIndexPath * indexPath = notification.object;
    CompleteBlock block = ^(id status){
        if ([status isKindOfClass:[NSError class]])
        {
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:actionOK];
            [self presentViewController:ac animated:YES completion:nil];
        }
    };
    
    __weak typeof(self) weakSelf = self;
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"确定要删除文件" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf.fileArrayDataSource removeItemAtIndex:indexPath.row Handler:block];
    }];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:actionOK];
    [ac addAction:actionCancel];
    [self.splitViewController presentViewController:ac animated:YES completion:nil];
}


-(void)reloadPath
{
    NSString *path;
    
    if (self.path.length) {
        
        path = self.path;
        self.title = path.lastPathComponent;
        
    }
    else
    {
        
        path = @"smb:";
        self.title = @"smb:";
    }
    self.fileArrayDataSource.items = nil;
    [self.tableView reloadData];
    [self updateStatus:[NSString stringWithFormat:@"正在获取文件 %@ ...",path]];
    
    [self.fileArrayDataSource loadFileAndProcessByBlock:^(id status){
        if ([status isKindOfClass:[NSError class]])
        {
            [self updateStatus:status];
        }
        else
        {
            [self updateStatus:nil];
            [self.tableView reloadData];
        }
    }];
    
     
}

- (void) updateStatus: (id) status
{
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    
    if ([status isKindOfClass:[NSString class]]) {
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        CGSize sz = activityIndicator.frame.size;
        const float H = font.lineHeight + sz.height + 10;
        const float W = self.tableView.frame.size.width;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, W, font.lineHeight)];
        label.text = status;
        label.font = font;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [v addSubview:label];
        
        if(![self.refreshControl isRefreshing])
            [self.refreshControl beginRefreshing];
        
        self.tableView.tableHeaderView = v;
        
    } else if ([status isKindOfClass:[NSError class]]) {
        
        const float W = self.tableView.frame.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, W, font.lineHeight)];
        label.text = ((NSError *)status).localizedDescription;
        label.font = font;
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.tableView.tableHeaderView = label;
        
        [self.refreshControl endRefreshing];
        
    } else {
        
        self.tableView.tableHeaderView = nil;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否为文件夹
    KxSMBItem * item = [self.fileArrayDataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[KxSMBItemFile class]])
    {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 判断是否为文件夹
    KxSMBItem * item = [self.fileArrayDataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[KxSMBItemTree class]])
    {
        UINavigationController  * nav = (UINavigationController *)[[self.splitViewController viewControllers]lastObject];
        SmbFileViewController * smbFileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFileViewController"];
        smbFileVC.path = item.path;
        [nav pushViewController:smbFileVC animated:YES];
    }
    else
    {
//        CGFloat containWidth = 50;
//        CGFloat containHeight = 100;
//        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//        rect = CGRectMake(rect.size.width - containWidth -10 ,rect.origin.y + rect.size.height/2.0 - containHeight/2.0 , 1, 1);
//        UIViewController * con = [[UIViewController alloc]init];
//        con.view.backgroundColor = [UIColor redColor];
//        con.view.frame = CGRectMake(0, 0 , containWidth, containHeight);
//        UIPopoverController * pc = [[UIPopoverController alloc]initWithContentViewController:con];
//        pc.popoverContentSize = CGSizeMake(containWidth,containHeight);
//        [pc presentPopoverFromRect:rect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:NO];
        UINavigationController  * nav = (UINavigationController *)[[self.splitViewController viewControllers]lastObject];
        SmbFileOperateViewController * smbFOVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFileOperateViewController"];
        smbFOVC.smbFile = (KxSMBItemFile*)item;
        [nav pushViewController:smbFOVC animated:YES];
        
    }
}
                                
#pragma mark UITextFieldDelegate
                                
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.fileName = textField.text;
}


#pragma mark FileTransmissionProtocal
-(NSString *)currentSMBPath
{
    return self.path;
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
