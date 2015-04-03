//
//  SettingViewController.h
//  SmbFileExplorer
//
//  Created by wgl on 15/4/1.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingDelegate <NSObject>

-(void)settingHadBeenChanged:(NSDictionary *)setting;

@end

@interface SettingViewController : UIViewController
@property (nonatomic,weak) id<SettingDelegate> settingDelegate;
@end
