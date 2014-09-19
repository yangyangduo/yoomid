//
//  YoomidRectModalView1.m
//  private_share
//
//  Created by 曹大为 on 14/9/20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "YoomidRectModalView1.h"
#import "UIColor+App.h"

@implementation YoomidRectModalView1

- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex {
    self = [super initWithSize:size image:image message:message buttonTitles:buttonTitles cancelButtonIndex:cancelButtonIndex];
    if(self) {
    }
    return self;
}

- (void)closeViewInternal {
    if (self.taskListVC != nil) {
        [self.taskListVC dismissViewControllerAnimated:YES completion:nil];
        [self closeViewAnimated:YES completion:nil];
    }
}
@end
