//
//  ShareTaskModalView.h
//  private_share
//
//  Created by 曹大为 on 14/9/25.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"
#import "YoomidSemicircleModalView.h"

@interface ShareTaskModalView : YoomidBaseModalView
- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message;
@property (nonatomic ,assign) id<ShareDeletage> shareDeletage;
@end
