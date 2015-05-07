//
//  SmbFileDetailPresentationController.m
//  SmbFileExplorer
//
//  Created by wgl on 15/4/7.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "SmbFileDetailPresentationController.h"

@interface SmbFileDetailPresentationController ()

@property (nonatomic,strong) UIView * dimming;
@property (nonatomic,strong) UITapGestureRecognizer * gestureRecognize;

@end


@implementation SmbFileDetailPresentationController


-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        self.dimming = [[UIView alloc]init];
        self.dimming.backgroundColor = [[UIColor alloc]initWithWhite:0.0 alpha:0.4];
        self.dimming.alpha = 0.0;
    }
    return self;
}



-(void)presentationTransitionWillBegin
{
    self.dimming.alpha = 0.0;
    self.dimming.frame = self.containerView.bounds;
    [self.containerView insertSubview:self.dimming atIndex:0];
    
    if ([self.presentedViewController transitionCoordinator])
    {
        [[self.presentedViewController transitionCoordinator]animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimming.alpha = 1.0;
        } completion:nil];
    }
    else
    {
        self.dimming.alpha = 1.0;
    }
}

-(void)dismissalTransitionWillBegin
{
    if ([self.presentedViewController transitionCoordinator])
    {
        [[self.presentedViewController transitionCoordinator]animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimming.alpha = 1.0;
        } completion:nil];
    }
    else
    {
        self.dimming.alpha = 1.0;
    }
}

-(void)containerViewWillLayoutSubviews
{
    self.dimming.frame = self.containerView.bounds;
    //self.presentedView.frame = self.containerView.bounds;
}

@end
