//
//  DynamicButton.h
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameValue.h"

@interface DynamicButton : UIButton

@property (nonatomic, strong) NameValue *nameValue;

- (instancetype)initWithFrame:(CGRect)frame nameValue:(NameValue *)nameValue;

@end
