//
//  CustomCollectionView.m
//  private_share
//
//  Created by 曹大为 on 14-8-20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "CustomCollectionView.h"
#import "PullScrollZoomImagesView.h"

@implementation CustomCollectionView

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    
    if(index == 0 && ![view isKindOfClass:[PullScrollZoomImagesView class]]) {
        for(UIView *v in self.subviews) {
            if([v isKindOfClass:[PullScrollZoomImagesView class]]) {
                [self sendSubviewToBack:v];
                break;
            }
        }
    }
}

@end
