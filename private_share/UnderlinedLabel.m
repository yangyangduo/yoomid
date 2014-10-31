//
//  UnderlinedLabel.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UnderlinedLabel.h"

@implementation UnderlinedLabel

- (void)dealloc{
    self.lineColor = nil;
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    
    CGSize textSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y = 0.0f;
    
    if ([self textAlignment] == NSTextAlignmentRight) {
        origin_x = rect.size.width - strikeWidth;
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        origin_x = (rect.size.width - strikeWidth)/2 ;
    } else {
        origin_x = 0;
    }
    
    if (self.lineType == LineTypeUp) {
        origin_y =  2;
    }
    
    if (self.lineType == LineTypeMiddle) {
        origin_y =  rect.size.height/2;
    }
    
    if (self.lineType == LineTypeDown) {//下画线
        origin_y = rect.size.height - 2;
    }
    
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, 1);
    
    if (self.lineType != LineTypeNone) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        int numComponents = (int)CGColorGetNumberOfComponents(color);
        
        if( numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            
            CGContextSetRGBFillColor(context, R, G, B, 1.0);
        }
        
        CGContextFillRect(context, lineRect);
    }
}

@end
