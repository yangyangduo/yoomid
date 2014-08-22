//
//  ShoppingCompleteViewController.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCompleteViewController.h"
#import "DefaultStyleButton.h"

@implementation ShoppingCompleteViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"shopping_complete", @"");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    [backButton addTarget:self action:@selector(btnContinueShoppingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 235.f / 2, 235.f / 2)];
    logoImageView.center = CGPointMake(self.view.center.x, logoImageView.center.y);
    logoImageView.image = [UIImage imageNamed:@"logo_menu"];
    [self.view addSubview:logoImageView];
    
    UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y + logoImageView.bounds.size.height + 15, 240, 70)];
    thanksLabel.center = CGPointMake(self.view.center.x, thanksLabel.center.y);
    thanksLabel.numberOfLines = 3;
    thanksLabel.font = [UIFont systemFontOfSize:15.f];
    thanksLabel.textColor = [UIColor lightGrayColor];
    thanksLabel.text = NSLocalizedString(@"shopping_complete_tips", @"");
    thanksLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:thanksLabel];
    
    UILabel *servicePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, thanksLabel.frame.origin.y + thanksLabel.bounds.size.height + 2, 200, 22)];
    servicePhoneLabel.backgroundColor = [UIColor clearColor];
    servicePhoneLabel.textColor = [UIColor lightGrayColor];
    servicePhoneLabel.textAlignment = NSTextAlignmentLeft;
    servicePhoneLabel.center = CGPointMake(self.view.center.x, servicePhoneLabel.center.y);
    servicePhoneLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"custom_service_phone", @""), @"400-000-000"];
    [self.view addSubview:servicePhoneLabel];
    
    UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(servicePhoneLabel.frame.origin.x, servicePhoneLabel.frame.origin.y + servicePhoneLabel.bounds.size.height + 5, 200, 22)];
    wechatLabel.backgroundColor = [UIColor clearColor];
    wechatLabel.textAlignment = NSTextAlignmentLeft;
    wechatLabel.textColor = [UIColor lightGrayColor];
    wechatLabel.center = CGPointMake(self.view.center.x, wechatLabel.center.y);
    wechatLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"wechat_account", @""), @"yoomid"];
    [self.view addSubview:wechatLabel];
    
    UIButton *btnContinueShopping = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(0, wechatLabel.frame.origin.y + wechatLabel.bounds.size.height + 20, 260, 30)];
    btnContinueShopping.center = CGPointMake(self.view.center.x, btnContinueShopping.center.y);
    [btnContinueShopping addTarget:self action:@selector(btnContinueShoppingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnContinueShopping setTitle:NSLocalizedString(@"continue_shopping", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnContinueShopping];
}

- (void)btnContinueShoppingPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
