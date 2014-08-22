//
//  ModalAnimation.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalAnimation.h"

@implementation ModalAnimation {
    UIView *maskView;
    NSArray *_constraints;
}

@synthesize modalAnimationType;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if(ModalAnimationTypePresented == self.modalAnimationType) {
        return 1.2f;
    } else {
        return 0.4f;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if(ModalAnimationTypePresented == self.modalAnimationType) {
        [self presentedAnimationTransition:transitionContext];
    } else {
        [self dissmissedAnimationTransition:transitionContext];
    }
}

- (void)presentedAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *modalView = toViewController.view;
    
    //
    if(maskView == nil) {
        maskView = [[UIView alloc] initWithFrame:containerView.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.f;
    }
    [containerView addSubview:maskView];
    [containerView addSubview:modalView];
    
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(containerView, modalView);
    _constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[modalView]-15-|" options:0 metrics:nil views:views] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[modalView]-20-|" options:0 metrics:nil views:views]];
    [containerView addConstraints:_constraints];
    
    CGRect endFrame = modalView.frame;
    modalView.frame = CGRectMake(endFrame.origin.x, containerView.bounds.size.height, endFrame.size.width, endFrame.size.height);
    
    // damping  类似于摩擦系数 越大摩擦越大 减震效果越好
    // velocity 代表速度
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.7f initialSpringVelocity:1.5f options:0
                     animations:^ {
                         modalView.frame = endFrame;
                         maskView.alpha = 0.7f;
                     }
                     completion:^(BOOL finished){
                         [transitionContext completeTransition:YES];
                     }
     ];
}

- (void)dissmissedAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *modalView = toViewController.view;
    
    CGRect endFrame = CGRectMake(modalView.frame.origin.x, containerView.bounds.size.height, modalView.bounds.size.width, modalView.bounds.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         modalView.frame = endFrame;
                         maskView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [maskView removeFromSuperview];
                         [containerView removeConstraints:_constraints];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
