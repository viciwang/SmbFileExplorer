//
//  SmbAuthMessageViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmbAuth.h"

@class SmbMasterViewController;

@interface SmbAuthMessageViewController : UIViewController



-(void)configureSmbMasterVC:(SmbMasterViewController*)vc IsNewAuthView:(BOOL)flag SmbAuth:(SmbAuth *)smbAuth;

@end
