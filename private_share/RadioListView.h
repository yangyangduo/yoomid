//
//  RadioListView.h
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioListView : UIView

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex;

@end
