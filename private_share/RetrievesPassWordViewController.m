//
//  RetrievesPassWordViewController.m
//  private_share
//
//  Created by 曹大为 on 14/9/19.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "RetrievesPassWordViewController.h"
#import "DefaultStyleTextField.h"
#import "DefaultStyleButton.h"
#import "AccountService.h"

@interface RetrievesPassWordViewController ()

@end

@implementation RetrievesPassWordViewController
{
    UITextField *mobileTextField;
    UITextField *verifyCodeTextField;
    UITextField *passwordTextField;
    UIButton *sendVerfyCodeButton;
    
    NSInteger time;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"找回密码";
    
    mobileTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width -40, 40)];
    mobileTextField.tag = 200;
    mobileTextField.delegate = self;
    mobileTextField.font = [UIFont systemFontOfSize:14.f];
    mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileTextField.placeholder = @"11位手机号";
    mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mobileTextField];

    verifyCodeTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(20, 60, 120, 40)];
    verifyCodeTextField.tag = 300;
    verifyCodeTextField.delegate = self;
    verifyCodeTextField.font = [UIFont systemFontOfSize:14.f];
    verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyCodeTextField.placeholder = @"验证码";
    verifyCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    verifyCodeTextField.backgroundColor = [UIColor whiteColor];
    verifyCodeTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:verifyCodeTextField];
    
    sendVerfyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendVerfyCodeButton.frame = CGRectMake(verifyCodeTextField.frame.origin.x+verifyCodeTextField.bounds.size.width+10, 60, 150, 40);
    [sendVerfyCodeButton.layer setMasksToBounds:YES];
    [sendVerfyCodeButton.layer setCornerRadius:4.0];
    [sendVerfyCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    sendVerfyCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sendVerfyCodeButton.backgroundColor = [UIColor appLightBlue];
    [sendVerfyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendVerfyCodeButton addTarget:self action:@selector(getVerifyCodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendVerfyCodeButton];

    
    passwordTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(20, 110, self.view.bounds.size.width -40, 40)];
    passwordTextField.tag = 400;
    passwordTextField.delegate = self;
    passwordTextField.font = [UIFont systemFontOfSize:14.f];
    passwordTextField.placeholder = @"新密码";
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passwordTextField];
    
    UIButton *registerButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width -40, 40)];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [registerButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [registerButton setTitle:@"确  定" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(submitNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mobileTextField becomeFirstResponder];
}

- (void)getVerifyCodeButtonPressed:(id)sender
{
    if (mobileTextField.text.length != 11) {
        [[XXAlertView currentAlertView] setMessage:@"手机号码格式错误!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *service = [[AccountService alloc]init];
    
    [service getVerifyCodeWithResetPasswordPhoneNumber:mobileTextField.text target:self success:@selector(getVerifyCodeSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getVerifyCodeSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verify_code_send_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        time = 60;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

-(void)timerFired:(NSTimer *)timer{
    time--;
    [sendVerfyCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新发送",time] forState:UIControlStateNormal];
    if (time == 0) {
        [timer invalidate];
        timer = nil;
        [sendVerfyCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}

- (void)submitNewPassword:(id)sender
{
    if (mobileTextField.text.length != 11) {
        [[XXAlertView currentAlertView] setMessage:@"手机号码格式错误!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if (verifyCodeTextField.text.length == 0 ) {
        [[XXAlertView currentAlertView] setMessage:@"验证码不能为空!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if (passwordTextField.text.length < 6 ) {
        [[XXAlertView currentAlertView] setMessage:@"密码不能少于6个!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *service = [[AccountService alloc]init];
    [service resetPasswordWithUserName:mobileTextField.text verifyCode:verifyCodeTextField.text password:passwordTextField.text target:self success:@selector(resetPasswordSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)resetPasswordSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 202) {
        [[XXAlertView currentAlertView] setMessage:@"重置密码成功!" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self handleFailureHttpResponse:resp];
}


#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(200 == textField.tag) {
        [verifyCodeTextField becomeFirstResponder];
    } else if(300 == textField.tag) {
        [passwordTextField becomeFirstResponder];
    }
    else if(400 == textField.tag) {
        [self submitNewPassword:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(200 == textField.tag) {
        return range.location < 11;
    } else if(300 == textField.tag) {
        return range.location < 6;
    } else if(400 == textField.tag) {
        return range.location < 20;
    } else {
        return range.location < 8;
    }
}

@end
