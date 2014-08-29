//
//  TransitionViewController.h
//  private_share
//
//  Created by Zhao yang on 8/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PanAnimationController.h"

@interface TransitionViewController : BaseViewController<UIViewControllerTransitioningDelegate, PanAnimationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong, readonly) PanAnimationController *animationController;

- (void)leftPresentViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)rightPresentViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)leftDismissViewControllerAnimated:(BOOL)animated;
- (void)rightDismissViewControllerAnimated:(BOOL)animated;

- (void)rightPopViewControllerAnimated:(BOOL)animated;

@end
