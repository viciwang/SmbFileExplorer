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

@end

@implementation SmbFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self reloadPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    KxSMBItem * item = [self.fileArrayDataSource itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[KxSMBItemTree class]])
    {
        UINavigationController  * nav = (UINavigationController *)[[self.splitViewController viewControllers]lastObject];
        SmbFileViewController * smbFileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SmbFolderViewController"];
        smbFileVC.path = item.path;
        [nav pushViewController:smbFileVC animated:YES];
    }
    else
    {
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
