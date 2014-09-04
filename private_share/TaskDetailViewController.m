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

typedef NS_ENUM(NSUInteger, TaskResult) {
    TaskResultUnCompleted = 4,
    TaskResultRetry       = 3,
    TaskResultNoChance    = 2,
    TaskResultSuccess     = 1
};

@implementation TaskDetailViewController {
    UIWebView *_webView_;
    
    NSString *_url_;
    
    UIGestureRecognizer *retryTapGestrue;
    UIView *_loadingView_;
    UIActivityIndicatorView *indicatorView;
    
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
    
    retryTapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retryLoading)];
    
    _webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49)];
    _webView_.delegate = self;
    _webView_.backgroundColor = [UIColor clearColor];
    _webView_.opaque = NO;
    [self.view addSubview:_webView_];
    
    _loadingView_ = [[UIView alloc] initWithFrame:self.view.bounds];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 100, 44, 44)];
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.center = CGPointMake(self.view.center.x - 44, (self.view.bounds.size.height - 49 - 64) / 2);
    [_loadingView_ addSubview:indicatorView];
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lblLoading.tag = 1000;
    lblLoading.center = CGPointMake(indicatorView.center.x + 75, indicatorView.center.y);
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor darkGrayColor];
    lblLoading.font = [UIFont systemFontOfSize:17.f];
    [_loadingView_ addSubview:lblLoading];
    
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
        
        return;
    }
    [self postAnswersFailure:resp];
}

- (void)postAnswersFailure:(HttpResponse *)resp {
    [self handleFailureHttpResponse:resp];
}

- (void)requestTaskDetailWithUrl:(NSString *)url {
    [self showLoadingViewIfNeed];

    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.f];
    [_webView_ loadRequest:request];
}


#pragma mark -

- (void)retryLoading {
    [self requestTaskDetailWithUrl:_url_];
}

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
