//
//  ModalView.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"

@implementation ModalView {
    UIView *maskView;
    UITapGestureRecognizer *tapGesture;
}

@synthesize modalViewState;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if(self) {
        modalViewState = ModalViewStateClosed;
        self.backgroundColor = [UIColor whiteColor];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if(self) {
        modalViewState = ModalViewStateClosed;
        self.backgroundColor = [UIColor whiteColor];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    if(ModalViewStateClosed != self.modalViewState) return;
    modalViewState = ModalViewStateOpening;
    
    if(maskView == nil) {
        maskView = [[UIView alloc] initWithFrame:view.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        [maskView addGestureRecognizer:tapGesture];
    }
    
    maskView.alpha = 0.f;
    
    [view addSubview:maskView];
    [view addSubview:self];
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = view.bounds.size.height;
    self.frame = selfFrame;
    self.center = CGPointMake(view.center.x, self.center.y);
    
    /*
     *  damping  类似于摩擦系数 越大摩擦越大 减震效果越好
     *  velocity 代表速度
     */
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:2.f options:0
                     animations:^ {
                         self.center = CGPointMake(view.center.x, view.center.y);
                         maskView.alpha = 0.5f;
                     }
                     completion:^(BOOL finished){
                         modalViewState = ModalViewStateOpened;
                     }
     ];
}

- (void)closeView {
    if(ModalViewStateOpened != self.modalViewState) return;
    modalViewState = ModalViewStateClosing;
    
    if(self.superview == nil) {
        [maskView removeFromSuperview];
        return;
    }
    
    CGRect endFrame = self.frame;
    endFrame.origin.y = self.superview.bounds.size.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         maskView.alpha = 0;
                         self.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         [maskView removeFromSuperview];
                         [self removeFromSuperview];
                         modalViewState = ModalViewStateClosed;
                     }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self closeView];
}

@end
