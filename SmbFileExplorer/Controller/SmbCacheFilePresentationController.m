//
//  SmbCacheFilePresentationController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/19.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbCacheFilePresentationController.h"

@interface SmbCacheFilePresentationController()

@property (nonatomic,strong)UIView * dimmingView;
@end

@implementation SmbCacheFilePresentationController



-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self)
    {
        self.dimmingView = [[UIView alloc]init];
        self.dimmingView.backgroundColor = [[UIColor alloc]initWithWhite:0.0 alpha:0.4];
        self.dimmingView.alpha = 0.0;
    }
    return  self;
}

-(void)presentationTransitionWillBegin
{
    UIViewController *presentedViewController = self.presentedViewController;
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0;
    
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    
    if ([presentedViewController transitionCoordinator]) {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 1.0;
        } completion:nil];
    } else {
        self.dimmingView.alpha = 1.0;
    }
}


- (void)dismissalTransitionWillBegin {
    if (self.presentedViewController.transitionCoordinator) {
        
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 0.0;
        } completion:nil];
        
    } else {
        self.dimmingView.alpha = 0.0;
    }
}


- (void)containerViewWillLayoutSubviews {
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = self.containerView.bounds;
}

- (BOOL)shouldPresentInFullscreen {
    return YES;
}

#pragma mark UIAdaptivePresentationControllerDelegate

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationOverFullScreen;
}



@end
