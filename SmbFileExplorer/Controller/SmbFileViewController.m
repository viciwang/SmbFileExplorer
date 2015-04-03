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
@property (nonatomic,strong)SmbCacheFileTransitionDelegate * smbCacheFileTransitionDelegate;
@property (nonatomic) BOOL shouldShowHiddenFile;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldReloadPath:) name:@"ShouldReloadPath" object:nil];
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
                                                                          action:@selector(showLocalFileAction:)];
    
    UIBarButtonItem * toolBarButtonItem3 = [[UIBarButtonItem alloc]initWithTitle:@"设置"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(showSettingAction:)];
    
    UIBarButtonItem * flexibleItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:barButtonItem1, nil];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.toolbarItems = [[NSArray alloc]initWithObjects:flexibleItem,toolBarButtonItem1,flexibleItem,toolBarButtonItem2 ,flexibleItem,toolBarButtonItem3,flexibleItem, nil];
}

-(void)showTransmissionAction:(UIBarButtonItem *)sender
{
//    UIPopoverController * p = [[UIPopoverController alloc]initWithContentViewController:[FileTransmissionViewController shareFileTransmissionVC]];
//    [p presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    

    
    UIViewController * transmissionVC = [FileTransmissionViewController shareFileTransmissionVC];
    
//    transmissionVC.modalPresentationStyle = UIModalPresentationPopover;
//    UIPopoverPresentationController * popover = transmissionVC.popoverPresentationController;
//    popover.barButtonItem = sender;
//    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    [self presentViewController:transmissionVC animated:YES completion:nil];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:transmissionVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
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

-(void)showLocalFileAction:(id)sender
{
    [self removeOperateCell];
    LocalFileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalFileViewController"];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)showSettingAction:(id)sender
{
    SettingViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    vc.settingDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController * pop = vc.popoverPresentationController;
    pop.barButtonItem = (UIBarButtonItem *)sender;
    pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
    pop.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)shouldReloadPath:(NSNotification *)notification
{
    
//  不能单纯用 stringByDeletingLastPathComponent:
//  stringByDeletingLastPathComponent 会将  smb://192.168.4.154/samba/NewFolder/447066152.tmp
//                                    变为  smb:/192.168.4.154/samba/NewFolder
//
    NSString * p = [[[notification.userInfo objectForKey:@"Path"] stringByDeletingLastPathComponent] substringFromIndex:@"smb:/".length];
    if (p==nil) {
        return;
    }
    for (SmbFileViewController * vc in self.navigationController.viewControllers)
    {
        if ([[vc.path substringFromIndex:@"smb://".length]  isEqualToString:p])
        {
            [vc reloadPath];
        }
    }
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell * headerView = [self.tableView dequeueReusableCellWithIdentifier:@"HeaderViewForSmbFile"];
    if (headerView == nil) {
        
    }
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
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

-(void)shouldReloadFile:(BOOL)shouldReloadPath;
{
    if (shouldReloadPath)
    {
        [self reloadPath];
    }
    else
        [self.tableView reloadData];
    
}

#pragma mark SettingDelegate
-(void)settingHadBeenChanged:(NSDictionary *)setting
{
    [setting enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"ShouldShowHiddenFile"])
        {
            self.shouldShowHiddenFile = [obj boolValue];
        }
    }];
}

#pragma mark TableViewCell Bussiness 

-(BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.indexForSelectedCell==indexPath.row)
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


#pragma mark SmbFileOperateDelefate

-(void)downloadSmbFile:(id)button
{
    
    KxSMBItemFile * file = [self.fileArrayDataSource itemAtIndexPath:[NSIndexPath indexPathForItem:self.indexForSelectedCell
                                                                                         inSection:0]];
    
    NSString * localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    localPath = [NSString stringWithFormat:@"%@/%@",localPath,[file.path lastPathComponent]];
    FileTransmissionModal * modal = [[FileTransmissionModal alloc] initWithTransmissionType:FileTransmissionDownload
                                                                                   fromPath:file.path
                                                                                     toPath:localPath
                                                                                   withInfo:file.stat];
    
    FileTransmissionViewController * ftVC = [FileTransmissionViewController shareFileTransmissionVC];
    
    [ftVC addTask:modal];
    
}

-(void)deleteSmbFile:(id)button
{
    NSInteger  temIndex = self.indexForSelectedCell;
    [self removeOperateCell];
    [self.fileArrayDataSource removeItemAtIndex:temIndex];
}

-(void)showPropertyOfSmbFile:(id)button
{
    
}

-(void)showOpenModeOfSmbFile:(id)button
{
    KxSMBItemFile * file = [self.fileArrayDataSource itemAtIndexPath:[NSIndexPath indexPathForItem:self.indexForSelectedCell
                                                                                         inSection:0]];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cachePath = [NSString stringWithFormat:@"%@/%@",cachePath,[file.path lastPathComponent]];
    
    
    
    SmbFileOperateViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFileOperateViewController"];
    [vc configureWithSmbFile:file delegate:self];
    self.smbCacheFileTransitionDelegate = [[SmbCacheFileTransitionDelegate alloc]init];
    vc.transitioningDelegate = self.smbCacheFileTransitionDelegate;
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
//    NSString * string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/123.png",string]];
//     UIDocumentInteractionController * dVC = [UIDocumentInteractionController interactionControllerWithURL:url];
//   // [dVC setDelegate:self];
//    
//    //[dVC presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//
//    //[dVC presentOpenInMenuFromRect:[b.viewForBaselineLayout convertRect:b.frame toView:self.view] inView:self.view animated:YES];
//    dVC.delegate = self;
//    [dVC presentPreviewAnimated:YES];

    
}

-(void)previewSmbFile:(id)button
{
    
}


#pragma mark UIDocumentInteractionControllerDelegate

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
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


#pragma mark SmbFileCacheDelegate

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

#pragma mark UIPopoverPresentationControllerDelegate
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    for (SmbFileViewController * vc in self.navigationController.viewControllers)
    {
       [vc.fileArrayDataSource hiddenFileSettingHasChanged:self.shouldShowHiddenFile];
    }
    
}


@end
