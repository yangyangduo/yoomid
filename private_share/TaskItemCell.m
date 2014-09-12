//
//  TaskItemCell.m
//  private_share
//
//  Created by Zhao yang on 9/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskItemCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation TaskItemCell

@synthesize imageView;
@synthesize task = _task_;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:imageView];
    }
    return self;
}

- (void)setTask:(Task *)task {
    _task_ = task;
    
    if(_task_ == nil) {
        self.imageView.image = [UIImage imageNamed:@"default_task"];
    } else {
        if(_task_.locked) {
            self.imageView.image = [UIImage imageNamed:@"locked_task"];
        } else {
            if(_task_.taskDescriptionUrl != nil && ![@"" isEqualToString:_task_.taskDescriptionUrl]) {
                [self.imageView setImageWithURL:[[NSURL alloc] initWithString:_task_.taskDescriptionUrl]];
            } else {
                self.imageView.image = [UIImage imageNamed:@"default_task"];
            }
        }
    }
}

@end
