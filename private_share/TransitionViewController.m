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
    
    if(self.navigationController != nil) {
        BOOL isRootViewController = [self.navigationController.viewControllers firstObject] == self;
        if(isRootViewController) {
            self.navigationController.delegate = self;
        }
    }
}

- (void)rightPresentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // set up view controller
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    
    // config default
    self.animationController.animationType = PanAnimationControllerTypePresentation;
    self.animationController.panDirection = PanDirectionLeft;
    self.animationController.ignoreOffset = YES;
    
    [self presentViewControllerInternal:viewController animated:animated];
}

- (void)leftPresentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // set up view controller
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    
    // config default
    self.animationController.animationType = PanAnimationControllerTypePresentation;
    self.animationController.panDirection = PanDirectionLeft;
    self.animationController.ignoreOffset = YES;
    
    [self presentViewControllerInternal:viewController animated:animated];
}

- (void)presentViewControllerInternal:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.navigationController != nil) {
        [self.navigationController presentViewController:viewController animated:animated completion:^{ }];
    } else {
        [self presentViewController:viewController animated:animated completion:^{ }];
    }
}

- (void)rightDismissViewControllerAnimated:(BOOL)animated {
    self.animationController.panDirection = PanDirectionRight;
    self.animationController.animationType = PanAnimationControllerTypeDismissal;
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)leftDismissViewControllerAnimated:(BOOL)animated {
    self.animationController.panDirection = PanDirectionLeft;
    self.animationController.animationType = PanAnimationControllerTypeDismissal;
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)rightPopViewControllerAnimated:(BOOL)animated {
    self.animationController.panDirection = PanDirectionRight;
    [self.navigationController popViewControllerAnimated:animated];
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
#pragma mark Navigation controller delegate (only dismiss)

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if(operation == UINavigationControllerOperationPop) {
        if([fromVC isKindOfClass:[TransitionViewController class]]) {
            TransitionViewController *tvc = (TransitionViewController *)fromVC;
            tvc.animationController.animationType = PanAnimationControllerTypeDismissal;
            return tvc.animationController;
        }
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if([animationController isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *_pan_animation_controller_ = (PanAnimationController *)animationController;
        if(_pan_animation_controller_.animationType == PanAnimationControllerTypeDismissal
                && _pan_animation_controller_.isInteractive) {
            return _pan_animation_controller_;
        }
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
