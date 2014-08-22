//
//  XXDrawerViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 zhaoyang. All rights reserved.
//

#import "DrawerViewController.h"

#define STATUS_BAR_HEIGHT        20.f
#define SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width

#define BLACK_BOARD_VIEW_TAG        2900
#define BLACK_BOARD_VIEW_ALPHA      0.6f
#define BLACK_BOARD_VIEW_SCALE      0.95f

typedef NS_ENUM(NSInteger, Direction) {
    DirectionNone   =   0,
    DirectionLeft   =   1,
    DirectionRight  =   2,
};

@interface DrawerViewController ()

@end

@implementation DrawerViewController {
    
    /* ---------- Black Board Views ---------- */
    
    UIView *lockView;
    UIView *centerBlackBoardView;
    UIView *leftBlackBoardView;
    UIView *rightBlackBoardView;
    

    /* ---------- Coordinates ---------- */
    
    CGFloat screenCenterY;
    CGFloat screenCenterX;
    CGFloat lastedMainViewCenterX;

    /* ---------- Gestures ---------- */
    
    UIPanGestureRecognizer *panGesture;
    UIPanGestureRecognizer *panOnCenterViewLoseFocus;
    UITapGestureRecognizer *tapOnCenterViewLoseFocus;
    

    /* ---------- Flags ---------- */
    
    BOOL leftTransitionHasReset;
    BOOL rightTransitionHasReset;
    BOOL leftViewIsAboveOnRightView;

    
    /* ---------- Core Views ---------- */
    
    UIView *leftView;
    UIView *rightView;
    UIView *contentViewContainer;
    
    
    /* ---------- Others ---------- */
    
    Direction tendencyDirection;
}

@synthesize delegate;

@synthesize panFromScrollViewFirstPage;
@synthesize panFromScrollViewLastPage;

@synthesize scrollView;
@synthesize leftViewController = _leftViewController_;
@synthesize rightViewController = _rightViewController_;
@synthesize centerViewController = _centerViewController_;

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController centerViewController:(UIViewController *)centerViewController {
    self = [super init];
    if(self) {
        [self initWithCenterViewController:centerViewController leftViewController:leftViewController rightViewController:rightViewController];
    }
    return self;
}

- (void)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initDefaults];
    [self initBlackBoardViews];
    
    [self.view addSubview:centerBlackBoardView];
    self.rightViewController = rightViewController;
    self.leftViewController = leftViewController;
    
    contentViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    contentViewContainer.backgroundColor = [UIColor whiteColor];
    [contentViewContainer addGestureRecognizer:panGesture];
    [self.view addSubview:contentViewContainer];
    
    self.centerViewController = centerViewController;
}

- (void)initDefaults {
    screenCenterX = SCREEN_WIDTH / 2;
    if([self systemVersionIsMoreThanOrEqual7]) {
        screenCenterY = ([UIScreen mainScreen].bounds.size.height) / 2;
    } else {
        screenCenterY = ([UIScreen mainScreen].bounds.size.height - STATUS_BAR_HEIGHT) / 2;
    }
    
    tendencyDirection = DirectionNone;
    lastedMainViewCenterX = SCREEN_WIDTH / 2;
    leftViewIsAboveOnRightView = YES;
    self.leftViewEnable = YES;
    self.rightViewEnable = YES;
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateNormal:)];
    panGesture.delaysTouchesBegan = NO;
    
    tapOnCenterViewLoseFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForMainViewStateHide:)];
    panOnCenterViewLoseFocus = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateHide:)];
}

- (void)initBlackBoardViews {
    lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenCenterY * 2)];
    lockView.backgroundColor = [UIColor clearColor];
    [lockView addGestureRecognizer:tapOnCenterViewLoseFocus];
    [lockView addGestureRecognizer:panOnCenterViewLoseFocus];
    
    centerBlackBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenCenterY * 2)];
    centerBlackBoardView.backgroundColor = [UIColor blackColor];
    
    leftBlackBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenCenterY * 2)];
    leftBlackBoardView.backgroundColor = [UIColor blackColor];
    leftBlackBoardView.tag = BLACK_BOARD_VIEW_TAG;
    leftBlackBoardView.alpha = 0.4;
    
    rightBlackBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenCenterY * 2)];
    rightBlackBoardView.backgroundColor = [UIColor blackColor];
    rightBlackBoardView.tag = BLACK_BOARD_VIEW_TAG;
    rightBlackBoardView.alpha = 0.4;
}

