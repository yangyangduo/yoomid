//
//  MerchandiseDetailViewController2.h
//  private_share
//
//  Created by Zhao yang on 7/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "Merchandise.h"
#import "PullScrollZoomImagesView.h"

@interface MerchandiseDetailViewController2 : BaseViewController<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;

@end
