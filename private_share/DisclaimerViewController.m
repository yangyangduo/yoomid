//
//  DisclaimerViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/6.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "DisclaimerViewController.h"

@implementation DisclaimerViewController
{
    UIWebView *htmlView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    self.title = @"免责声明";
    
    htmlView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 160)];
    htmlView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:htmlView];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [htmlView loadRequest:request];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 160, self.view.bounds.size.width, 160)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, bottomView.bounds.size.width, 30)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"Copyright @2014-2018";
    [bottomView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, bottomView.bounds.size.width, 30)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"All Rights Reserved.";
    [bottomView addSubview:label2];

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, bottomView.bounds.size.width, 30)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"湖南有私享网络科技有限公司";
    [bottomView addSubview:label3];

}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
