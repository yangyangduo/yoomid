//
//  NumberPicker.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NumberPickerDirection) {
    NumberPickerDirectionVertical,
    NumberPickerDirectionHorizontal,
};

@protocol NumberPickerDelegate;

@interface NumberPicker : UIView

@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, weak) id<NumberPickerDelegate> delegate;

+ (instancetype)numberPickerWithPoint:(CGPoint)point direction:(NumberPickerDirection)direction;
+ (instancetype)numberPickerWithPoint:(CGPoint)point height:(CGFloat)height buttonWidth:(CGFloat)buttonWidth textWidth:(CGFloat)textWidth direction:(NumberPickerDirection)direction;

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height buttonWidth:(CGFloat)buttonWidth textWidth:(CGFloat)textWidth direction:(NumberPickerDirection)direction;

- (UILabel *)numberLabel;

@end

@protocol NumberPickerDelegate <NSObject>

@optional

- (BOOL)numberPickerDelegate:(NumberPicker *)numberPicker valueWillChangeTo:(NSInteger)number;
- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(NSInteger)number;

@end
