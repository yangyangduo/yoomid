//
//  TaskDetailViewController.m
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "MyPointsRecordViewController.h"
#import "TaskService.h"
#import "UIDevice+Identifier.h"
#import "JsonUtil.h"
#import "DiskCacheManager.h"

typedef NS_ENUM(NSUInteger, TaskResult) {
    TaskResultTimeout     = 5,
    TaskResultUnCompleted = 4,
    TaskResultRetry       = 3,
    TaskResultNoChance    = 2,
    TaskResultSuccess     = 1
};

@implementation TaskDetailViewController {
    UIWebView *_webView_;
    NSString *_url_;
    
    UIView *tabBar;
    UILabel *timerLabel;
    NSInteger timeLeft;
    NSTimer *taskTimer;
    
    BOOL isLoaded;
    BOOL isExpired;
    BOOL isSubmitting;
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
    
    UIImageView *pointsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, 133.f / 2, 133.f / 2)];
    pointsImageView.image = [UIImage imageNamed:@"mm"];
    pointsImageView.center = CGPointMake(tabBar.bounds.size.width / 2 + 15, pointsImageView.center.y);
    [tabBar addSubview:pointsImageView];
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsImageView.frame.origin.x - 60, 4, 50, 41)];
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.font = [UIFont boldSystemFontOfSize:22.f];
    pointsLabel.textColor = [UIColor whiteColor];
    pointsLabel.textAlignment = NSTextAlignmentRight;
    pointsLabel.text = self.task == nil ? @"" : [NSString stringWithFormat:@"%d", self.task.points];
    [tabBar addSubview:pointsLabel];
    
    if(self.task.isGuessPictureTask) {
        UIImageView *taskTimerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, - (136.f / 4) - 6, 112.f / 2, 136.f / 2)];
        taskTimerImageView.image = [UIImage imageNamed:@"task_timer"];
        [tabBar addSubview:taskTimerImageView];
        
        timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 24, 55, 32)];
        timerLabel.backgroundColor = [UIColor clearColor];
        timerLabel.font = [UIFont systemFontOfSize:30.f];
        timerLabel.textAlignment = NSTextAlignmentCenter;
        timerLabel.text = [NSString stringWithFormat:@"%d", self.task.timeLimitInSeconds];
        timerLabel.textColor = [UIColor appLightBlue];
        [taskTimerImageView addSubview:timerLabel];
    }
    [self requestTaskDetailWithUrl:_url_];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(taskTimer != nil || taskTimer.isValid) {
        [taskTimer invalidate];
        taskTimer = nil;
    }
}

- (void)doTaskTimer {
    timerLabel.text = [NSString stringWithFormat:@"%d", timeLeft];
    timeLeft--;
    if(timeLeft < 0) {
        isExpired = YES;
        [taskTimer invalidate];
        taskTimer = nil;
        
        // submit failure answers
        NSString *resultString = [_webView_ stringByEvaluatingJavaScriptFromString:@"getJsonResultString(Result.NoChance, 1, '')"];
        if(resultString != nil && ![@"" isEqualToString:resultString]) {
            NSData *postData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:postData];
            if(result != nil) {
                isSubmitting = YES;
                
                NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary:[result dictionaryForKey:@"content"]];
                [content setMayBlankString:[SecurityConfig defaultConfig].userName forKey:@"userId"];
                [content setMayBlankString:[UIDevice idfaString] forKey:@"deviceId"];
                [[XXAlertView currentAlertView] setMessage:@"正在提交" forType:AlertViewTypeWaitting];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
                TaskService *service = [[TaskService alloc] init];
                [service postAnswers:content target:self success:@selector(postAnswersSuccess:) failure:@selector(postAnswersFailure:) taskResult:TaskResultTimeout];
            }
        }
    }
}

