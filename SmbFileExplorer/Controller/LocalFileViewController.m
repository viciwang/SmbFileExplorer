//
//  LocalFileViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "LocalFileViewController.h"
#import "ChooseLocalFileViewController.h"

@interface LocalFileViewController ()

@property (nonatomic,strong) ArrayDataSource * localFileDataSource;

@end

static NSString * const LocalFileCellIdentifier = @"LocalFileCellIdentifier";

@implementation LocalFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupTableView];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setupTableView
{
    TableViewCellConfigureBlock block = ^(UITableViewCell * cell,NSString * item){
        cell.textLabel.text = item;
    };
    self.localFileDataSource = [[ArrayDataSource alloc]initWithItem:[self localFiles] cellIdentifier:LocalFileCellIdentifier configureCellBlock:block];
    self.tableView.dataSource = self.localFileDataSource;
}

-(NSMutableArray *)localFiles
{
    NSArray * path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * array = [fileManager subpathsAtPath:[path lastObject]];
    return [NSMutableArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * fileName = [self.localFileDataSource.items objectAtIndex:indexPath.row];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [NSString stringWithFormat:@"%@/%@",path,fileName];
    NSString * remotePath =[NSString stringWithFormat:@"%@/%@",[[FileTransmissionViewController shareFileTransmissionVC].delegate currentSMBPath],[path lastPathComponent]];
    FileTransmissionModal * modal  = [[FileTransmissionModal alloc]initWithTransmissionType:FileTransmissionUpload fromPath:path toPath:remotePath];
    [[FileTransmissionViewController shareFileTransmissionVC] addTask:modal];
    [self.clfVC dismissViewControllerAnimated:YES completion:nil];
    
//    vc.modalPresentationStyle = UIModalPresentationFormSheet;
//    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self.clfVC presentViewController:vc animated:YES completion:^{}];
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
