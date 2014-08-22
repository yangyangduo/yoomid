//
//  CubeAnimation.h
//  private_share
//
//  Created by Zhao yang on 7/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CubeAnimation : NSObject<UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

- (instancetype)initWithPanContainerView:(UIView *)containerView;

@end
