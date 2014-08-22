//
//  WebViewController.h
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ContentSourceType) {
    ContentSourceTypeNone,
    ContentSourceTypeUrl,
    ContentSourceTypeLocalHtmlFile,
    ContentSourceTypeHtmlString
};

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, readonly) ContentSourceType contentSourceType;

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithLocalHtmlFileName:(NSString *)localHtmlFileName;

@end