- (void)findTaskResultAndSubmit {
    if(isExpired) return;
    if(isSubmitting) return;
    
    NSString *resultString = [_webView_ stringByEvaluatingJavaScriptFromString:@"validateAnswers()"];
    if(resultString != nil && ![@"" isEqualToString:resultString]) {
        NSData *postData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
        [JsonUtil printJsonData:postData];
#endif
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:postData];
        if(result != nil) {
            NSInteger taskResult = [result numberForKey:@"result"].integerValue;
            if(TaskResultUnCompleted == taskResult) {
                YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 300) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"请回答完所有题目!" buttonTitles:@[ @"继续答题" ] cancelButtonIndex:0];
                [modal showInView:self.navigationController.view completion:nil];
                return;
            } else if(TaskResultRetry == taskResult) {
                YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 330) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"回答错误! 你还剩下一次机会哦!" buttonTitles:@[ @"继续答题" ] cancelButtonIndex:0];
                [modal showInView:self.navigationController.view completion:nil];
                return;
            } else if(TaskResultNoChance == taskResult
                        || TaskResultSuccess == taskResult ) {
                
                isSubmitting = YES;
                
                if(taskTimer != nil && taskTimer.isValid) {
                    [taskTimer invalidate];
                    taskTimer = nil;
                }
                
                NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary:[result dictionaryForKey:@"content"]];
                [content setMayBlankString:[SecurityConfig defaultConfig].userName forKey:@"userId"];
                [content setMayBlankString:[UIDevice idfaString] forKey:@"deviceId"];
                [[XXAlertView currentAlertView] setMessage:@"正在提交" forType:AlertViewTypeWaitting];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
                TaskService *service = [[TaskService alloc] init];
                [service postAnswers:content target:self success:@selector(postAnswersSuccess:) failure:@selector(postAnswersFailure:) taskResult:taskResult];

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
            NSNumber *number = resp.userInfo;
            NSInteger taskResult = number.integerValue;
            if(TaskResultTimeout == taskResult) {
                [self markTaskHistorical];
                YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 330) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"回答超时!很遗憾, 未能获得米米" buttonTitles:@[ @"继续答题" ] cancelButtonIndex:0];
                modal.modalViewDelegate = self;
                [modal showInView:self.navigationController.view completion:nil];
            } else if(TaskResultNoChance == taskResult) {
                [self markTaskHistorical];
                YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 300) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"很遗憾, 未能获得米米" buttonTitles:@[ @"继续答题" ] cancelButtonIndex:0];
                modal.modalViewDelegate = self;
                [modal showInView:self.navigationController.view completion:nil];
            } else if(TaskResultSuccess == taskResult) {
                [self markTaskHistorical];
                YoomidSemicircleModalView *modal = [[YoomidSemicircleModalView alloc] initWithSize:CGSizeMake(500.f / 2, 761.f / 2) backgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"modal_success@2x" ofType:@"png"]] titleMessage:@"恭喜哈尼答对了!" message:[NSString stringWithFormat:@"额外获得%d%@", self.task.points, NSLocalizedString(@"points", @"")] buttonTitles:@[ @"确定", @"分享好友" ] cancelButtonIndex:0];
                modal.modalViewDelegate = self;
                [modal showInView:self.navigationController.view completion:nil];
            }
        }];
        return;
    }
    [self postAnswersFailure:resp];
}

- (void)markTaskHistorical {
    NSMutableArray *completedTaskIds = nil;
    NSArray *cacheData = [DiskCacheManager manager].completedTaskIds;
    if(cacheData == nil) {
        completedTaskIds = [NSMutableArray array];
    } else {
        completedTaskIds = [NSMutableArray arrayWithArray:cacheData];
    }
    [completedTaskIds addObject:self.task.identifier];
    [[DiskCacheManager manager] setCompletedTaskIds:completedTaskIds];
}

- (void)postAnswersFailure:(HttpResponse *)resp {
    [self handleFailureHttpResponse:resp];
    isSubmitting = NO;
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
    
    if(self.task.isGuessPictureTask) {
        if(taskTimer == nil) {
            timeLeft = self.task.timeLimitInSeconds;
            taskTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(doTaskTimer) userInfo:nil repeats:YES];
        }
    }
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
#pragma mark Modal view delegate

- (void)modalViewDidClosed:(ModalView *)modalView {
    [self rightPopViewControllerAnimated:YES];
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
