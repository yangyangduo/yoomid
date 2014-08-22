//
//  TextViewController.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol TextViewControllerDelegate;

@interface TextViewController : BaseViewController

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, weak) id<TextViewControllerDelegate> delegate;

@end

@protocol TextViewControllerDelegate <NSObject>

- (void)textViewController:(TextViewController *)textViewController didConfirmNewText:(NSString *)newText;

@end
