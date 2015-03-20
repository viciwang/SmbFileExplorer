//
//  SmbCacheFileTransitioner.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/20.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbCacheFileTransitioner.h"
#import "SmbCacheFilePresentationController.h"

@interface SmbCacheFileAnimationTransition()

@end

@implementation SmbCacheFileAnimationTransition

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.isPresentation = NO;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * fromView = fromVC.view;
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView  = toVC.view;
    
    if (self.isPresentation)
    {
        [[transitionContext containerView] addSubview:toView];
    }
    
    UIViewController * animatingVC = self.isPresentation?toVC:fromVC;
    UIView * animatingView = animatingVC.view;
    CGRect  appearedFrame = [transitionContext finalFrameForViewController:animatingVC];
    CGRect dismissedFrame = appearedFrame;
    dismissedFrame.origin.y +=dismissedFrame.size.height;
    CGRect initialFrame = self.isPresentation?dismissedFrame:appearedFrame;
    CGRect finalFrame = self.isPresentation?appearedFrame:dismissedFrame;
    animatingView.frame = initialFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:300.0
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         animatingView.frame = finalFrame;
                     }completion:^(BOOL value){
                         if (!self.isPresentation)
                         {
                            [fromView removeFromSuperview];
                         }
                         [transitionContext completeTransition:YES];
                     }];
    
}
@end



@implementation SmbCacheFileTransitionDelegate

#pragma mark UIViewControllerTrainsitionDelegationDelegate

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    SmbCacheFilePresentationController * presentationController = [[SmbCacheFilePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SmbCacheFileAnimationTransition * animationController = [[SmbCacheFileAnimationTransition alloc]init];
    animationController.isPresentation = YES;
    return animationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SmbCacheFileAnimationTransition * animationController = [[SmbCacheFileAnimationTransition alloc]init];
    animationController.isPresentation = NO;
    return animationController;
}

@end
