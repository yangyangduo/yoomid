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
#import "NSMutableDictionary+Extension.h"
#import "NSDictionary+Extension.h"
#import "XXAlertView.h"
#import "XXStringUtils.h"
#import "JsonUtil.h"
#import "HttpResponse.h"
#import "Constants.h"

#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface BaseViewController : UIViewController<UMSocialUIDelegate>

- (void)resignFirstResponderFor:(UIView *)view;
- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture;
- (void)registerTapGestureToResignKeyboard;

- (void)handleFailureHttpResponse:(HttpResponse *)resp;

- (void)showLoadingViewIfNeed;
- (void)hideLoadingViewIfNeed;
- (void)showRetryView;
- (void)retryLoading;
- (CGFloat)contentViewCenterY;

- (void)showShareTitle:(NSString *)title text:(NSString *)text imageName:(NSString *)imageName;
@end
