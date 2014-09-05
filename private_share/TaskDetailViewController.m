//
//  TaskDetailViewController.m
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "JsonUtil.h"
#import "MyPointsRecordViewController.h"
#import "TaskService.h"
#import "YoomidRewardModalView.h"

typedef NS_ENUM(NSUInteger, TaskResult) {
    TaskResultUnCompleted = 4,
    TaskResultRetry       = 3,
    TaskResultNoChance    = 2,
    TaskResultSuccess     = 1
};

@implementation TaskDetailViewController {
    UIWebView *_webView_;
    NSString *_url_;
    UIView *tabBar;
}

@synthesize task = _task_;

- (instancetype)initWithTask:(Task *)task {
    self = [super init];
    if(self) {
        self.task = task;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    
    _webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49)];
    _webView_.delegate = self;
    _webView_.backgroundColor = [UIColor clearColor];
    _webView_.opaque = NO;
    [self.view addSubview:_webView_];
    
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 49, self.view.bounds.size.width, 49)];
    tabBar.backgroundColor = [UIColor appColor];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(tabBar.bounds.size.width - 90, 0, 90, 35)];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"bottom_button2"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(findTaskResultAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [tabBar addSubview:confirmButton];
    [self.view addSubview:tabBar];
    
    [self requestTaskDetailWithUrl:_url_];
}

- (void)findTaskResultAndSubmit {
    NSString *result = [_webView_ stringByEvaluatingJavaScriptFromString:@"validateAnswers()"];
    if(result != nil && ![@"" isEqualToString:result]) {
        NSData *postData = [result dataUsingEncoding:NSUTF8StringEncoding];
        [JsonUtil printJsonData:postData];
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:postData];
        if(result != nil) {
            NSInteger taskResult = [result numberForKey:@"result"].integerValue;
            if(TaskResultUnCompleted == taskResult) {
                
                return;
            } else if(TaskResultRetry == taskResult) {
                
                return;
            } else if(TaskResultNoChance == taskResult
                        || TaskResultSuccess == taskResult ) {
                
                NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary:[result dictionaryForKey:@"content"]];
                [content setMayBlankString:[SecurityConfig defaultConfig].userName forKey:@"userId"];
                [content setMayBlankString:@"aaa" forKey:@"deviceId"];
                
                [[XXAlertView currentAlertView] setMessage:@"正在提交" forType:AlertViewTypeWaitting];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
                TaskService *service = [[TaskService alloc] init];
                [service postAnswers:content target:self success:@selector(postAnswersSuccess:) failure:@selector(postAnswersFailure:)];

                return;
            }
        }
    }
    // other error
    
#ifdef DEBUG
    NSLog(@"[Task Detail] Error on submit answers that post data is empty");
#endif
}


#pragma mark -
#pragma mark Network request

- (void)postAnswersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
            YoomidRewardModalView *modalView = [[YoomidRewardModalView alloc] initWithSize:CGSizeMake(250, 250)];
            [modalView showInView:self.navigationController.view completion:^{ }];
        }];
        
        return;
    }
    [self postAnswersFailure:resp];
}

- (void)postAnswersFailure:(HttpResponse *)resp {
    [self handleFailureHttpResponse:resp];
}

- (void)requestTaskDetailWithUrl:(NSString *)url {
    if(url != nil && ![@"" isEqualToString:url]) {
        [self showLoadingViewIfNeed];

        NSURL *requestUrl = [[NSURL alloc] initWithString:url];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.f];
        [_webView_ loadRequest:request];
    }
}


#pragma mark -

- (void)retryLoading {
    [self requestTaskDetailWithUrl:_url_];
}

- (CGFloat)contentViewCenterY {
    return (self.view.bounds.size.height - 49 - 64) / 2;
}

#pragma mark -
#pragma mark Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingViewIfNeed];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showRetryView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSURL *requestURL = [request URL];
//    if([[requestURL scheme] isEqualToString:@"yoomid"]) {
//        [self findTaskResultAndSubmit];
//        return NO;
//    }
    return YES;
}

#pragma mark -
#pragma mark Animation controller delegate

- (UIViewController *)rightPresentationViewController {
    return [[MyPointsRecordViewController alloc] init];
}

- (CGFloat)rightPresentViewControllerOffset {
    return 88.f;
}

- (void)setTask:(Task *)task {
    _task_ = task;
    if(_task_ != nil) {
        _url_ = [NSString stringWithFormat:@"%@/yoomid/task?categoryId=%@&taskId=%@&%@", kBaseUrl, _task_.categoryId, _task_.identifier, [BaseService authString]];
#ifdef DEBUG
        NSLog(@"Task url is [%@]", _url_);
#endif
    }
}

@end
