//
//  AboutYoomidViewController.m
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AboutYoomidViewController.h"
#import "DisclaimerViewController.h"

@implementation AboutYoomidViewController
{
    
    UIScrollView *scrollView;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于有米得";
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    versionLabel.textAlignment = NSTextAlignmentLeft;
    versionLabel.text = [NSString stringWithFormat:@"当前版本: %@",[infoDic objectForKey:@"CFBundleVersion"]];
    versionLabel.font = [UIFont systemFontOfSize:13.f];
    [scrollView addSubview:versionLabel];
    
    UIImageView *bg_image = [[UIImageView alloc] initWithFrame:CGRectMake(35, 30, 501/2, 501/2)];
    bg_image.image = [UIImage imageNamed:@"modal_background"];
    [scrollView addSubview:bg_image];
    
    UIImageView *weixinImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 258/2, 258/2)];
    weixinImage.image = [UIImage imageNamed:@"weixin"];
    [bg_image addSubview:weixinImage];
    
    UILabel *maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, bg_image.bounds.size.width, 30)];
    maskLabel.textAlignment = NSTextAlignmentLeft;
    maskLabel.text = @"请扫描二维码或微信搜索'有米得'";
    maskLabel.font = [UIFont systemFontOfSize:14.f];
    [bg_image addSubview:maskLabel];
    
    UILabel *xinlangLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, bg_image.bounds.size.width, 30)];
    xinlangLabel.textAlignment = NSTextAlignmentLeft;
    xinlangLabel.text = @"新浪微博: 有米得yoomide";
    xinlangLabel.font = [UIFont systemFontOfSize:14.f];
    [bg_image addSubview:xinlangLabel];

    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, bg_image.bounds.size.width, 30)];
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.text = @"联系邮箱: serena.chow@yoomid.com";
    emailLabel.font = [UIFont systemFontOfSize:14.f];
    [bg_image addSubview:emailLabel];

    
    UIButton *btnShowDisclaimer = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height - 205, 80, 30)];
    btnShowDisclaimer.backgroundColor = [UIColor clearColor];
    [btnShowDisclaimer setTitleColor:[UIColor appLightBlue] forState:UIControlStateNormal];
    btnShowDisclaimer.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [btnShowDisclaimer setTitle:NSLocalizedString(@"disclaimer", @"") forState:UIControlStateNormal];
    [btnShowDisclaimer addTarget:self action:@selector(btnShowDisclaimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnShowDisclaimer];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 100, self.view.bounds.size.height - 174, 200, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"Copyright @2014-2018";
    [scrollView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 100, self.view.bounds.size.height - 154, 200, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"All Rights Reserved.";
    [scrollView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 125, self.view.bounds.size.height - 134, 250, 20)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"湖南有私享网络科技有限公司";
    [scrollView addSubview:label3];

    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 20, self.view.bounds.size.height - 114, 40, 40)];
    logoImage.image = [UIImage imageNamed:@"icon80"];
    [scrollView addSubview:logoImage];
}

//免责声明
- (void)btnShowDisclaimerButtonPressed:(id)sender {
    [self.navigationController pushViewController:[[DisclaimerViewController alloc] init] animated:YES];
}

@end
