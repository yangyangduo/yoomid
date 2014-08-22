//
//  HtmlView.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HtmlView : UIView<UIWebViewDelegate>

- (id)initWithFrame:(CGRect)frame htmlString:(NSString *)htmlString;

- (void)loadWithHtmlString:(NSString *)htmlString;

- (UIWebView *)webView;
- (UIView *)loadingView;

@end
