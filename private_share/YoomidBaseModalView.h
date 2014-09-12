//
//  YoomidBaseModalView.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"

@interface YoomidBaseModalView : ModalView

@property (nonatomic, strong , readonly) UIView *contentView;

- (void)setCloseButtonHidden:(BOOL)hidden;

@end
