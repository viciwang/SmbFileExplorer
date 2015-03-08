//
//  SmbFileCell.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxSMBProvider.h"

@interface SmbFileCell : UITableViewCell
-(void)configureForSmbFile:(KxSMBItem *)item;
@end
