//
//  ImageItem.m
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

@synthesize url = _url_;
@synthesize title = _title_;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title {
    self = [super init];
    if(self) {
        self.url = url;
        self.title = title;
    }
    return self;
}

@end
