//
//  SmbFileDetailViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/4/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxSMBProvider.h"
#import "SystemStuff.h"

@interface SmbFileDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
-(void)configureUIWithKxSMBItemFile:(KxSMBItemFile *)smbFile;
@end
