//
//  CubeViewController.m
//  private_share
//
//  Created by Zhao yang on 7/26/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CubeViewController.h"

@implementation CubeViewController

@synthesize leftViewController = _leftViewController_;
@synthesize rightViewController = _rightViewController_;

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                         LeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    self = [super init];
    if(self) {
        _leftViewController_ = leftViewController;
        _rightViewController_ = rightViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    /* add gestures */
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeGesture];
    
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    //[self.view addGestureRecognizer:panGesture];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture {
    if(UISwipeGestureRecognizerDirectionLeft == swipeGesture.direction) {
        NSLog(@"left");
    } else if(UISwipeGestureRecognizerDirectionRight == swipeGesture.direction) {
        NSLog(@"right");
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
}

@end
