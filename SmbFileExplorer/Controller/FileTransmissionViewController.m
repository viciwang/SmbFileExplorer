//
//  FileTransmissionViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionViewController.h"

static NSString * const FileTrainsmissionCellIdentifier = @"FileTrainsmissionCellIdentifier";

@interface FileTransmissionViewController ()
@property (nonatomic,strong) SmbFileTransmissionDataSource * ftDatasource;
@end

@implementation FileTransmissionViewController

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
    TableViewCellConfigureBlock block = ^(FileTransmissionCell * cell ,FileTransmissionModal * item){
    };
    self.ftDatasource = [[SmbFileTransmissionDataSource alloc]initWithItem:[NSMutableArray array] cellIdentifier:FileTrainsmissionCellIdentifier configureCellBlock:block];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
