//
//  LocalFileViewController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/10.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "LocalFileViewController.h"
#import "SmbFileViewController.h"

@interface LocalFileViewController ()

@property (nonatomic,strong) LocalFileDataSource * localFileDataSource;
@property (nonatomic,strong) UIImageView * animationImageView;
@end

static NSString * const LocalFileCellIdentifier = @"LocalFileCellIdentifier";

@implementation LocalFileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(dismissLocalFileViewController:)];
    [self setupTableView];
    self.animationImageView = [[UIImageView alloc]init];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setupTableView
{
    TableViewCellConfigureBlock block = ^(LocalFileCell * cell,LocalFileModal * item){
        [cell configureForLocalFileModal:item andDelegate:self];
    };
    self.localFileDataSource = [[LocalFileDataSource alloc]initWithItem:[self localFiles] cellIdentifier:LocalFileCellIdentifier configureCellBlock:block];
    self.tableView.dataSource = self.localFileDataSource;
}

-(NSMutableArray *)localFiles
{
    NSString * docPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * array = [fileManager subpathsAtPath:docPath];
    NSMutableArray * localFile = [NSMutableArray array];
    for (NSString * str in array)
    {
        NSDictionary * dic = [fileManager attributesOfItemAtPath:[docPath stringByAppendingPathComponent:str] error:nil];
        if (dic)
        {
            LocalFileModal * file = [[LocalFileModal alloc]init];
            file.path = [docPath stringByAppendingPathComponent:str];
            file.fileSize = [[dic objectForKey:@"NSFileSize"] unsignedLongLongValue];
            [localFile addObject:file];
            
        }
    }
    return localFile;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * fileName = [self.localFileDataSource.items objectAtIndex:indexPath.row];
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    path = [NSString stringWithFormat:@"%@/%@",path,fileName];
//    NSString * remotePath =[NSString stringWithFormat:@"%@/%@",[[FileTransmissionViewController shareUploadVC].delegate currentSMBPath],[path lastPathComponent]];
//    FileTransmissionModal * modal  = [[FileTransmissionModal alloc]initWithTransmissionType:FileTransmissionUpload
//                                                                                   fromPath:path
//                                                                                     toPath:remotePath
//                                                                                   withInfo:nil];
//    [[FileTransmissionViewController shareUploadVC] addTask:modal];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    LocalFileModal * file = (LocalFileModal *)[self.localFileDataSource itemAtIndexPath:indexPath];
    NSURL * url = [NSURL fileURLWithPath:file.path];
    UIDocumentInteractionController * dVC = [UIDocumentInteractionController interactionControllerWithURL:url];
    dVC.delegate = self;
    [dVC presentPreviewAnimated:YES];
    
}


-(void)dismissLocalFileViewController:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark LocalFileDelegate
-(void)deleteFileForCell:(LocalFileCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    if ([self.localFileDataSource removeFileAtIndex:index.row])
    {
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else
    {
        
    }
    
}


-(void)openFileForCell:(LocalFileCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    LocalFileModal * file = (LocalFileModal *)[self.localFileDataSource itemAtIndexPath:index];
    NSURL * url = [NSURL fileURLWithPath:file.path];
    UIDocumentInteractionController * dVC = [UIDocumentInteractionController interactionControllerWithURL:url];
    dVC.delegate = self;
    [dVC presentPreviewAnimated:YES];
    
}

-(void)uploadFileForCell:(LocalFileCell *)cell
{
    self.animationImageView.image = [[UIImage alloc]initWithCGImage:cell.fileImage.image.CGImage];
    self.animationImageView.frame = [cell convertRect:cell.fileImage.frame toView:[[UIApplication sharedApplication]keyWindow]];
    [SystemStuff beginPathAnimation:self.animationImageView beginPoint:self.animationImageView.center endPoint:[SmbFileViewController locationOfFirstToolbarButtonItem] delegate:self];
    
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    LocalFileModal * file = (LocalFileModal *)[self.localFileDataSource itemAtIndexPath:index];
    NSString * remotePath =[NSString stringWithFormat:@"%@/%@",[[FileTransmissionViewController shareUploadVC].delegate currentSMBPath],[file.path lastPathComponent]];
    FileTransmissionModal * modal  = [[FileTransmissionModal alloc]initWithTransmissionType:FileTransmissionUpload
                                                                                   fromPath:file.path
                                                                                     toPath:remotePath
                                                                                   withInfo:nil];
    [[FileTransmissionViewController shareUploadVC] addTask:modal];
}

-(void) beginUploadAnimation
{
    
}


#pragma mark UIDocumentInteractionControllerDelegate
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
}


#pragma mark 
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.animationImageView removeFromSuperview];
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
