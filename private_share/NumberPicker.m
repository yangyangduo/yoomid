//
//  NumberPicker.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NumberPicker.h"
#import "UIColor+App.h"

#define BUTTON_WIDTH  24
#define TEXT_WIDTH    34
#define HEIGHT        24

@implementation NumberPicker {
    UIButton *btnAddition;
    UIButton *btnReduction;
    UILabel *numberLabel;
    NumberPickerDirection _direction_;
    
    CGFloat _height_;
    CGFloat _buttonWidth_;
    CGFloat _textWidth_;
}

@synthesize identifier;
@synthesize maxValue;
@synthesize minValue;
@synthesize number = _number_;

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height buttonWidth:(CGFloat)buttonWidth textWidth:(CGFloat)textWidth direction:(NumberPickerDirection)direction {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _direction_ = direction;
        
        _height_ = height;
        _buttonWidth_ = buttonWidth;
        _textWidth_ = textWidth;
        
        // min && max value
        self.minValue = 1;
        self.maxValue = 99;
        
        // default value
        self.number = 1;
        
        [self initUI];
    }
    return self;
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point height:(CGFloat)height buttonWidth:(CGFloat)buttonWidth textWidth:(CGFloat)textWidth direction:(NumberPickerDirection)direction {
    if(NumberPickerDirectionVertical == direction) {
        return [[NumberPicker alloc] initWithFrame:CGRectMake(point.x, point.y, height, buttonWidth * 2 + textWidth) height:height buttonWidth:buttonWidth textWidth:textWidth direction:direction];
    } else {
        return [[NumberPicker alloc] initWithFrame:CGRectMake(point.x, point.y, buttonWidth * 2 + textWidth, height) height:height buttonWidth:buttonWidth textWidth:textWidth direction:direction];
    }
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point direction:(NumberPickerDirection)direction {
    return [[self class] numberPickerWithPoint:point height:HEIGHT buttonWidth:BUTTON_WIDTH textWidth:TEXT_WIDTH direction:direction];
}

- (void)initUI {
    if(_direction_ == NumberPickerDirectionVertical) {
        btnAddition = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _height_, _buttonWidth_)];
        btnReduction = [[UIButton alloc] initWithFrame:CGRectMake(0, _buttonWidth_ * 2 + _textWidth_, _height_, _buttonWidth_)];
    } else {
        btnReduction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _buttonWidth_, _height_)];
        btnAddition = [[UIButton alloc] initWithFrame:CGRectMake(_buttonWidth_ + _textWidth_, 0, _buttonWidth_, _height_)];
    }
    
    btnAddition.tag = 1;
    btnReduction.tag = 2;
    
    [btnAddition addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnReduction addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAddition addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnAddition addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [btnReduction addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnReduction addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    btnReduction.layer.borderColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f].CGColor;
    btnAddition.layer.borderColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f].CGColor;
    
    btnAddition.layer.borderWidth = 1;
    btnReduction.layer.borderWidth = 1;
    
    btnAddition.backgroundColor = [UIColor clearColor];
    btnReduction.backgroundColor = [UIColor clearColor];
    
    [btnReduction setTitleColor:[UIColor appTextFieldGray] forState:UIControlStateNormal];
    [btnAddition setTitleColor:[UIColor appTextFieldGray] forState:UIControlStateNormal];
    
    btnAddition.titleLabel.font = [UIFont systemFontOfSize:16.f];
    btnReduction.titleLabel.font = [UIFont systemFontOfSize:16.f];
    
    [btnAddition setTitle:@"+" forState:UIControlStateNormal];
    [btnReduction setTitle:@"-" forState:UIControlStateNormal];
    
    btnAddition.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0.5f, 0);
    btnReduction.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    
    if(_direction_ == NumberPickerDirectionVertical) {
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _buttonWidth_, _height_, _textWidth_)];
    } else {
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_buttonWidth_, 0, _textWidth_, _height_)];
    }
    numberLabel.textColor = [UIColor appLightBlue];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:18.f];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
    
    [self addSubview:numberLabel];
    [self addSubview:btnAddition];
    [self addSubview:btnReduction];
}

- (UILabel *)numberLabel {
    return numberLabel;
}

- (void)btnPressed:(UIButton *)sender {
    NSInteger newNumber = 0;
    if(sender.tag == 1) {
        if(self.number + 1 <= self.maxValue) {
            newNumber = self.number + 1;
        }
    } else if(sender.tag == 2) {
        if(self.number - 1 >= self.minValue) {
            newNumber = self.number - 1;
        }
    }
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(numberPickerDelegate:valueWillChangeTo:)]) {
            if([self.delegate numberPickerDelegate:self valueWillChangeTo:newNumber]) {
                self.number = newNumber;
            }
        } else {
            self.number = newNumber;
        }
    } else {
        self.number = newNumber;
    }
    sender.backgroundColor = [UIColor clearColor];
}

- (void)btnTouchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor appSilver];
}

- (void)btnTouchUpOutside:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

- (void)setNumber:(NSInteger)number {
    if(number < self.minValue || number > self.maxValue) return;
    if(number == _number_) return;
    _number_ = number;
    numberLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(numberPickerDelegate:valueDidChangedTo:)]) {
        [self.delegate numberPickerDelegate:self valueDidChangedTo:_number_];
    }
}

@end
