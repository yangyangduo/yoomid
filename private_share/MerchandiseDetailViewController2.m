//
//  MerchandiseDetailViewController2.m
//  private_share
//
//  Created by Zhao yang on 7/10/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseDetailViewController2.h"
#import "ShoppingCartViewController2.h"
#import "UIImage+Color.h"
#import "UIDevice+ScreenSize.h"
#import "ShoppingCartViewController2.h"
#import "PurchaseViewController.h"
#import "UINavigationViewInitializer.h"

@implementation MerchandiseDetailViewController2 {
    UIWebView *htmlView;
    PullScrollZoomImagesView *pullImagesView;
    
    UIView *_loadingView_;
    UIActivityIndicatorView *indicatorView;
}

@synthesize merchandise = _merchandise_;

- (instancetype)initWithMerchandise:(Merchandise *)merchandise {
    self = [super init];
    if(self) {
        _merchandise_ = merchandise;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self automaticallyAdjustsScrollViewInsets];
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    htmlView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    htmlView.backgroundColor = [UIColor clearColor];
    htmlView.scrollView.delegate = self;
    htmlView.delegate = self;
    [self.view addSubview:htmlView];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    UIButton *addToShoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 0, 90, 30)];
    addToShoppingCartButton.tag = 200;
    
    UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 90, 30)];
    purchaseButton.tag = 300;
    UIButton *showMiRepoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12.f, 20, 20)];
    
    [addToShoppingCartButton setTitle:NSLocalizedString(@"add_to_exchange", @"") forState:UIControlStateNormal];
    [addToShoppingCartButton setBackgroundImage:[UIImage imageNamed:@"bottom_button"] forState:UIControlStateNormal];
    
    [purchaseButton setTitle:NSLocalizedString(@"purchase", @"") forState:UIControlStateNormal];
    [purchaseButton setBackgroundImage:[UIImage imageNamed:@"bottom_button"] forState:UIControlStateNormal];
    
    [showMiRepoButton setBackgroundImage:[UIImage imageNamed:@"miku_blue"] forState:UIControlStateNormal];
    
    purchaseButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    addToShoppingCartButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    addToShoppingCartButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    purchaseButton.layer.cornerRadius = 5;
    addToShoppingCartButton.layer.cornerRadius = 5;
    purchaseButton.layer.masksToBounds = YES;
    addToShoppingCartButton.layer.masksToBounds = YES;
    
    [addToShoppingCartButton addTarget:self action:@selector(showParameterPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [purchaseButton addTarget:self action:@selector(showParameterPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [showMiRepoButton addTarget:self action:@selector(showMiRepo:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomBar addSubview:showMiRepoButton];
    [bottomBar addSubview:addToShoppingCartButton];
    [bottomBar addSubview:purchaseButton];
    [self.view addSubview:bottomBar];
    
    pullImagesView = [[PullScrollZoomImagesView alloc] initAndEmbeddedInScrollView:htmlView.scrollView viewHeight:self.view.bounds.size.width];
    ImageItem *imageItem = [[ImageItem alloc] initWithUrl:self.merchandise.firstImageUrl title:nil];
    pullImagesView.imageItems = @[ imageItem ];
    
    UIImageView *topMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)];
    topMaskImageView.image = [UIImage imageNamed:@"black_top"];
    topMaskImageView.userInteractionEnabled = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    [self.view addSubview:topMaskImageView];
    [self.view addSubview:backButton];
    
    // loading view
    _loadingView_ = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice is4InchDevice] ? (self.view.bounds.size.height - 440) : (self.view.bounds.size.height - 350), htmlView.bounds.size.width, 44)];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullImagesView pullScrollViewDidScroll:scrollView];
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
    NSLog(@"[Merchandise Detail] Load url error.");
#endif
    [self stopLoadingView];
    [webView loadHTMLString:[self errorHtml] baseURL:nil];
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

- (void)popVC:(id)sender {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)showParameterPickerView:(UIButton *)sender {
    MerchandiseParametersPicker *picker = [MerchandiseParametersPicker pickerWithMerchandise:self.merchandise];
    picker.delegate = self;
    if(sender.tag == 200) {
        picker.pickerMode = MerchandisePickerModeForShoppingCart;
    } else {
        picker.pickerMode = MerchandisePickerModePurchase;
    }
    [picker showInView:self.view];
}

- (void)showMiRepo:(id)sender {
    ShoppingCartViewController2 *shoppingCartVC = [[ShoppingCartViewController2 alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];
}

- (void)merchandiseParametersPicker:(MerchandiseParametersPicker *)picker didPickMerchandiseWithPaymentType:(PaymentType)paymentType number:(NSInteger)number properties:(NSArray *)properties {
    
    [picker closeView];
    
    if(MerchandisePickerModeForShoppingCart == picker.pickerMode) {
        [[ShoppingCart myShoppingCart] putMerchandise:_merchandise_ shopID:kHentreStoreID number:number paymentType:paymentType properties:properties];
        [[XXAlertView currentAlertView] setMessage:@"已加入购物车" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    } else {
        ShopShoppingItems *shopShoppingItems = [[ShopShoppingItems alloc] init];
        shopShoppingItems.shopID = self.merchandise.shopId;
        ShoppingItem *newItem = [[ShoppingItem alloc] init];
        newItem.merchandise = self.merchandise;
        newItem.number = number;
        newItem.selected = YES;
        newItem.paymentType = paymentType;
        newItem.properties = properties;
        newItem.shopId = shopShoppingItems.shopID;
        [shopShoppingItems.shoppingItems addObject:newItem];
        
        PurchaseViewController *purchaseViewController = [[PurchaseViewController alloc] initWithShopShoppingItemss:@[ shopShoppingItems ] isFromShoppingCart:NO];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:purchaseViewController];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        [self rightPresentViewController:navigationController animated:YES];
    }
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
    [html appendString:@"暂无商品详情"];
    [html appendString:@"</p>"];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return html;
}

@end
