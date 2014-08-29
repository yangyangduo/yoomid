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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)popViewController {
    [self rightPopViewControllerAnimated:YES];
}

@end
