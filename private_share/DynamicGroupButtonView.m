//
//  DynamicGroupButtonView.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DynamicGroupButtonView.h"

CGFloat const kDynamicButtonHeight = 30.f;
CGFloat const kDynamicButtonMinWidth = 20.f;

@implementation DynamicGroupButtonView {
}

@synthesize identifier;

@synthesize tintColor;
@synthesize color = _color_;
@synthesize titleColor = _titleColor_;
@synthesize selectedItem = _selectedItem_;
@synthesize delegate;

+ (instancetype)dynamicGroupButtonViewWithPoint:(CGPoint)point nameValues:(NSArray *)nameValues {
    
    CGFloat buttonHSpacing = 10.f;
    CGFloat buttonVSpacing = 5.f;
    
    NSMutableArray *groupButtons = [NSMutableArray array];
    
    NSUInteger row = 1;
    CGRect lastButtonFrame = CGRectMake(0, 0, 0, kDynamicButtonHeight);
    for(int i=0; i<nameValues.count; i++) {
        NameValue *nameValue = [nameValues objectAtIndex:i];
        CGSize fontSize = [nameValue.name boundingRectWithSize:CGSizeMake(300 - kDynamicButtonMinWidth, kDynamicButtonHeight) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.f] } context:nil].size;
        
        DynamicButton *dynamicButton;
        if( (lastButtonFrame.origin.x + lastButtonFrame.size.width + buttonHSpacing + fontSize.width + kDynamicButtonMinWidth + buttonHSpacing)
                > [UIScreen mainScreen].bounds.size.width) {
            // 需要换行
            row++;
            dynamicButton = [[DynamicButton alloc] initWithFrame:
                             CGRectMake(buttonHSpacing, lastButtonFrame.origin.y + kDynamicButtonHeight + buttonVSpacing, fontSize.width + kDynamicButtonMinWidth, kDynamicButtonHeight) nameValue:nameValue];
        } else {
            dynamicButton = [[DynamicButton alloc] initWithFrame:
                    CGRectMake(lastButtonFrame.origin.x + lastButtonFrame.size.width + buttonHSpacing, lastButtonFrame.origin.y, fontSize.width + kDynamicButtonMinWidth, kDynamicButtonHeight) nameValue:nameValue];
        }
        [groupButtons addObject:dynamicButton];
        
        //
        lastButtonFrame = dynamicButton.frame;
    }
    
    DynamicGroupButtonView *groupButtonView = [[DynamicGroupButtonView alloc] initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, kDynamicButtonHeight * row + (row - 1) * buttonVSpacing)];
    groupButtonView.backgroundColor = [UIColor whiteColor];
    for(int i=0; i<groupButtons.count; i++) {
        DynamicButton *button = [groupButtons objectAtIndex:i];
        button.layer.borderColor = groupButtonView.color.CGColor;
        [button setTitleColor:groupButtonView.titleColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:groupButtonView action:@selector(dynamicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [groupButtonView addSubview:button];
    }
    
    return groupButtonView;
}

- (void)dynamicButtonPressed:(DynamicButton *)dynamicButton {
    self.selectedItem = dynamicButton.nameValue;
}

- (void)setSelectedItem:(NameValue *)selectedItem {
    if(_selectedItem_ != nil && selectedItem != nil) {
        if([_selectedItem_ isEqual:selectedItem]) {
            return;
        }
    }
    
    _selectedItem_ = nil;
    for(DynamicButton *db in self.subviews) {
        if([db.nameValue isEqual:selectedItem]) {
            [db setTitleColor:self.tintColor forState:UIControlStateNormal];
            db.layer.borderColor = self.tintColor.CGColor;
            _selectedItem_ = selectedItem;
        } else {
            [db setTitleColor:self.titleColor forState:UIControlStateNormal];
             db.layer.borderColor = self.color.CGColor;
        }
    }
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(dynamicGroupButtonView:selectedItemDidChangeTo:)]) {
            [self.delegate dynamicGroupButtonView:self selectedItemDidChangeTo:_selectedItem_];
        }
    }
}

- (UIColor *)color {
    if(_color_ == nil) {
        _color_ = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
    }
    return _color_;
}

- (UIColor *)titleColor {
    if(_titleColor_ == nil) {
        _titleColor_ = [UIColor grayColor];
    }
    return _titleColor_;
}

@end
