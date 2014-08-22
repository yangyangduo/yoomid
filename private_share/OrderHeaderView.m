//
//  OrderHeaderView.m
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "OrderHeaderView.h"
#import "UIColor+App.h"

@implementation OrderHeaderView {
    UILabel *orderIdLabel;
    UILabel *orderTimeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 55, 28)];
        titleLabel.font = [UIFont systemFontOfSize:13.f];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"order_id", @"")];
        [self addSubview:titleLabel];
        
        orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 180, 28)];
        orderIdLabel.font = [UIFont systemFontOfSize:13.f];
        orderIdLabel.textColor = [UIColor darkGrayColor];
        orderIdLabel.text = @"";
        [self addSubview:orderIdLabel];
        
        UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 55, 18)];
        orderTime.font = [UIFont systemFontOfSize:10.f];
        orderTime.textColor = [UIColor lightGrayColor];
        orderTime.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"order_time", @"")];
        [self addSubview:orderTime];
        
        orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 180, 18)];
        orderTimeLabel.font = [UIFont systemFontOfSize:10.f];
        orderTimeLabel.textColor = [UIColor lightGrayColor];
        orderTimeLabel.text = @"";
        [self addSubview:orderTimeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, frame.size.height - 10, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setOrderId:(NSString *)orderId orderTime:(NSDate *)orderTime {
    if(orderIdLabel) {
        orderIdLabel.text = orderId == nil ? @"" : orderId;
    }
    if(orderTimeLabel) {
        NSString *dateString = @"";
        if(orderTime) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            dateString = [dateFormatter stringFromDate:orderTime];
        }
        orderTimeLabel.text = dateString;
    }
}

@end
