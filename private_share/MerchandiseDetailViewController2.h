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
#import "MerchandiseParametersPicker.h"
#import "TransitionViewController.h"
#import "PurchaseViewController.h"

@interface MerchandiseDetailViewController2 : TransitionViewController<UIScrollViewDelegate, UIWebViewDelegate, MerchandiseParametersPickerDelegate>

@property (nonatomic, strong) Merchandise *merchandise;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;

@end
