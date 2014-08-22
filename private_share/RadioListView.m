//
//  RadioListView.m
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "RadioListView.h"

#define ITEM_SIZE 18

@interface CustomTapGesture : UITapGestureRecognizer

@property (nonatomic, strong) NSString *identifier;

@end

@implementation CustomTapGesture

@synthesize identifier;

@end

@implementation RadioListView {
    NSMutableArray *imageViews;
}

@synthesize selectedIndex = _selectedIndex_;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex_ = selectedIndex;
        imageViews = [NSMutableArray array];
        for(int i=0; i<titles.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_SIZE + 1, i * (24 + 7), 124, 24)];
            titleLabel.text = [titles objectAtIndex:i];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:12.f];
            titleLabel.textColor = [UIColor redColor];
            [self addSubview:titleLabel];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + (24 - ITEM_SIZE) / 2, ITEM_SIZE, ITEM_SIZE)];
            imageView.image = [UIImage imageNamed: i == selectedIndex ? @"radio_selected" : @"radio"];
            [self addSubview:imageView];
            
            titleLabel.userInteractionEnabled = YES;
            imageView.userInteractionEnabled = YES;
            
            CustomTapGesture *tapGesture1 = [[CustomTapGesture alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            tapGesture1.identifier = [NSString stringWithFormat:@"%d", i];
            CustomTapGesture *tapGesture2 = [[CustomTapGesture alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            tapGesture1.identifier = [NSString stringWithFormat:@"%d", i];
            
            [titleLabel addGestureRecognizer:tapGesture1];
            [imageView addGestureRecognizer:tapGesture2];
            
            [imageViews addObject:imageView];
        }
    }
    return self;
}

- (void)handleTapGesture:(CustomTapGesture *)tapGesture {
    _selectedIndex_ = tapGesture.identifier.integerValue;
    if(imageViews != nil) {
        for(int i=0; i<imageViews.count; i++) {
            UIImageView *imageView = [imageViews objectAtIndex:i];
            imageView.image = [UIImage imageNamed: i == self.selectedIndex ? @"radio_selected" : @"radio"];
        }
    }
}

@end