#pragma mark -
#pragma mark Gesture

- (UIPanGestureRecognizer *)getPanGesture {
    return panGesture;
}

- (void)handlePanGestureForMainViewStateNormal:(UIPanGestureRecognizer *)gesture {
    if(gesture !=  panGesture) return;
    CGPoint translation = [gesture translationInView:contentViewContainer];

    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = contentViewContainer.center.x;
        tendencyDirection = DirectionNone;
    }

    //dragging center view
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        if(self.panFromScrollViewFirstPage) {
            if(translation.x > 0 && self.scrollView != nil) {
                if(DirectionNone == tendencyDirection) {
                    tendencyDirection = DirectionRight;
                }
                if(DirectionLeft == tendencyDirection) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if(self.scrollView.scrollEnabled) {
                if(DirectionNone == tendencyDirection) {
                    tendencyDirection = DirectionLeft;
                }
                if(DirectionLeft == tendencyDirection) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        } else if(self.panFromScrollViewLastPage) {
            if(translation.x < 0 && self.scrollView != nil) {
                if(DirectionNone == tendencyDirection) {
                    tendencyDirection = DirectionLeft;
                }
                if(DirectionRight == tendencyDirection) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if (self.scrollView.scrollEnabled){
                if(DirectionNone == tendencyDirection) {
                    tendencyDirection = DirectionRight;
                }

                if(DirectionRight == tendencyDirection) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        }

        if(translation.x > 0) {
            if(leftView == nil || !self.leftViewEnable) {
                [self showCenterView:NO];
                [gesture setTranslation:CGPointMake(0, 0) inView:contentViewContainer];
                return;
            }
            if(!leftViewIsAboveOnRightView && rightView != nil) [self leftViewToTopLevel];
        } else if(translation.x < 0) {
            if(rightView == nil || !self.rightViewEnable) {
                [self showCenterView:NO];
                [gesture setTranslation:CGPointMake(0, 0) inView:contentViewContainer];
                return;
            }
            if(leftViewIsAboveOnRightView && leftView != nil) [self rightViewToTopLevel];
        }

        CGFloat maxTransX = lastedMainViewCenterX + translation.x;
        
        if(maxTransX > screenCenterX + [[self class] defaultConfig].leftDrawerViewVisibleWidth) {
            maxTransX = screenCenterX + [[self class] defaultConfig].leftDrawerViewVisibleWidth;
            [gesture setTranslation:CGPointMake([[self class] defaultConfig].leftDrawerViewVisibleWidth, 0) inView:contentViewContainer];
        } else if(maxTransX < screenCenterX - [[self class] defaultConfig].rightDrawerViewVisibleWidth) {
            maxTransX = screenCenterX - [[self class] defaultConfig].rightDrawerViewVisibleWidth;
            [gesture setTranslation:CGPointMake(0 - [[self class] defaultConfig].rightDrawerViewVisibleWidth, 0) inView:contentViewContainer];
        }

        CGPoint center = contentViewContainer.center;
        [self moveMainViewToCenter:CGPointMake(maxTransX, center.y)];
    } else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat mainViewX = contentViewContainer.frame.origin.x;
        //left view
        if(translation.x > 0) {
            //show
            if(mainViewX >= [[self class] defaultConfig].triggerShowDrawerViewMinWidth) {
                [self showLeftView];
            }
            //hide
            else {
                [self showCenterView:YES];
            }
        }
        //right view
        else if(translation.x < 0) {
            if(mainViewX < (0 - [[self class] defaultConfig].triggerShowDrawerViewMinWidth)) {
                [self showRightView];
            } else {
                [self showCenterView:YES];
            }
        }
        lastedMainViewCenterX = contentViewContainer.center.x;
    }
}

- (void)handleTapGestureForMainViewStateHide:(UITapGestureRecognizer *)gesture {
    [self showCenterView:YES];
}

- (void)handlePanGestureForMainViewStateHide:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:lockView];
    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = contentViewContainer.center.x;
    }
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat mainViewX = contentViewContainer.frame.origin.x;
        if(mainViewX > 0 && (lastedMainViewCenterX + translation.x) <= screenCenterX) {
            [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
            [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            leftTransitionHasReset = YES;
            return;
        } else if(mainViewX < 0 && (lastedMainViewCenterX + translation.x) >= screenCenterX) {
            [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
            [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            rightTransitionHasReset = YES;
            return;
        } else if(mainViewX == 0) {
            //main view is in center, but gesture are not canncelled now
            CGFloat lastedMainViewX = lastedMainViewCenterX - screenCenterX;
            if(lastedMainViewX > 0) {
                // hide left view
                // if direction is to left return
                if(translation.x <= 0) {
                    //lastedMainViewCenterX = self.mainView.center.x;
                    [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
                    return;
                }
                lastedMainViewCenterX = contentViewContainer.center.x + translation.x;
            } else if(lastedMainViewX < 0) {
                // hide right view
                // if direction is to right return
                if(translation.x >= 0) {
                    [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
                    return;
                }
                lastedMainViewCenterX = contentViewContainer.center.x + translation.x;
            }
        }

        CGFloat maxTransX = lastedMainViewCenterX + translation.x;

        if(maxTransX > screenCenterX + [[self class] defaultConfig].leftDrawerViewVisibleWidth) {
            maxTransX = screenCenterX + [[self class] defaultConfig].leftDrawerViewVisibleWidth;
            if(leftTransitionHasReset) {
                [gesture setTranslation:CGPointMake([[self class] defaultConfig].leftDrawerViewVisibleWidth, 0) inView:lockView];
            } else {
                [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            }
        } else if(maxTransX < screenCenterX - [[self class] defaultConfig].rightDrawerViewVisibleWidth) {
            maxTransX = screenCenterX - [[self class] defaultConfig].rightDrawerViewVisibleWidth;
            if(rightTransitionHasReset) {
                [gesture setTranslation:CGPointMake(0 - [[self class] defaultConfig].rightDrawerViewVisibleWidth, 0) inView:lockView];
            } else {
                [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            }
        }

        [self moveMainViewToCenter:CGPointMake(maxTransX, contentViewContainer.center.y)];

    } else if(gesture.state == UIGestureRecognizerStateEnded) {
        leftTransitionHasReset = NO;
        rightTransitionHasReset = NO;
        CGFloat mainViewX = contentViewContainer.frame.origin.x;
        if(mainViewX > 0) {
            if(mainViewX <= [[self class] defaultConfig].triggerHideLeftDrawerViewX) {
                [self showCenterView:YES];
            } else {
                [self showLeftView];
            }
        } else if(mainViewX < 0){
            if((mainViewX + SCREEN_WIDTH) >= [[self class] defaultConfig].triggerHideRightDrawerViewX) {
                [self showCenterView:YES];
            } else {
                [self showRightView];
            }
        } else {
            [self showCenterView:YES];
        }
    }
}

- (void)afterShowMainView {
    if(self.scrollView != nil) self.scrollView.scrollEnabled = YES;
    self.panFromScrollViewFirstPage = NO;
    self.panFromScrollViewLastPage = NO;
    if(lockView.superview != nil) {
        [lockView removeFromSuperview];
    }
    contentViewContainer.backgroundColor = [UIColor whiteColor];
}

- (void)leftViewToTopLevel {
    if(!leftViewIsAboveOnRightView) {
        if(rightView == nil) {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        } else {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
        }
        leftViewIsAboveOnRightView = YES;
    }
}

- (void)rightViewToTopLevel {
    if(leftViewIsAboveOnRightView) {
        if(leftView == nil) {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        } else {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
        }
        leftViewIsAboveOnRightView = NO;
    }
}

- (void)moveMainViewToCenter:(CGPoint)center {
    CGFloat preX = contentViewContainer.center.x - screenCenterX;
    CGFloat intentionX = center.x - contentViewContainer.center.x;
    CGFloat toX = center.x - screenCenterX;
    if(intentionX == 0) return;
    if(toX < 0) {
        [self addBlackMaskViewForDrawerViewIfNeed];
        [self rightViewMoving:toX];
    } else if(toX > 0) {
        [self addBlackMaskViewForDrawerViewIfNeed];
        [self leftViewMoving:toX];
    } else {
        if(preX == 0) return;
        [self addBlackMaskViewForDrawerViewIfNeed];
        if(preX > 0) {
            [self leftViewMoving:toX];
        } else {
            [self rightViewMoving:toX];
        }
    }
    contentViewContainer.center = center;
}

- (void)leftViewMoving:(CGFloat)x {
    UIView *view = [leftView viewWithTag:BLACK_BOARD_VIEW_TAG];
    if(view != nil) {
        if(x >= [[self class] defaultConfig].leftDrawerViewVisibleWidth) {
            view.alpha = 0;
            leftView.transform = CGAffineTransformMakeScale(1, 1);
        } else if(x <= 0) {
            view.alpha = BLACK_BOARD_VIEW_ALPHA;
            leftView.transform = CGAffineTransformMakeScale(BLACK_BOARD_VIEW_SCALE, BLACK_BOARD_VIEW_SCALE);
        } else {
            view.alpha = BLACK_BOARD_VIEW_ALPHA - ((x * BLACK_BOARD_VIEW_ALPHA) / [[self class] defaultConfig].leftDrawerViewVisibleWidth);
            CGFloat scale = ((1 - BLACK_BOARD_VIEW_SCALE) * x) / [[self class] defaultConfig].leftDrawerViewVisibleWidth + BLACK_BOARD_VIEW_SCALE;
            leftView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)rightViewMoving:(CGFloat)x {
    UIView *view = [rightView viewWithTag:BLACK_BOARD_VIEW_TAG];
    if(view != nil) {
        if((0-x) >= [[self class] defaultConfig].rightDrawerViewVisibleWidth) {
            view.alpha = 0;
            rightView.transform = CGAffineTransformMakeScale(1, 1);
        } else if(x >= 0) {
            view.alpha = BLACK_BOARD_VIEW_ALPHA;
            rightView.transform = CGAffineTransformMakeScale(BLACK_BOARD_VIEW_SCALE, BLACK_BOARD_VIEW_SCALE);
        } else {
            view.alpha = BLACK_BOARD_VIEW_ALPHA - (((0 - x) * BLACK_BOARD_VIEW_ALPHA) / [[self class] defaultConfig].rightDrawerViewVisibleWidth);
            CGFloat scale = ((1 - BLACK_BOARD_VIEW_SCALE) * (0 - x)) / [[self class] defaultConfig].rightDrawerViewVisibleWidth + BLACK_BOARD_VIEW_SCALE;
            rightView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)addBlackMaskViewForDrawerViewIfNeed {
    if(rightView != nil) {
        UIView *view = [rightView viewWithTag:BLACK_BOARD_VIEW_TAG];
        if(view == nil) {
            [rightView addSubview:rightBlackBoardView];
        }
    }
    if(leftView != nil) {
        UIView *view = [leftView viewWithTag:BLACK_BOARD_VIEW_TAG];
        if(view == nil) {
            [leftView addSubview:leftBlackBoardView];
        }
    }
}

- (BOOL)systemVersionIsMoreThanOrEqual7 {
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0f;
}

#pragma mark -
#pragma Public Methods

- (void)showLeftView {
    if(leftView == nil) return;
    contentViewContainer.backgroundColor = [UIColor clearColor];
    if(!leftViewIsAboveOnRightView && leftView && rightView) [self leftViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        [self moveMainViewToCenter:CGPointMake(screenCenterX + [[self class] defaultConfig].leftDrawerViewVisibleWidth, screenCenterY)];
    } completion:^(BOOL finished) {
        [contentViewContainer addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        contentViewContainer.backgroundColor = [UIColor whiteColor];
        UIView *blackMaskView = [leftView viewWithTag:BLACK_BOARD_VIEW_TAG];
        if(blackMaskView) {
            [blackMaskView removeFromSuperview];
        }
    }];
}

- (void)showCenterView:(BOOL)animate {
    if(!(self.panFromScrollViewFirstPage && DirectionLeft == tendencyDirection)
       && !(self.panFromScrollViewLastPage && DirectionRight == tendencyDirection)) {
        contentViewContainer.backgroundColor = [UIColor clearColor];
    }
    if(animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
        } completion:^(BOOL finished) {
            [self afterShowMainView];
        }];
    } else {
        [self moveMainViewToCenter:CGPointMake(screenCenterX, screenCenterY)];
        [self afterShowMainView];
    }
}

- (void)showRightView {
    if(rightView == nil) return;
    if(contentViewContainer != nil) {
        contentViewContainer.backgroundColor = [UIColor clearColor];
    }
    if(leftViewIsAboveOnRightView && leftView && rightView) [self rightViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        [self moveMainViewToCenter:CGPointMake(screenCenterX - [[self class] defaultConfig].rightDrawerViewVisibleWidth, screenCenterY)];
    } completion:^(BOOL finished) {
        [contentViewContainer addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        contentViewContainer.backgroundColor = [UIColor whiteColor];
        
        UIView *blackMaskView = [rightView viewWithTag:BLACK_BOARD_VIEW_TAG];
        if(blackMaskView) {
            [blackMaskView removeFromSuperview];
        }
    }];
}

- (void)disableGestureForDrawerView {
    panGesture.enabled = NO;
}

- (void)enableGestureForDrawerView {
    panGesture.enabled = YES;
}

+ (DrawerViewControllerConfig *)defaultConfig {
    return [DrawerViewControllerConfig defaultConfig];
}

- (void)setCenterViewController:(UIViewController *)centerViewController {
    if(centerViewController != nil) {
        CGRect frame = centerViewController.view.frame;
        centerViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addChildViewController:centerViewController];
        [contentViewContainer addSubview:centerViewController.view];
        [centerViewController didMoveToParentViewController:self];
    }
    
    if(self.centerViewController != nil) {
        [self.centerViewController willMoveToParentViewController:nil];
        [self.centerViewController.view removeFromSuperview];
        [self.centerViewController removeFromParentViewController];
    }
    
    _centerViewController_ = centerViewController;
    [self showCenterView:YES];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if(leftViewController == nil) {
        if(leftView != nil) {
            [leftView removeFromSuperview];
            leftView = nil;
            if(rightView != nil && leftViewIsAboveOnRightView) {
                [self rightViewToTopLevel];
            }
        }
    } else {
        if(leftView == nil) {
            leftView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            if(rightView != nil) {
                if(leftViewIsAboveOnRightView) {
                    [self.view insertSubview:leftView aboveSubview:centerBlackBoardView];
                } else {
                    [self.view insertSubview:leftView belowSubview:centerBlackBoardView];
                }
            } else {
                [self.view insertSubview:leftView aboveSubview:centerBlackBoardView];
                leftViewIsAboveOnRightView = YES;
            }
        }
    }
    
    if(leftViewController != nil) {
        CGRect frame = leftViewController.view.frame;
        leftViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addChildViewController:leftViewController];
        [leftView addSubview:leftViewController.view];
        [leftViewController.view addSubview:leftBlackBoardView];
        [leftViewController didMoveToParentViewController:self];
    }
    
    if(self.leftViewController != nil) {
        [self.leftViewController willMoveToParentViewController:nil];
        [self.leftViewController.view removeFromSuperview];
        [self.leftViewController removeFromParentViewController];
    }
    
    _leftViewController_ = leftViewController;
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if(rightViewController == nil) {
        if(rightView != nil) {
            [rightView removeFromSuperview];
            rightView = nil;
            if(leftView != nil && !leftViewIsAboveOnRightView) {
                [self leftViewToTopLevel];
            }
        }
    } else {
        if(rightView == nil) {
            rightView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            if(leftView != nil) {
                if(leftViewIsAboveOnRightView) {
                    [self.view insertSubview:rightView belowSubview:centerBlackBoardView];
                } else {
                    [self.view insertSubview:rightView aboveSubview:centerBlackBoardView];
                }
            } else {
                [self.view insertSubview:rightView aboveSubview:centerBlackBoardView];
                leftViewIsAboveOnRightView = NO;
            }
        }
    }
    
    if(rightViewController != nil) {
        CGRect frame = rightViewController.view.frame;
        rightViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addChildViewController:rightViewController];
        [rightView addSubview:rightViewController.view];
        [rightViewController.view addSubview:rightBlackBoardView];
        [rightViewController didMoveToParentViewController:self];
    }
    
    if(self.rightViewController != nil) {
        [self.rightViewController willMoveToParentViewController:nil];
        [self.rightViewController.view removeFromSuperview];
        [self.rightViewController removeFromParentViewController];
    }
    
    _rightViewController_ = rightViewController;
}

@end
