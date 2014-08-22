//
//  PopupView.h
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , PopupViewState) {
    PopupViewStateClosed,
    PopupViewStateClosing,
    PopupViewStateOpening,
    PopupViewStateOpened,
};

@interface PopupView : UIView

@property (nonatomic) PopupViewState state;
@property (nonatomic) NSTimeInterval animationDuration;

- (void)showInView:(UIView *)view; // completion:(void (^)(void))completion;
- (void)closeView;

@end
