//
//  PanBackTransitionViewController.m
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PanBackTransitionViewController.h"

@implementation PanBackTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    self.animationController.dismissStyle = PanAnimationControllerDismissStyleTransition;
}

@end
