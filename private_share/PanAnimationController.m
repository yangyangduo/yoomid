//
//  PanAnimation.m
//  private_share
//
//  Created by Zhao yang on 8/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PanAnimationController.h"

#define MASK_VIEW_TAG 8888
#define MASK_VIEW_FINAL_ALPHA 0.75f
#define SCREEN_CENTER_X [UIScreen mainScreen].bounds.size.width / 2

@implementation PanAnimationController {
    UIPanGestureRecognizer *panGesture;
    
    BOOL isAnimating;
    BOOL isGestureFailure;
    
    CGFloat dismissalStartOffset;
    CGFloat presentationEndOffset;
    
    UIView *maskView;
    UIView *transitionView;
    UIView *_containerView_;
    id<UIViewControllerContextTransitioning> context;
}

@synthesize animationType;
@synthesize leftPanAnimationType;
@synthesize rightPanAnimationType;
@synthesize panDirection;

@synthesize ignoreOffset;

@synthesize isInteractive;

@synthesize dismissStyle;

@synthesize containerController = _containerController_;
@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if(self) {
        //
        panDirection = PanDirectionNone;
        leftPanAnimationType = PanAnimationControllerTypeNone;
        rightPanAnimationType = PanAnimationControllerTypeNone;
        
        isAnimating = NO;
        isGestureFailure = NO;
        
        dismissStyle = PanAnimationControllerDismissStyleDefault;
        
        dismissalStartOffset = 0;
        presentationEndOffset = 0;
        
        //
        animationType = PanAnimationControllerTypePresentation;
        
        //
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        
        //
        maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;
        maskView.tag = MASK_VIEW_TAG;
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    }
    return self;
}

- (instancetype)initWithContainerController:(UIViewController<UIViewControllerTransitioningDelegate> *)containerController {
    self = [self init];
    if(self) {
        self.containerController = containerController;
        // add default gesture if it's not exists
        if(self.containerController != nil) {
            [self addGestrue:panGesture forView:self.containerController.view];
        }
    }
    return self;
}

#pragma mark -
#pragma mark

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [fromViewController viewWillDisappear:YES];
    [toViewController viewWillAppear:YES];
    
    isAnimating = YES;
    
    if(PanAnimationControllerTypePresentation == self.animationType) {
        toViewController.view.center = CGPointMake((
                            PanDirectionRight == panDirection ?
                            -SCREEN_CENTER_X :
                            SCREEN_CENTER_X * 3),
                           fromViewController.view.center.y);
        maskView.alpha = 0.f;
        [containerView insertSubview:maskView aboveSubview:fromViewController.view];
        [containerView insertSubview:toViewController.view aboveSubview:maskView];
        
        //
        presentationEndOffset = 0;
        if(!self.ignoreOffset) {
            if(PanDirectionRight == panDirection) {
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(leftPresentViewControllerOffset)]) {
                    presentationEndOffset = -[self.delegate leftPresentViewControllerOffset];
                }
            } else if(PanDirectionLeft == panDirection) {
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(rightPresentViewControllerOffset)]) {
                    presentationEndOffset = [self.delegate rightPresentViewControllerOffset];
                }
            }
        }
        presentationEndOffset = presentationEndOffset / 2;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.center = CGPointMake(SCREEN_CENTER_X + presentationEndOffset, fromViewController.view.center.y);
                             maskView.alpha = MASK_VIEW_FINAL_ALPHA;
                         }
                         completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                             
                             [fromViewController viewDidDisappear:YES];
                             [toViewController viewDidAppear:YES];
                             
                             isAnimating = NO;
                             presentationEndOffset = 0;
                             panDirection = PanDirectionNone;
                             ignoreOffset = NO;
                         }];
    } else {
        if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
            toViewController.view.center = CGPointMake(0, toViewController.view.center.y);
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        }
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.center = CGPointMake((PanDirectionLeft == panDirection ? -SCREEN_CENTER_X : SCREEN_CENTER_X * 3), fromViewController.view.center.y);
                             UIView *_mask_view_ = [containerView viewWithTag:MASK_VIEW_TAG];
                             if(_mask_view_) _mask_view_.alpha = 0;
                             if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
                                  toViewController.view.center = CGPointMake(SCREEN_CENTER_X, toViewController.view.center.y);
                             }
                         }
                         completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                             
                             [fromViewController viewDidDisappear:YES];
                             [toViewController viewDidAppear:YES];
                             
                             isAnimating = NO;
                             panDirection = PanDirectionNone;
                             ignoreOffset = NO;
                         }];
    }
}

