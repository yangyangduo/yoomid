//
//  TransitionViewController.m
//  private_share
//
//  Created by Zhao yang on 8/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TransitionViewController.h"

@implementation TransitionViewController

@synthesize animationController = _animationController_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animationController_ = [[PanAnimationController alloc] initWithContainerController:self];
    self.animationController.delegate = self;
}

#pragma mark -
#pragma mark Transition delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _animationController_.animationType = PanAnimationControllerTypePresentation;
    return _animationController_;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animationController_.animationType = PanAnimationControllerTypeDismissal;
    return _animationController_;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if([animator isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animationController = (PanAnimationController *)animator;
        if(animationController.isInteractive) return animationController;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if([animator isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animationController = (PanAnimationController *)animator;
        if(animationController.isInteractive) return animationController;
    }
    return nil;
}

#pragma mark -
#pragma mark Animation delegate

- (UIViewController *)leftPresentationViewController {
    return nil;
}

- (UIViewController *)rightPresentationViewController {
    return nil;
}

- (CGFloat)leftPresentViewControllerOffset {
    return 0.f;
}

- (CGFloat)rightPresentViewControllerOffset {
    return 0.f;
}

@end
