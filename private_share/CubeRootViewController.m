//
//  CubeRootViewController.m
//  private_share
//
//  Created by Zhao yang on 7/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.

#import "CubeRootViewController.h"
#import "PortalViewController.h"
#import "CubeAnimation.h"

@implementation CubeRootViewController {
    CubeAnimation *animation;
}

- (id)init {
    self = [super init];
    if(self) {
        PortalViewController *portalViewController = [[PortalViewController alloc] init];
        UIViewController *vc2 = [[UIViewController alloc] init];
        portalViewController.view.tag = 100;
        vc2.view.tag = 200;

        vc2.title = @"测试";
        vc2.view.backgroundColor = [UIColor yellowColor];
        self.delegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.viewControllers = [NSArray arrayWithObjects:portalViewController, vc2, nil];
        
        animation = [[CubeAnimation alloc] initWithPanContainerView:self.view];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return animation;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if([animationController isKindOfClass:[CubeAnimation class]]) {
        CubeAnimation *cubeAnimation = (CubeAnimation *)animationController;
        return cubeAnimation;
    }
    return nil;
}
 
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
}

@end
