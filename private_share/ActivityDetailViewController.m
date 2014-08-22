//
//  ActivityDetailViewController.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "UIColor+App.h"
#import "ButtonUtil.h"
#import "LeftDrawerViewController.h"
#import "PullScrollZoomImageHtmlView.h"
#import "DefaultStyleButton.h"
#import "UIDevice+ScreenSize.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController {
    UILabel *availablePointsLabel;
    UITableView *activityMerchandisesTableView;
    
    PullScrollZoomImagesView *pullImagesView;
    UIWebView *htmlView;
    UIPageControl *pageControl;
    
    UIView *_loadingView_;
    UIActivityIndicatorView *indicatorView;
    
    UIButton *participateButton;
}

@synthesize merchandise = _merchandise_;

- (instancetype)initWithActivityMerchandise:(Merchandise *)merchandise {
    self = [super init];
    if(self) {
        _merchandise_ = merchandise;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"app_name", @"");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    htmlView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45)];
    htmlView.backgroundColor = [UIColor whiteColor];
    htmlView.scrollView.delegate = self;
    htmlView.delegate = self;
    [self.view addSubview:htmlView];
    
    UIView *descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    descriptionView.backgroundColor = [UIColor whiteColor];
    
    // desc view sub view
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(5, 10, 80, 30)];
    pageControl.numberOfPages = _merchandise_.imageUrls.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor appBlue];
    [descriptionView addSubview:pageControl];
    
    UIImageView *goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 15, 20.5f, 20.5f)];
    goodImageView.image = [UIImage imageNamed:@"likes"];
    [descriptionView addSubview:goodImageView];
    UILabel *thinksGoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(206, 10, 100, 30)];
    thinksGoodLabel.text = [NSString stringWithFormat:@"%ld%@", _merchandise_.follows, NSLocalizedString(@"thinks_good", @"")];
    thinksGoodLabel.font = [UIFont systemFontOfSize:15.f];
    thinksGoodLabel.textAlignment = NSTextAlignmentCenter;
    thinksGoodLabel.backgroundColor = [UIColor clearColor];
    thinksGoodLabel.textColor = [UIColor appBlue];
    [descriptionView addSubview:thinksGoodLabel];
    
    // desc view layout
    CGRect _frame_ = descriptionView.frame;
    _frame_.origin.x = 0;
    _frame_.origin.y = -_frame_.size.height;
    descriptionView.frame = _frame_;
    [htmlView.scrollView insertSubview:descriptionView atIndex:0];
    htmlView.scrollView.contentInset = UIEdgeInsetsMake(_frame_.size.height, 0, 0, 0);
    
    participateButton = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 35, 280, 30)];
    [participateButton addTarget:self action:@selector(participateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [participateButton setTitle:NSLocalizedString(@"participate", @"") forState:UIControlStateNormal];
    [self.view addSubview:participateButton];
    
    //
    pullImagesView = [[PullScrollZoomImagesView alloc] initAndEmbeddedInScrollView:htmlView.scrollView];
    pullImagesView.delegate = self;
    
    UIImageView *topMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)];
    topMaskImageView.image = [UIImage imageNamed:@"black_top"];
    topMaskImageView.userInteractionEnabled = YES;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 25.5f, 29, 29)];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:topMaskImageView];
    [self.view addSubview:backButton];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:pullImagesView.bottomView.bounds];
    maskImageView.image = [UIImage imageNamed:@"black_bottom"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width - 20, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:240.f / 255.f green:240.f / 255.f blue:240.f / 255.f alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.text = self.merchandise == nil ? @"" : self.merchandise.name;
    [maskImageView addSubview:titleLabel];
    [pullImagesView.bottomView addSubview:maskImageView];
    
    NSMutableArray *images = [NSMutableArray array];
    if(_merchandise_ != nil) {
        for(NSString *url in _merchandise_.imageUrls) {
            ImageItem *item = [[ImageItem alloc] initWithUrl:url title:nil];
            [images addObject:item];
        }
    }
    pullImagesView.imageItems = [NSArray arrayWithArray:images];
    
    // loading view
    
    _loadingView_ = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice is4InchDevice] ? (self.view.bounds.size.height - 450) : (self.view.bounds.size.height - 370), htmlView.bounds.size.width, 44)];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.center = CGPointMake(htmlView.bounds.size.width / 2 - 50, htmlView.bounds.size.height / 2);
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_loadingView_ addSubview:indicatorView];
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    lblLoading.center = CGPointMake(indicatorView.center.x + 75, indicatorView.center.y);
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor grayColor];
    lblLoading.font = [UIFont systemFontOfSize:15.f];
    lblLoading.text = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"loading", @"")];
    [_loadingView_ addSubview:lblLoading];
    
    // load request
    [htmlView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/merchandises/%@", kBaseUrl, _merchandise_.identifier]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.f]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pullImagesView.scrollViewLocked = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullImagesView pullScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        pullImagesView.scrollViewLocked = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pullImagesView.scrollViewLocked = NO;
}

- (void)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UI Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self startLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"[Activity Detail] Load url error.");
#endif
    [self stopLoadingView];
    [webView loadHTMLString:[self errorHtml] baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = [request URL];

    if (
        ([[requestURL scheme] isEqualToString:@"http" ]
            || [[requestURL scheme] isEqualToString:@"https" ]
            || [[requestURL scheme] isEqualToString:@"mailto"])
        &&
        (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        return ![[UIApplication sharedApplication ] openURL:requestURL];
    } else if([[requestURL scheme] isEqualToString:@"yoomid"]) {

        return NO;
    }
    
    return YES;
}

- (void)pullScrollZoomImagesView:(PullScrollZoomImagesView *)pullScrollZoomImagesView imagesPageIndexChangedTo:(NSUInteger)newPageIndex {
    pageControl.currentPage = newPageIndex;
}

- (void)startLoadingView {
    if(_loadingView_.superview == nil) {
        [htmlView addSubview:_loadingView_];
        [indicatorView startAnimating];
    }
}

- (void)stopLoadingView {
    if(_loadingView_.superview != nil) {
        [indicatorView stopAnimating];
        [_loadingView_ removeFromSuperview];
    }
}

- (void)participateButtonPressed:(id)sender {
}

- (NSString *)errorHtml {
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<!doctype html><html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\" />"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:@"<p style=\"color: gray; font-size:14px; margin-left:10px; margin-top:15px;\">"];
    [html appendString:@"暂无活动详情"];
    [html appendString:@"</p>"];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return html;
}

@end
