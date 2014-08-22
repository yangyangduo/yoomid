//
//  BaseViewController.h
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+App.h"
#import "UIDevice+SystemVersion.h"
#import "XXAlertView.h"
#import "XXStringUtils.h"
#import "JsonUtil.h"
#import "HttpResponse.h"
#import "Constants.h"

@interface BaseViewController : UIViewController

- (void)resignFirstResponderFor:(UIView *)view;
- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture;
- (void)registerTapGestureToResignKeyboard;

- (void)handleFailureHttpResponse:(HttpResponse *)resp;

@end
