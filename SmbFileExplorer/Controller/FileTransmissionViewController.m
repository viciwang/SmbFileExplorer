//
//  FileTransmissionViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "FileTransmissionViewController.h"

static NSString * const FileTrainsmissionCellIdentifier = @"FileTrainsmissionCellIdentifier";
static FileTransmissionViewController * downloadFileTVC;
static FileTransmissionViewController * uploadFileTVC;

@interface FileTransmissionViewController ()

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

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)setupTableView
{
    TableViewCellConfigureBlock block = ^(FileTransmissionCell * cell ,FileTransmissionModal * item){
        [cell configureForTask:item];
    };
    self.ftDatasource = [[SmbFileTransmissionDataSource alloc]initWithItem:[NSMutableArray array] cellIdentifier:FileTrainsmissionCellIdentifier configureCellBlock:block];
    self.tableView.dataSource = self.ftDatasource;
    self.ftDatasource.ftVC = self;
}


-(void)addTask:(FileTransmissionModal *)modal
{
    [self.ftDatasource addSFTItem:modal];
}

-(void)suspendAllTasks
{
    [self.ftDatasource suspendAllTasks];
}


-(void)resumeAllTasks
{
    [self.ftDatasource resumeAllTasks];
}

-(void)reAddAllTasks:(NSArray *)tasks
{
    [self.ftDatasource reAddAllTasks:[tasks copy]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(FileTransmissionViewController*)shareDownloadVC
{
    static dispatch_once_t dFileTVCOnceToken;
    dispatch_once(&dFileTVCOnceToken, ^{
        downloadFileTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FileTransmission"];
        [downloadFileTVC setupTableView];
    });
    return downloadFileTVC;
}

+(FileTransmissionViewController*)shareUploadVC
{
    static dispatch_once_t uFileTVCOnceToken;
    dispatch_once(&uFileTVCOnceToken, ^{
        uploadFileTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FileTransmission"];
        [uploadFileTVC setupTableView];
    });
    return uploadFileTVC;
}




@end
