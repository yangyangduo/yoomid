//
//  XXDrawerViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 zhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DrawerViewControllerConfig.h"

@protocol DrawerViewControllerDelegate;

@interface DrawerViewController : UIViewController<UIScrollViewDelegate>

@property (assign, nonatomic) BOOL rightViewEnable;
@property (assign, nonatomic) BOOL leftViewEnable;
@property (assign, nonatomic) BOOL panFromScrollViewFirstPage;
@property (assign, nonatomic) BOOL panFromScrollViewLastPage;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, strong) UIViewController *centerViewController;

@property (nonatomic, weak) id<DrawerViewControllerDelegate> delegate;

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController centerViewController:(UIViewController *)centerViewController;

+ (DrawerViewControllerConfig *)defaultConfig;

- (void)showRightView;
- (void)showCenterView:(BOOL)animate;
- (void)showLeftView;

- (void)disableGestureForDrawerView;
- (void)enableGestureForDrawerView;

- (UIPanGestureRecognizer *)getPanGesture;

@end

@protocol DrawerViewControllerDelegate <NSObject>



@end