#pragma mark -
#pragma mark

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [fromViewController viewWillDisappear:YES];
    [toViewController viewWillAppear:YES];
    
    if(PanAnimationControllerTypePresentation == self.animationType) {
        toViewController.view.center = CGPointMake((
                            PanDirectionRight == panDirection ?
                                -SCREEN_CENTER_X :
                                SCREEN_CENTER_X * 3),
                            fromViewController.view.center.y);
        maskView.alpha = 0.f;
        [containerView insertSubview:maskView aboveSubview:fromViewController.view];
        [containerView insertSubview:toViewController.view aboveSubview:maskView];
        transitionView = toViewController.view;
        
        //
        presentationEndOffset = 0;
        if(PanDirectionRight == panDirection) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(leftPresentViewControllerOffset)]) {
                presentationEndOffset = [self.delegate leftPresentViewControllerOffset];
            }
        } else if(PanDirectionLeft == panDirection) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(rightPresentViewControllerOffset)]) {
                presentationEndOffset = [self.delegate rightPresentViewControllerOffset];
            }
        }
        presentationEndOffset = presentationEndOffset / 2;
    } else {
        
        if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
            toViewController.view.center = CGPointMake(0, toViewController.view.center.y);
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        }
        transitionView = fromViewController.view;
        dismissalStartOffset = abs(abs(transitionView.center.x) - SCREEN_CENTER_X);
    }
    
    context = transitionContext;
    _containerView_ = containerView;
}

#pragma mark -
#pragma mark

- (void)updateInteractiveTransitionWithPercent:(CGFloat)percent translationX:(CGFloat)translationX {
    if(transitionView == nil) return;

    if(PanAnimationControllerTypePresentation == animationType) {
        CGFloat x = (PanDirectionRight == panDirection ?  -SCREEN_CENTER_X : SCREEN_CENTER_X * 3) + translationX;
        transitionView.center = CGPointMake(x, transitionView.center.y);
        maskView.alpha = MASK_VIEW_FINAL_ALPHA * percent;
    } else {
        transitionView.center = CGPointMake((PanDirectionLeft == panDirection ? (SCREEN_CENTER_X - abs(translationX) - dismissalStartOffset) : (SCREEN_CENTER_X + translationX + dismissalStartOffset)), transitionView.center.y);
        UIView *_mask_view_ =  [_containerView_ viewWithTag:MASK_VIEW_TAG];
        if(_mask_view_) _mask_view_.alpha = MASK_VIEW_FINAL_ALPHA * (1 - percent);
        
        if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
            UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            toViewController.view.center = CGPointMake(translationX / 2, toViewController.view.center.y);
        }
    }
    
    [context updateInteractiveTransition:percent];
}

- (void)endInteractiveTransition:(BOOL)cancelled {
    if(transitionView == nil) return;
    
    UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if(cancelled) {
        [fromViewController viewWillAppear:YES];
        [toViewController viewWillDisappear:YES];
    }
    
    CGPoint toPosition = CGPointZero;
    CGFloat toAlpha = 0;
    CGPoint containerPosition = CGPointZero;
    
    if(PanAnimationControllerTypePresentation == animationType) {
        if(PanDirectionRight == panDirection) {
            toPosition = CGPointMake(cancelled ? -SCREEN_CENTER_X : SCREEN_CENTER_X - presentationEndOffset, transitionView.center.y);
        } else if(PanDirectionLeft == panDirection) {
            toPosition = CGPointMake(cancelled ? SCREEN_CENTER_X * 3 : SCREEN_CENTER_X + presentationEndOffset, transitionView.center.y);
        }
        toAlpha = cancelled ? 0 : MASK_VIEW_FINAL_ALPHA;
    } else {
        if(PanDirectionRight == panDirection) {
            toPosition = CGPointMake(cancelled ? SCREEN_CENTER_X + dismissalStartOffset : SCREEN_CENTER_X * 3, transitionView.center.y);
        } else if(PanDirectionLeft == panDirection) {
            toPosition = CGPointMake(cancelled ? SCREEN_CENTER_X - dismissalStartOffset : -SCREEN_CENTER_X, transitionView.center.y);
        }
        toAlpha = cancelled ? MASK_VIEW_FINAL_ALPHA : 0;
        containerPosition = CGPointMake(cancelled ? 0 : SCREEN_CENTER_X, 0);
    }
    
    isAnimating = YES;
    
    [UIView animateWithDuration:0.2f
            animations:^{
                transitionView.center = toPosition;
                if(PanAnimationControllerTypeDismissal == self.animationType) {
                    UIView *_mask_view_ = [_containerView_ viewWithTag:MASK_VIEW_TAG];
                    if(_mask_view_) _mask_view_.alpha = toAlpha;
                } else {
                    maskView.alpha = toAlpha;
                }
                if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
                    toViewController.view.center = CGPointMake(containerPosition.x, toViewController.view.center.y);
                }
            }
            completion:^(BOOL finished){
                if(cancelled) {
                    [context cancelInteractiveTransition];
                    [context completeTransition:NO];
                    
                    [fromViewController viewDidAppear:YES];
                    [toViewController viewDidDisappear:YES];
                } else {
                    [context finishInteractiveTransition];
                    [context completeTransition:YES];
                    
                    [fromViewController viewDidDisappear:YES];
                    [toViewController viewDidAppear:YES];
                }
                
                panDirection = PanDirectionNone;
                self.isInteractive = NO;
                
                context = nil;
                transitionView = nil;
                _containerView_ = nil;
                
                self.ignoreOffset = NO;
                
                isAnimating = NO;
                dismissalStartOffset = 0;
                presentationEndOffset = 0;
            }];
}


