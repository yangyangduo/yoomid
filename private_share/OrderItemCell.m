//
//  OrderItemCell.m
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "OrderItemCell.h"

@implementation OrderItemCell {
    UILabel *titleLabel;
    UILabel *payLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:titleLabel];
        
        payLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, frame.size.width - 190 - 10, frame.size.height)];
        payLabel.backgroundColor = [UIColor clearColor];
        payLabel.textColor = [UIColor lightGrayColor];
        payLabel.textAlignment = NSTextAlignmentRight;
        payLabel.font = [UIFont systemFontOfSize:10.f];
        [self addSubview:payLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title number:(NSInteger)number cash:(float)cash {
    if(titleLabel) {
        titleLabel.text = [NSString stringWithFormat:@"%@",title];
    }
    if(payLabel) {
        payLabel.text = [NSString stringWithFormat:@"%.1f%@ * %ld", cash, NSLocalizedString(@"yuan", @""), (long)number];
    }
}

- (void)setTitle:(NSString *)title number:(NSInteger)number points:(NSInteger)points {
    if(titleLabel) {
        titleLabel.text = [NSString stringWithFormat:@"%@",title];
    }
    if(payLabel) {
        payLabel.text = [NSString stringWithFormat:@"%ld%@ * %ld",(long)points, NSLocalizedString(@"points_short_name", @""), (long)number];
    }
}

+ (CGFloat)calcHeightWithMerchandiseProperties:(NSArray *)properties {
   
    
    return 0;
}

@end
