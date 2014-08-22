//
//  ProgressView.h
//  private_share
//
//  Created by Zhao yang on 7/7/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *backgroundView;

- (void)setProgress:(float)progress;

@end
