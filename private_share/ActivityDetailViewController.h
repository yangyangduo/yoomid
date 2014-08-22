//
//  ActivityDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Merchandise.h"
#import "PullScrollZoomImagesView.h"

@interface ActivityDetailViewController : BaseViewController<UIScrollViewDelegate, UIWebViewDelegate, PullScrollZoomImagesViewDelegate>

@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithActivityMerchandise:(Merchandise *)merchandise;

@end
