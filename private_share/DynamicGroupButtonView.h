//
//  DynamicGroupButtonView.h
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicButton.h"

extern CGFloat const kDynamicButtonHeight;
extern CGFloat const kDynamicButtonMinWidth;

@protocol DynamicGroupButtonViewDelegate;

@interface DynamicGroupButtonView : UIView

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NameValue *selectedItem;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, weak) id<DynamicGroupButtonViewDelegate> delegate;

+ (instancetype)dynamicGroupButtonViewWithPoint:(CGPoint)point nameValues:(NSArray *)nameValues;

@end

@protocol DynamicGroupButtonViewDelegate <NSObject>

- (void)dynamicGroupButtonView:(DynamicGroupButtonView *)dynamicGroupButtonView selectedItemDidChangeTo:(NameValue *)nameValue;

@end
