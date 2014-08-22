//
//  CheckBox.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxDelegate;

@interface CheckBox : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) id<CheckBoxDelegate> delegate;
@property (nonatomic, strong) NSString *title;

+ (instancetype)checkBoxWithPoint:(CGPoint)point;

@end

@protocol CheckBoxDelegate <NSObject>

- (void)checkBoxValueDidChanged:(CheckBox *)checkBox;

@end
