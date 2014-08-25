//
//  ViewQRCodeViewController.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "TransitionViewController.h"

@interface ViewQRCodeViewController : TransitionViewController

- (instancetype)initWithOrderId:(NSString *)orderId;

@end
