//
//  ActivityDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionViewController.h"
#import "Merchandise.h"
#import "PullScrollZoomImagesView.h"
#import "YoomidRectModalView.h"

@interface ActivityDetailViewController : TransitionViewController<UIScrollViewDelegate, UIWebViewDelegate, PullScrollZoomImagesViewDelegate,ShareDeletage>

@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithActivityMerchandise:(Merchandise *)merchandise;

@end
