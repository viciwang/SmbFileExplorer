//
//  SmbMasterViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/3.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayDataSource.h"
#import "SmbAuthCell.h"
#import "SmbAuth.h"
#import "SmbAuthMessageViewController.h"
#import "SmbAuthArrayDataSource.h"
#import "SmbFileViewController.h"
#import "SmbAuth.h"
#import "PersistenceManager.h"
#import "NetworkManager.h"



@interface SmbMasterViewController : UITableViewController <KxSMBProviderDelegate>

@property (nonatomic,strong) SmbAuth * currentSmbAuth;

-(void)addSmbAuthCellForAuth:(SmbAuth*)smbAuth;
-(void)updateSmbAuthCellForAuth:(SmbAuth*)smbAuth;

@end
