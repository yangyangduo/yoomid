//
//  UnderlinedLabel.h
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    LineTypeNone,//没有画线
    LineTypeUp ,// 上边画线
    LineTypeMiddle,//中间画线
    LineTypeDown,//下边画线
    
} LineType ;

@interface UnderlinedLabel : UILabel
@property (assign, nonatomic) LineType lineType;
@property (assign, nonatomic) UIColor * lineColor;


@end
