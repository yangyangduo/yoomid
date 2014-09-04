//
//  TextViewController2.m
//  private_share
//
//  Created by 曹大为 on 14-9-2.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TextViewController2.h"
#import "DefaultStyleButton.h"

@interface TextViewController2 ()

@end

@implementation TextViewController2
{
    UITextField *textField;
    UILabel *descriptionLabel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 250, 20)];
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
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    UIButton *btnSubmit = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(20, textField.frame.origin.y + textField.bounds.size.height + 15, self.view.bounds.size.width-40, 40)];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btnSubmit setTintColor:[UIColor whiteColor]];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [btnSubmit setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
    [btnSubmit addTarget:self action:@selector(btnSubmitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
    [self.view addSubview:btnSubmit];
    
    textField.text = self.defaultValue == nil ? @"" : self.defaultValue;
    descriptionLabel.text = self.descriptionText == nil ? @"" : self.descriptionText;

}

- (void)viewWillAppear:(BOOL)animated {
    [textField becomeFirstResponder];
}

- (void)btnSubmitPressed:(id)sender {
    if (textField.text.length == 0) {
        [[XXAlertView currentAlertView] setMessage:@"信息不能为空!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
        return;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textViewController2:didConfirmNewText:)]) {
            [self.delegate textViewController2:self didConfirmNewText:textField.text];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- textFiled delegeta
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self btnSubmitPressed:nil];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
