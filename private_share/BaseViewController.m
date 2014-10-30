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
#import "ViewControllerAccessor.h"

@interface BaseViewController ()

@end

@implementation BaseViewController {
    UIGestureRecognizer *retryTapGestrue;
    UIView *_loadingView_;
    UIActivityIndicatorView *indicatorView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_image"]];
    
    retryTapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retryLoading)];
    
    _loadingView_ = [[UIView alloc] initWithFrame:self.view.bounds];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 100, 44, 44)];
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.center = CGPointMake(self.view.center.x - 44, [self contentViewCenterY]);
    [_loadingView_ addSubview:indicatorView];
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lblLoading.tag = 1000;
    lblLoading.center = CGPointMake(indicatorView.center.x + 75, indicatorView.center.y);
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor darkGrayColor];
    lblLoading.font = [UIFont systemFontOfSize:17.f];
    [_loadingView_ addSubview:lblLoading];
}

#pragma mark -
#pragma mark About keyboard

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

#pragma mark -
#pragma mark About loading view

- (void)showLoadingViewIfNeed {
    [self.view removeGestureRecognizer:retryTapGestrue];
    
    UILabel *lblLoading = (UILabel *)[_loadingView_ viewWithTag:1000];
    lblLoading.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"loading", @""), @"..."];
    lblLoading.textAlignment = NSTextAlignmentLeft;
    CGRect frame = lblLoading.frame;
    lblLoading.frame = CGRectMake(indicatorView.frame.origin.x + indicatorView.frame.size.width, 0, frame.size.width, frame.size.height);
    lblLoading.center = CGPointMake(lblLoading.center.x, indicatorView.center.y);
    
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    
    if(_loadingView_.superview == nil) {
        [self.view addSubview:_loadingView_];
    }
}

- (void)hideLoadingViewIfNeed {
    [self.view removeGestureRecognizer:retryTapGestrue];
    
    [indicatorView stopAnimating];
    if(_loadingView_.superview != nil) {
        [_loadingView_ removeFromSuperview];
    }
}

- (void)showRetryView {
    UILabel *lblLoading = (UILabel *)[_loadingView_ viewWithTag:1000];
    lblLoading.text = @"失败了, 请点击屏幕重新加载!";
    lblLoading.center = CGPointMake(self.view.center.x, lblLoading.center.y);
    lblLoading.textAlignment = NSTextAlignmentCenter;
    
    BOOL gestureExists = NO;
    for(UIGestureRecognizer *gestrue in self.view.gestureRecognizers) {
        if(gestrue == retryTapGestrue) {
            gestureExists = YES;
            break;
        }
    }
    
    if(!gestureExists) {
        [self.view addGestureRecognizer:retryTapGestrue];
    }
    
    indicatorView.hidden = YES;
    [indicatorView stopAnimating];
    if(_loadingView_.superview == nil) {
        [self.view addSubview:_loadingView_];
    }
}

- (CGFloat)contentViewCenterY {
    return self.view.bounds.size.height / 2;
}

- (void)retryLoading {
    
}

#pragma mark -
#pragma mark About network

- (void)handleFailureHttpResponse:(HttpResponse *)resp {
    if(1001 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [self safetyAlertAndDelayDismiss];
        return;
    } else if(400 == resp.statusCode) {
        if(resp.contentType != nil && resp.body != nil && [resp.contentType rangeOfString:@"application/json" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSDictionary *_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_json_ != nil) {
                ReturnMessage *message = [[ReturnMessage alloc] initWithJson:_json_];
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
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *topViewController = app.topViewController;
    NSLog(@"Top view controller is [%@].", [[topViewController class] description]);
}

- (void)showShareTitle:(NSString *)title text:(NSString *)text imageName:(NSString *)imageName imageUrl:(NSString *)imageurl contentUrl:(NSString *)contentUrl
{
//    if (tempObj) {
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    [[UMSocialData defaultData].extConfig.wechatSessionData setTitle:title];  //设置微信好友分享标题
//    [[UMSocialData defaultData].extConfig.wechatTimelineData setTitle:title];  //设置微信朋友圈分享标题
    [[UMSocialData defaultData].extConfig.qqData setTitle:title];  //设置QQ好友分享标题
    [[UMSocialData defaultData].extConfig.qzoneData setTitle:title];  //设置QQ空间好友分享标题
    [UMSocialData defaultData].extConfig.sinaData.shareText = title;
    
    if (imageurl != nil) {
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageurl];  //设置微信好友分享url图片
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageurl];  //设置微信朋友圈分享url图片
        [[UMSocialData defaultData].extConfig.qzoneData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageurl]; //qq空间
        [[UMSocialData defaultData].extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageurl]; //qq
    }
    if (contentUrl != nil) {
        [[UMSocialData defaultData].extConfig.wechatSessionData setUrl:contentUrl];  //设置微信好友分享连接url
        [[UMSocialData defaultData].extConfig.wechatTimelineData setUrl:contentUrl];  //
        [[UMSocialData defaultData].extConfig.qzoneData setUrl:contentUrl]; //qq空间
        [[UMSocialData defaultData].extConfig.qqData setUrl:contentUrl]; //qq
    }

    [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"54052fe0fd98c5170d06988e"
                                          shareText:text
                                         shareImage:[UIImage imageNamed:imageName]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,UMShareToQQ,nil]
                                           delegate:self];

//    }
}

#pragma mrak- share delegate
//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //        response.viewControllerType
        [[XXAlertView currentAlertView] setMessage:@"分享成功!" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


@end
