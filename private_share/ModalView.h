//
//  ModalView.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ModalViewState) {
    ModalViewStateClosed,
    ModalViewStateClosing,
    ModalViewStateOpening,
    ModalViewStateOpened,
};

@interface ModalView : UIView

@property (nonatomic, assign, readonly) ModalViewState modalViewState;

- (instancetype)initWithSize:(CGSize)size;

- (void)showInView:(UIView *)view completion:(void (^)(void))completion;
- (void)closeViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
