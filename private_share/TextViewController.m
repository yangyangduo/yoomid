//
//  TextViewController.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TextViewController.h"
#import "DefaultStyleButton.h"

@interface TextViewController ()

@end

@implementation TextViewController {
    UITextField *textField;
    UILabel *descriptionLabel;
}

@synthesize identifier = _identifier_;
@synthesize defaultValue = _defaultValue_;
@synthesize descriptionText = _descriptionText;
@synthesize delegate = _delegate_;

- (instancetype)init {
    self = [super init];
    if(self) {
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 250, 30)];
        descriptionLabel.font = [UIFont systemFontOfSize:15.f];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:descriptionLabel];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, descriptionLabel.frame.origin.y + descriptionLabel.bounds.size.height + 15, [UIScreen mainScreen].bounds.size.width, 35)];
        textField.backgroundColor = [UIColor appSilver];
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.font = [UIFont systemFontOfSize:14.f];
        textField.textColor = [UIColor darkGrayColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:textField];
        
        UIButton *btnSubmit = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.bounds.size.height + 25, 260, 30)];
        btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
        [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnSubmit setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnSubmit];
        
        //
        textField.text = self.defaultValue == nil ? @"" : self.defaultValue;
        descriptionLabel.text = self.descriptionText == nil ? @"" : self.descriptionText;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [textField becomeFirstResponder];
}

- (void)btnSubmitPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(textViewController:didConfirmNewText:)]) {
        [self.delegate textViewController:self didConfirmNewText:textField.text];
    }
}

#pragma mark -
#pragma mark Getter and setter's

- (UITextField *)textField {
    return textField;
}

- (NSString *)value {
    return textField.text;
}

- (void)setValue:(NSString *)value {
    textField.text = value == nil ? @"" : value;
}

- (void)setDefaultValue:(NSString *)defaultValue {
    _defaultValue_ = defaultValue;
    if(_defaultValue_ == nil) {
        textField.text = @"";
    } else {
        textField.text = defaultValue;
    }
}

- (void)setDescriptionText:(NSString *)descriptionText {
    _descriptionText = descriptionText;
    descriptionLabel.text = descriptionText == nil ? @"" : descriptionText;
}

@end