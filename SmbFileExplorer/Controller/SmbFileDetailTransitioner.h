//
//  SmbFileDetailTransitioner.h
//  SmbFileExplorer
//
//  Created by wgl on 15/4/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SmbFileDetailPresentationController.h"
#import "SmbFileDetailViewController.h"

@interface SmbFileDetailTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL isPresentation;
@property (nonatomic) CGRect originFrame;
-(instancetype)initWithOriginFrame:(CGRect)frame isPresentation:(BOOL)b;
@end


@interface SmbFileDetailTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>
-(instancetype)initWithOriginFrame:(CGRect)oframe;
@end
