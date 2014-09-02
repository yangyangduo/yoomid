//
//  TextViewController2.h
//  private_share
//
//  Created by 曹大为 on 14-9-2.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PanBackTransitionViewController.h"
@protocol TextViewController2Delegate;

@interface TextViewController2 : PanBackTransitionViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, weak) id<TextViewController2Delegate> delegate;

@end

@protocol TextViewController2Delegate <NSObject>

- (void)textViewController2:(TextViewController2 *)textViewController didConfirmNewText:(NSString *)newText;

@end