//
//  SmbCacheFileTransitioner.h
//  SmbFileExplorer
//
//  Created by wgl on 15/3/20.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SmbCacheFilePresentationController;

@interface SmbCacheFileAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
@property (nonatomic) BOOL isPresentation;
@end

@interface SmbCacheFileTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

@end