//
//  ViewQRCodeViewController.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ViewQRCodeViewController.h"
//#import "QRCodeGenerator.h"
#import "ButtonUtil.h"
#import "PanAnimationController.h"

@implementation ViewQRCodeViewController {
    NSString *_order_id_;
    PanAnimationController *panAnimation;
}

- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super init];
    if(self) {
        _order_id_ = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"order_qr_code", @"");
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 60, 300, 300)];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageView];
    
    UIButton *btn = [ButtonUtil newTestButtonForTarget:self action:@selector(fj:)];
    [self.view addSubview:btn];
    
    panAnimation = [[PanAnimationController alloc] initWithContainerController:self];
    panAnimation.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    NSLog(@"end did load");
    
    /*
    if(_order_id_ == nil) return;

    UIImage *orderQrCodeImage = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"{\"codeType\":%d,\"codeContent\":{\"orderId\":\"%@\"}}", 1,  _order_id_] imageSize:600];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 300, 300)];
    imageView.center = CGPointMake(self.view.center.x, (self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) / 2);
    imageView.image = orderQrCodeImage;
    [self.view addSubview:imageView];
     */
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    panAnimation.animationType = PanAnimationControllerTypePresentation;
    return panAnimation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    panAnimation.animationType = PanAnimationControllerTypeDismissal;
    return panAnimation;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if([animator isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animation = (PanAnimationController *)animator;
        if(animation.isInteractive) return animation;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if([animator isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animation = (PanAnimationController *)animator;
        if(animation.isInteractive) return animation;
    }
    return nil;
}

- (void)fj:(id)sender {
    panAnimation.panDirection = PanDirectionRight;
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
