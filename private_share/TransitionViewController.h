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

@end
