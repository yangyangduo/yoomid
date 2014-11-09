//
//  AdPlatformPickerView.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AdPlatformPickerView.h"
#import "UIColor+App.h"

@implementation AdPlatformPickerView {
}

@synthesize delegate;

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
    }
    return self;
}

- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(categoryButtonItemDidSelectedWithIdentifier:)]) {
        [self.delegate categoryButtonItemDidSelectedWithIdentifier:identifier];
    }
}

@end