#pragma mark -
#pragma mark Gestures

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if(isAnimating || self.containerController == nil) {
        // 正在进行结束动画, 此时不能开始新的手势
#ifdef DEBUG
        NSLog(@"Can not begin pan gesture, because the animating isn't end");
#endif
        return;
    }
    
    CGPoint translation = [gesture translationInView:_containerView_];
    
    if(UIGestureRecognizerStateBegan == gesture.state) {
        isGestureFailure = NO;
        panDirection = translation.x < 0 ? PanDirectionLeft : PanDirectionRight;
        if(PanDirectionRight == panDirection) {
            if(PanAnimationControllerTypeNone == self.rightPanAnimationType) {
#ifdef DEBUG
                NSLog(@"Right animation type is none");
#endif
                return;
            } else if(PanAnimationControllerTypePresentation == self.rightPanAnimationType) {
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(leftPresentationViewController)]) {
                    UIViewController *controller = [self.delegate leftPresentationViewController];
                    if(controller != nil) {
                        controller.modalPresentationStyle = UIModalPresentationCustom;
                        controller.transitioningDelegate = self.containerController;
                        self.isInteractive = YES;
                        [self.containerController presentViewController:controller animated:YES completion:nil];
                    } else {
                        isGestureFailure = YES;
                    }
                } else {
                    isGestureFailure = YES;
                }
            } else if(PanAnimationControllerTypeDismissal == self.rightPanAnimationType) {
                if(PanAnimationControllerDismissStyleTransition == self.dismissStyle) {
                    self.isInteractive = YES;
                    [self.containerController.navigationController popViewControllerAnimated:YES];
                } else {
                    // 在其父 parent controller presentation 自己结束后
                    // 需要将控制权交给自己了
                    if(self.containerController.navigationController == nil) {
                        self.containerController.transitioningDelegate = self.containerController;
                        self.isInteractive = YES;
                        [self.containerController dismissViewControllerAnimated:YES completion:^{ }];
                    } else {
                        self.containerController.navigationController.transitioningDelegate = self.containerController;
                        self.isInteractive = YES;
                        [self.containerController.navigationController dismissViewControllerAnimated:YES completion:^{ }];
                    }
                }
            }
        } else if(PanDirectionLeft == panDirection) {
            if(PanAnimationControllerTypeNone == self.leftPanAnimationType) {
#ifdef DEBUG
                NSLog(@"Left animation type is none");
#endif
                return;
            } else if(PanAnimationControllerTypePresentation == self.leftPanAnimationType) {
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(rightPresentationViewController)]) {
                    UIViewController *controller = [self.delegate rightPresentationViewController];
                    if(controller != nil) {
                        controller.modalPresentationStyle = UIModalPresentationCustom;
                        controller.transitioningDelegate = self.containerController;
                        self.isInteractive = YES;
                        [self.containerController presentViewController:controller animated:YES completion:nil];
                    } else {
                        isGestureFailure = YES;
                    }
                } else {
                    isGestureFailure = YES;
                }
            } else if(PanAnimationControllerTypeDismissal == self.leftPanAnimationType) {
                if(self.containerController.navigationController == nil) {
                    self.containerController.transitioningDelegate = self.containerController;
                    self.isInteractive = YES;
                    [self.containerController dismissViewControllerAnimated:YES completion:^{ }];
                } else {
                    self.containerController.navigationController.transitioningDelegate = self.containerController;
                    self.isInteractive = YES;
                    [self.containerController.navigationController dismissViewControllerAnimated:YES completion:^{ }];
                }
            }
        }
        return;
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state
            || UIGestureRecognizerStateBegan == gesture.state) {
        
        if(isGestureFailure) return;
        
        CGFloat percent = 0;
        if(PanAnimationControllerTypePresentation == self.animationType) {
            percent = abs(translation.x) / ([UIScreen mainScreen].bounds.size.width - presentationEndOffset);
        } else {
            percent = abs(translation.x) / ([UIScreen mainScreen].bounds.size.width - dismissalStartOffset);
        }
        
        if(PanDirectionRight == panDirection) {
            if(PanAnimationControllerTypePresentation == self.rightPanAnimationType) {
                if(translation.x < 0) {
                    [gesture setTranslation:CGPointMake(0, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:0 translationX:0];
                    return;
                } else if(translation.x > SCREEN_CENTER_X * 2 - presentationEndOffset) {
                    [gesture setTranslation:CGPointMake(SCREEN_CENTER_X * 2 - presentationEndOffset, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:1 translationX:SCREEN_CENTER_X * 2 - presentationEndOffset];
                    return;
                }
                [self updateInteractiveTransitionWithPercent:percent translationX:translation.x];
            } else if(PanAnimationControllerTypeDismissal == self.rightPanAnimationType) {
                if(translation.x < 0) {
                    [gesture setTranslation:CGPointMake(0, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:0 translationX:0];
                    return;
                }
                [self updateInteractiveTransitionWithPercent:percent translationX:translation.x];
            }
        } else if(PanDirectionLeft == panDirection) {
            if(PanAnimationControllerTypePresentation == self.leftPanAnimationType) {
                if(translation.x > 0) {
                    [gesture setTranslation:CGPointMake(0, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:0 translationX:0];
                    return;
                } else if(translation.x < -SCREEN_CENTER_X * 2 + presentationEndOffset) {
                    [gesture setTranslation:CGPointMake(-SCREEN_CENTER_X * 2 + presentationEndOffset, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:1 translationX:-SCREEN_CENTER_X * 2 + presentationEndOffset];
                    return;
                }
                [self updateInteractiveTransitionWithPercent:percent translationX:translation.x];
            } else if(PanAnimationControllerTypeDismissal == self.leftPanAnimationType) {
                if(translation.x > 0) {
                    [gesture setTranslation:CGPointMake(0, translation.y) inView:_containerView_];
                    [self updateInteractiveTransitionWithPercent:0 translationX:0];
                    return;
                }
                [self updateInteractiveTransitionWithPercent:percent translationX:translation.x];
            }
        }
    } else if(UIGestureRecognizerStateEnded == gesture.state
                || UIGestureRecognizerStateCancelled == gesture.state
                ) {
        
        if(isGestureFailure) {
            isGestureFailure = NO;
            return;
        }
        
        CGFloat percent = 0;
        if(PanAnimationControllerTypePresentation == self.animationType) {
            percent = abs(translation.x) / ([UIScreen mainScreen].bounds.size.width - presentationEndOffset);
        } else {
            percent = abs(translation.x) / ([UIScreen mainScreen].bounds.size.width - dismissalStartOffset);
        }
        
        BOOL cancelled = percent <= 0.4f;
        [self endInteractiveTransition:cancelled];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    if(isAnimating || self.containerController == nil || self.containerController.presentedViewController == nil) {
        // 正在进行结束动画, 此时不能开始新的手势
#ifdef DEBUG
        NSLog(@"Can not begin tap gesture, because the animating isn't end");
#endif
        return;
    }
    
    UIViewController *presentedViewController = self.containerController.presentedViewController;
    CGPoint center = presentedViewController.view.center;
    
    self.panDirection = center.x > 160 ? PanDirectionRight : PanDirectionLeft;
    [presentedViewController dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)addGestrue:(UIGestureRecognizer *)gesture forView:(UIView *)view {
    if(view == nil) return;
    NSArray *gestures = view.gestureRecognizers;
    BOOL gestureExists = NO;
    if(gestures != nil) {
        for(UIGestureRecognizer *_gesture_ in gestures) {
            if(_gesture_ == gesture) {
                gestureExists = YES;
                break;
            }
        }
    }
    if(!gestureExists) {
        [view addGestureRecognizer:gesture];
    }
}

@end
