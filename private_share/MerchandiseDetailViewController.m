//
//  MerchandiseDetailViewController.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseDetailViewController.h"
#import "ButtonUtil.h"
#import "UIColor+App.h"
#import "DefaultStyleButton.h"
#import "HtmlView.h"
#import "ShoppingCart.h"
#import "RadioListView.h"
#import "AppDelegate.h"
#import "XXAlertView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GlobalConfig.h"

@interface MerchandiseDetailViewController ()

@end

/*
@implementation MerchandiseDetailViewController {
    Merchandise *_merchandise_;
    NumberPicker *numberPicker;
    RadioListView *radioListView;
    
    CGFloat width;
    CGFloat contentHeight;
    CGFloat barHeight;
}

- (instancetype)initWithMerchandise:(Merchandise *)merchandise {
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    barHeight = 44;
    width = self.view.bounds.size.width - 15 * 2;
    contentHeight = self.view.bounds.size.height - 20 * 2 - barHeight;

    // navigation bar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, barHeight)];
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.barTintColor = [UIColor appColor];
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:20.f]
                                     };
    navigationBar.titleTextAttributes = textAttributes;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    [backButton addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // bar button item
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"merchandise_detail", @"")];
    navigationItem.leftBarButtonItem = backButtonItem;
    [navigationBar setItems:[NSArray arrayWithObject:navigationItem]];
    [self.view addSubview:navigationBar];
    
    // merchandise introduce
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, barHeight + 5, 100, 80)];
    [self.view addSubview:imageView];
    if(_merchandise_ != nil && _merchandise_.imageUrls != nil && _merchandise_.imageUrls.count > 0) {
        NSString *imageUrl = [_merchandise_.imageUrls objectAtIndex:0];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"merchandise_placeholder"]];
    } else {
        imageView.image = [UIImage imageNamed:@"merchandise_placeholder"];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5, barHeight, 130, 25)];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _merchandise_ != nil ? _merchandise_.name : @"";
    [self.view addSubview:titleLabel];
    
    NSString *title1 = [NSString stringWithFormat:@" %@%ld%@", NSLocalizedString(@"full_points", @""), (long)_merchandise_.points, NSLocalizedString(@"points", @"")];
    NSString *title2 = [NSString stringWithFormat:@"￥%.1f(%@%ld%@)", _merchandise_ != nil ? _merchandise_.points / 100.f : 0, NSLocalizedString(@"return_points", @""), (_merchandise_ != nil ? (long)_merchandise_.returnPoints : 0), NSLocalizedString(@"points", @"")];
    radioListView = [[RadioListView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x - 2, titleLabel.frame.origin.y + titleLabel.bounds.size.height + 3, 141, 55) titles:[NSArray arrayWithObjects:title1, title2, nil] selectedIndex:0];
    [self.view addSubview:radioListView];
    
    numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(titleLabel.frame.origin.x + titleLabel.bounds.size.width + 15, barHeight + 8) defaultValue:1 direction:NumberPickerDirectionVertical];
    numberPicker.maxValue = 99;
    numberPicker.delegate = self;
    [self.view addSubview:numberPicker];
    
    UIView *seperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.bounds.size.height + 4, width, 0.5f)];
    seperatorLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperatorLineView];
    
    // merchandise details (html)
    HtmlView *webView = [[HtmlView alloc] initWithFrame:CGRectMake(0, seperatorLineView.frame.origin.y + 1, width, contentHeight + barHeight - seperatorLineView.frame.origin.y - 1 - 40)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    // pay button
    UIButton *exchangeButton = [[DefaultStyleButton alloc] initWithFrame:CGRectMake((width - 180) / 2, webView.frame.origin.y + webView.bounds.size.height + 5, 180, 28)];
    exchangeButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exchangeButton addTarget:self action:@selector(exchangeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [exchangeButton setTitle:NSLocalizedString(@"add_to_exchange", @"") forState:UIControlStateNormal];
    [self.view addSubview:exchangeButton];
}

- (void)exchangeButtonPressed:(id)sender {
    if(_merchandise_ == nil || numberPicker.number <= 0) return;
    
    PaymentType paymentType = radioListView.selectedIndex == 0 ? PaymentTypePoints : PaymentTypeCash;
    [[ShoppingCart myShoppingCart] putMerchandise:_merchandise_ shopID:kHentreStoreID number:numberPicker.number paymentType:paymentType];
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"added_to_shopping_cart", @"") forType:AlertViewTypeSuccess];
    [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    [self dismissViewController:sender];
}

- (void)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(NSInteger)number {
}

- (NSString *)emptyHtmlString {
    return @"<!doctype html><html><head><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\"><meta name=\"viewport\" content=\"width=280px, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"></head><body><p style='color:gray; font-size:12px;'>暂无详情</p></body></html>";
}


@end

*/