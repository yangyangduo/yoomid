//
//  BaseViewController.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "ReturnMessage.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)registerTapGestureToResignKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(triggerTapGestureEventForResignKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture {
    [self resignFirstResponderFor:self.view];
}

- (void)resignFirstResponderFor:(UIView *)view {
    for (UIView *v in view.subviews) {
        if([v isFirstResponder]) {
            [v resignFirstResponder];
            return;
        }
    }
}

- (void)handleFailureHttpResponse:(HttpResponse *)resp {
    if(1001 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [self safetyAlertAndDelayDismiss];
        return;
    } else if(400 == resp.statusCode) {
        if(resp.contentType != nil && resp.body != nil && [resp.contentType rangeOfString:@"application/json" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSDictionary *_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_json_ != nil) {
                ReturnMessage *message = [[ReturnMessage alloc] initWithDictionary:_json_];
                [[XXAlertView currentAlertView] setMessage:message.message forType:AlertViewTypeFailed];
                [self safetyAlertAndDelayDismiss];
                return;
            }
        }
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"bad_request", @"") forType:AlertViewTypeFailed];
        [self safetyAlertAndDelayDismiss];
        return;
    } else if(403 == resp.statusCode) {
        // 403 media type should be processed by http filter first
        // so just ignore here
    } else if(500 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"server_error", @"") forType:AlertViewTypeFailed];
        [self safetyAlertAndDelayDismiss];
        return;
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
        [self safetyAlertAndDelayDismiss];
        return;
    }
}

- (void)safetyAlertAndDelayDismiss {
    if(AlertViewStateDidAppear == [XXAlertView currentAlertView].alertViewState
       || AlertViewStateWillAppear == [XXAlertView currentAlertView].alertViewState) {
        [[XXAlertView currentAlertView] delayDismissAlertView];
    } else {
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIViewController *topViewController = app.topViewController;
    NSLog(@"Top view controller is [%@].", [[topViewController class] description]);
}

@end
