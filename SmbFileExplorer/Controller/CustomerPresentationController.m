//
//  CustomerPresentationController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/9.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "CustomerPresentationController.h"
#import "FolderNameFormViewController.h"

@implementation CustomerPresentationController

-(UIViewController *)presentedViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FolderNameForm"];
}

-(CGSize)preferredContentSize
{
    return CGSizeMake(300, 200);
}

-(UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationFormSheet;
}



@end
