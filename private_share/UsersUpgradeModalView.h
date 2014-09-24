//
//  UsersUpgradeModalView.h
//  private_share
//
//  Created by 曹大为 on 14-9-17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "YoomidSemicircleModalView.h"
#import "UpgradeTask.h"
#import "ViewControllerAccessor.h"

@interface UsersUpgradeModalView : YoomidSemicircleModalView

- (instancetype) initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message upgradeTask:(UpgradeTask *)upgradeTasks;

- (instancetype)initWithSize1:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSMutableAttributedString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;

@end
