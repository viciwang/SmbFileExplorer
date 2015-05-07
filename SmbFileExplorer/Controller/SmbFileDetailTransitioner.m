//
//  SmbFileDetailTransitioner.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileDetailTransitioner.h"

@implementation SmbFileDetailTransitionAnimation

-(instancetype)initWithOriginFrame:(CGRect)frame isPresentation:(BOOL)b
{
    self = [super init];
    if (self) {
        self.isPresentation = b;
        self.originFrame = frame;
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
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresentation = self.isPresentation;
    UIView * containerView = transitionContext.containerView;
    if (isPresentation) {
        [containerView addSubview:toVC.view];
    }
    
    SmbFileDetailViewController * smbFileDetailVC = (SmbFileDetailViewController *)(self.isPresentation?toVC:fromVC);
    //smbFileDetailVC
    CGRect superFrame = (self.isPresentation?fromVC.view.frame:toVC.view.frame);
    CGRect halfFrame = CGRectMake(superFrame.size.width/4.0, superFrame.size.height/4.0, superFrame.size.width/2.0, superFrame.size.height/2.0);
    CGRect initialFrame = self.isPresentation?self.originFrame:halfFrame;
    CGRect finalFrame = self.isPresentation?halfFrame:self.originFrame;
    smbFileDetailVC.view.frame = initialFrame;
    

    for (UIView * v in smbFileDetailVC.view.subviews)
    {
        [v setHidden:YES];
    }
    if ([self isPresentation])
    {
        toVC.view.alpha = 0.0;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:300.0
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [smbFileDetailVC.view setFrame:finalFrame];
                         if (![self isPresentation]) {
                             fromVC.view.alpha = 0.0;
                         }
                         else
                         {
                             toVC.view.alpha = 1.0;
                         }

                     } completion:^(BOOL finished) {

                         for (UIView * v in smbFileDetailVC.view.subviews)
                         {
                             [v setHidden:NO];
                         }
                        
                         if (![self isPresentation]) {
                             [fromVC.view removeFromSuperview];
                         }
                         [transitionContext completeTransition:YES];
                     }];
}

@end


@interface SmbFileDetailTransitionDelegate ()
@property (nonatomic) CGRect originFrame;

@end

@implementation SmbFileDetailTransitionDelegate

-(instancetype)initWithOriginFrame:(CGRect)oframe
{
    self = [super init];
    if (self) {
        self.originFrame = oframe;
    }
    return self;
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    SmbFileDetailPresentationController * pre = [[SmbFileDetailPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    pre.originFrame = self.originFrame;
    return pre;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SmbFileDetailTransitionAnimation * ani = [[SmbFileDetailTransitionAnimation alloc]initWithOriginFrame:self.originFrame isPresentation:YES];
    return ani;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SmbFileDetailTransitionAnimation * ani = [[SmbFileDetailTransitionAnimation alloc]initWithOriginFrame:self.originFrame isPresentation:NO];
    return ani;
}

@end
