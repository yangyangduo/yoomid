//
//  BackViewController.m
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BackViewController.h"

@implementation BackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightPanDismissWithTransitionStyle];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
}

- (void)popViewController {
    [self rightPopViewControllerAnimated:YES];
}

@end
