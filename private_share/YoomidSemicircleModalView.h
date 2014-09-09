//
//  YoomidSemicircleModalView.h
//  private_share
//
//  Created by Zhao yang on 9/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"

@interface YoomidSemicircleModalView : ModalView

- (instancetype)initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;

@end
