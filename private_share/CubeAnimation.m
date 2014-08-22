//
//  CubeAnimation.m
//  private_share
//
//  Created by Zhao yang on 7/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CubeAnimation.h"

@implementation CubeAnimation {
    id<UIViewControllerContextTransitioning> _transitionContext_;
    UIPanGestureRecognizer *panGesture;
    UIView *_containerView_;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return self;
}

- (instancetype)initWithPanContainerView:(UIView *)containerView {
    self = [self init];
    if(self) {
        _containerView_ = containerView;
        [_containerView_ addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [CATransaction setCompletionBlock:^{
        [transitionContext completeTransition:YES];
    }];
    
    [CATransaction begin];
    
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = [self transitionDuration:transitionContext];
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    animation.removedOnCompletion = YES;
    [containerView.layer addAnimation:animation forKey:@"animation"];
    
    [CATransaction commit];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.f;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext_ = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    [containerView addGestureRecognizer:panGesture];
}



- (void)handlePanGesture:(UIPanGestureRecognizer *)pGesture {
    [_transitionContext_ updateInteractiveTransition:0.5f];
}


@end
