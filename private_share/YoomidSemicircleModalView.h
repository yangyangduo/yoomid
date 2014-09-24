//
//  YoomidSemicircleModalView.h
//  private_share
//
//  Created by Zhao yang on 9/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeNone           =   0,
    ShareTypeSetting        =   1,
    ShareTypeUser           =   2
};

@protocol ShareDeletage <NSObject>

- (void)showShare;

@end

@interface YoomidSemicircleModalView : ModalView

- (instancetype)initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;

@property (nonatomic ,assign) ShareType shareType;
@property (nonatomic ,assign) id<ShareDeletage>deletage;

@end
