//
//  PanAnimation.h
//  private_share
//
//  Created by Zhao yang on 8/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PanAnimationControllerType) {
    PanAnimationControllerTypeNone                  =              0,
    PanAnimationControllerTypePresentation          =              1,
    PanAnimationControllerTypeDismissal             =              2
};

typedef NS_ENUM(NSUInteger, PanDirection)  {
    PanDirectionNone   =   0,
    PanDirectionLeft   =   1,
    PanDirectionRight  =   2
};

typedef NS_ENUM(NSUInteger, PanAnimationControllerDismissStyle) {
    PanAnimationControllerDismissStyleDefault         =     0,
    PanAnimationControllerDismissStyleTransition      =     1
};

@protocol PanAnimationControllerDelegate;

@interface PanAnimationController : NSObject<UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) PanAnimationControllerType animationType;
@property (nonatomic, assign) PanAnimationControllerType leftPanAnimationType;
@property (nonatomic, assign) PanAnimationControllerType rightPanAnimationType;

@property (nonatomic, assign) PanDirection panDirection;

@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic, assign) PanAnimationControllerDismissStyle dismissStyle;

@property (nonatomic, weak) id<PanAnimationControllerDelegate> delegate;

@property (nonatomic, weak) UIViewController<UIViewControllerTransitioningDelegate> *containerController;

- (instancetype)initWithContainerController:(UIViewController<UIViewControllerTransitioningDelegate> *)containerController;

@end

@protocol PanAnimationControllerDelegate <NSObject>

@optional

- (UIViewController *)leftPresentationViewController;
- (UIViewController *)rightPresentationViewController;

- (CGFloat)leftPresentViewControllerOffset;
- (CGFloat)rightPresentViewControllerOffset;

@end




