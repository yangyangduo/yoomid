//
//  YoomidRectModalView.h
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"
#import "YoomidSemicircleModalView.h"

@protocol YoomidRectModalViewDelegate <NSObject>

- (void)OKbtn;

@end

@interface YoomidRectModalView : YoomidBaseModalView

- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;
@property (nonatomic ,assign) id<ShareDeletage> shareDeletage;

@property (nonatomic ,assign) id<YoomidRectModalViewDelegate> yoomidDelegate;
@end
