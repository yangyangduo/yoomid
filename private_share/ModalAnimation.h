//
//  ModalAnimation.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ModalAnimationType) {
    ModalAnimationTypePresented,
    ModalAnimationTypedismissed
};

@interface ModalAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ModalAnimationType modalAnimationType;

@end
