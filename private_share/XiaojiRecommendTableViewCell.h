//
//  XiaojiRecommendTableViewCell.h
//  private_share
//
//  Created by 曹大为 on 14-8-26.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+ScreenSize.h"
#import "Merchandise.h"

@protocol XiaojiRecommendTableViewCellDelegate <NSObject>

- (void)actionClickGood:(NSString *)ids;

@end

@interface XiaojiRecommendTableViewCell : UITableViewCell

@property (nonatomic ,assign) id<XiaojiRecommendTableViewCellDelegate> delegate;
@property (nonatomic, strong) Merchandise *merchandise;
@property (nonatomic, strong) UILabel *zanLabel;
@end
