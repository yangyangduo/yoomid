//
//  GuideViewController.m
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "GuideViewController.h"
#import "UIDevice+ScreenSize.h"

@implementation GuideViewController {
    UIScrollView *scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    BOOL is4InchDevice = [UIDevice is4InchDevice];
    for(int i=0; i<5; i++) {
        NSMutableString *imageName = [[NSMutableString alloc] initWithString:@"guide"];
        [imageName appendFormat:@"%d", (i + 1)];
        if(is4InchDevice) {
            [imageName appendString:@"-568h"];
        }
        [imageName appendString:@"@2x"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        
        if(i == 4) {
            CGFloat y = 456;
            if(!is4InchDevice) {
                y = 386;
            }
            UIButton *goButton = [[UIButton alloc] initWithFrame:CGRectMake(242, y, 115.f / 2, 85.f / 2)];
            [goButton setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:goButton];
            
            [goButton addTarget:self action:@selector(goButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }

        [scrollView addSubview:imageView];
    }
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 5, scrollView.bounds.size.height);
}

- (void)goButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

@end
