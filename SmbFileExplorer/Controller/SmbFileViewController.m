//
//  SmbFileViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/6.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileViewController.h"
#define INDEX_FOR_UNSELECTED_CELL  (-100)   // 如果没有选中某个cell，选中下标为-100。 Attention： 绝对不能为-1

static NSString * const SmbFileCellIdentifier = @"SmbFileCell";


@interface SmbFileViewController ()

@property (nonatomic,strong) NSMutableArray * fileItems;
@property (nonatomic,copy)   TableViewCellConfigureBlock cellConfigBlock;
@property (nonatomic,strong) SmbFilesArrayDataSource * fileArrayDataSource;
@property (nonatomic,strong) NSString * fileName;
@property (nonatomic) NSInteger indexForSelectedCell;

@end

@implementation SmbFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigationBar];
    [self reloadPath];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //  一定要remove，不然会调用多次
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteFileAction:) name:@"DeleteFile" object:nil];
    [FileTransmissionViewController shareFileTransmissionVC].delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
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
    self.fileArrayDataSource.smbFileDelegate = self;
    self.indexForSelectedCell = INDEX_FOR_UNSELECTED_CELL;
}

-(void)setupNavigationBar
{
    UIBarButtonItem * barButtonItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addFolderAction)];
    
    UIBarButtonItem * toolBarButtonItem1 = [[UIBarButtonItem alloc]initWithTitle:@"上传/下载管理"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                          action:@selector(showTransmissionAction:)];
    
    UIBarButtonItem * toolBarButtonItem2 = [[UIBarButtonItem alloc]initWithTitle:@"本地文件"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(addFileAction)];
    UIBarButtonItem * toolBarButtonItem3 = [[UIBarButtonItem alloc]initWithTitle:@"断开连接"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(showTransmissionAction:)];
    
    UIBarButtonItem * flexibleItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:barButtonItem1, nil];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.toolbarItems = [[NSArray alloc]initWithObjects:flexibleItem,toolBarButtonItem1,flexibleItem,toolBarButtonItem2 ,flexibleItem,toolBarButtonItem3,flexibleItem,nil];
}

-(void)showTransmissionAction:(id)sender
{
    UIPopoverController * p = [[UIPopoverController alloc]initWithContentViewController:[FileTransmissionViewController shareFileTransmissionVC]];
    [p presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
    
    [self removeOperateCell];
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"新文件夹的名字" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [weakSelf.fileArrayDataSource addItemKind:NSStringFromClass([KxSMBItemTree class]) Named:weakSelf.fileName Handler:^(id status){
//            if ([status isKindOfClass:[KxSMBItemTree class]])
//            {
//                [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.fileArrayDataSource.items.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fileArrayDataSource.items.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            }
//            else
//            {
//                    
//            }
//        }];
        
        [weakSelf.fileArrayDataSource insertItemType:FileTypeKxSMBItemTree Named:weakSelf.fileName AtIndex:-1];
    }];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:actionOK];
    [ac addAction:actionCancel];
    [ac addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.delegate = weakSelf;
    }];
    
    [self presentViewController:ac
                       animated:YES
                     completion:nil];

    
}

-(void)addFileAction
{
    [self removeOperateCell];
    ChooseLocalFileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseLocalFile"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(void)deleteFileAction:(NSIndexPath *)indexPath
{
    [self removeOperateCell];
    CompleteBlock block = ^(id status){
        if ([status isKindOfClass:[NSError class]])
        {
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:actionOK];
            [self presentViewController:ac animated:YES completion:nil];
        }
    };
    
//    __weak typeof(self) weakSelf = self;
//    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"确定要删除文件" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [weakSelf.fileArrayDataSource removeItemAtIndex:indexPath.row Handler:block];
//    }];
//    
//    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//    [ac addAction:actionOK];
//    [ac addAction:actionCancel];
//    [self.splitViewController presentViewController:ac animated:YES completion:nil];
}


-(void)reloadPath
{
    
    // 刷新之前，先把展开的cell remove掉
    [self removeOperateCell];
    
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
        [self.tableView beginUpdates];

        if ([self isSelectedIndexPath:indexPath])
        {
            [self removeOperateCell];
            
        }
        else
        {
            // 注意要先保存indexForSelectedCell,不然会被removeOperate覆盖
            NSInteger temIndex = self.indexForSelectedCell;
            [self removeOperateCell];
            
            // removeOperateCell 之后，在operate之下的cell的indexPath.row可能会减一
            if (temIndex>=0 && temIndex<indexPath.row)
            {
                self.indexForSelectedCell = indexPath.row - 1;
            }
            else
            {
                self.indexForSelectedCell = indexPath.row;
            }
            
            [self.fileArrayDataSource insertItemType:FileTypeItemOperate
                                               Named:nil
                                             AtIndex:self.indexForSelectedCell+1];
        }
        
        [self.tableView endUpdates];
        
//        UINavigationController  * nav = (UINavigationController *)[[self.splitViewController viewControllers]lastObject];
//        SmbFileOperateViewController * smbFOVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFileOperateViewController"];
//        smbFOVC.smbFile = (KxSMBItemFile*)item;
//        [nav pushViewController:smbFOVC animated:YES];
        
    }
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeOperateCell];
}



#pragma mark SmbFileArrayDelegate
-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didInsertItem:(id)item intoIndex:(NSInteger)index
{
    [self.tableView beginUpdates];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    //  不是最后一行，滚动不会出错。如果是最后一行，滚动会出错。
    if (index != dataSource.items.count-1) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:YES];
    }


    
    
}




-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didRemoveItemAtIndex:(NSInteger)index
{
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index
                                                                inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
}

-(void)smbFileArrayDataSource:(SmbFilesArrayDataSource *)dataSource didFailToAddSmbFile:(NSError *)error
{
    
}

#pragma mark TableViewCell Bussiness 

-(BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.indexForSelectedCell==indexPath.row )
    {
        return YES;
    }
    return NO;
}

-(BOOL)isOperateCellAtIndexPath:(NSIndexPath *)indexPath
{
    // INDEX_FOR_UNSELECTED 不能为-1 的原因在此，为-1会导致判断出错
    if (indexPath && (self.indexForSelectedCell+1)==indexPath.row)
    {
        return YES;
    }
    return NO;
}


-(void)removeOperateCell
{
    if (self.indexForSelectedCell>=0)
    {
        [self.fileArrayDataSource removeItemAtIndex:self.indexForSelectedCell+1];
        self.indexForSelectedCell = INDEX_FOR_UNSELECTED_CELL;
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
