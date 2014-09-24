//
//  YoomidSemicircleModalView.h
//  private_share
//
//  Created by Zhao yang on 9/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeNone           =   0,
    ShareTypeSetting        =   1,
    ShareTypeUser           =   2
};

@interface YoomidSemicircleModalView : ModalView

- (instancetype)initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;

@property (nonatomic ,strong) BaseViewController *topViewController;
@property (nonatomic ,assign) ShareType shareType;

@end
