//
//  RegisterViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "RegisterViewController.h"
#import "DefaultStyleTextField.h"
#import "DefaultStyleButton.h"
#import "RegisterCompleteViewController.h"
#import "AccountService.h"
#import "FixedTextField.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {

    NSMutableArray *textFields;
    
    UITextField *mobileTextField;
    UITextField *verifyCodeTextField;
    UITextField *passwordTextField;
    UITextField *invitationCodeTextField;
    
    UIButton *registerButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"account_register", @"");
    
//    self.view.backgroundColor = [UIColor grayColor];

    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 80, 36)];
    mobileLabel.text =@"手机号:";
    [mobileLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self.view addSubview:mobileLabel];
    mobileTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(90, 52, 155, 32)];
    mobileTextField.tag = 200;
    mobileTextField.delegate = self;
    mobileTextField.font = [UIFont systemFontOfSize:14.f];
    mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileTextField.placeholder = @"11手机号";
    mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mobileTextField];
    
    UILabel *verifyCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, mobileLabel.frame.origin.y+mobileLabel.bounds.size.height+10, 80, 36)];
    verifyCodeLabel.text = @"短信验证:";
    [verifyCodeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self.view addSubview:verifyCodeLabel];
    verifyCodeTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(90, verifyCodeLabel.frame.origin.y+2, 155, 32)];
    verifyCodeTextField.tag = 300;
    verifyCodeTextField.delegate = self;
    verifyCodeTextField.font = [UIFont systemFontOfSize:14.f];
    verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyCodeTextField.placeholder = @"短信验证";
    verifyCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    verifyCodeTextField.backgroundColor = [UIColor whiteColor];
    verifyCodeTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:verifyCodeTextField];
    UIButton *sendVerfyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendVerfyCodeButton.frame = CGRectMake(verifyCodeTextField.frame.origin.x+verifyCodeTextField.bounds.size.width+2, verifyCodeTextField.frame.origin.y+2.5, 70, 30);
    [sendVerfyCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    sendVerfyCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendVerfyCodeButton setTitleColor:[UIColor colorWithRed:0/255.f green:164/255. blue:229/255.f alpha:1.0] forState:UIControlStateNormal];
    [sendVerfyCodeButton addTarget:self action:@selector(getVerifyCodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendVerfyCodeButton];
    
    UILabel *passwordCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, verifyCodeLabel.frame.origin.y+verifyCodeLabel.bounds.size.height+10, 80, 36)];
    passwordCodeLabel.text = @"密    码:";
    [passwordCodeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self.view addSubview:passwordCodeLabel];
    passwordTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(90, passwordCodeLabel.frame.origin.y+2, 155, 32)];
    passwordTextField.tag = 400;
    passwordTextField.delegate = self;
    passwordTextField.font = [UIFont systemFontOfSize:14.f];
    passwordTextField.placeholder = @"6-16位字母+数字";
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:passwordTextField];
    UIButton *showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showPasswordButton.frame = CGRectMake(passwordTextField.frame.origin.x+passwordTextField.bounds.size.width+7, passwordTextField.frame.origin.y+2.5, 60, 30);
    [showPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
    showPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [showPasswordButton setTitleColor:[UIColor colorWithRed:0/255.f green:164/255. blue:229/255.f alpha:1.0] forState:UIControlStateNormal];
    [showPasswordButton addTarget: self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPasswordButton];

    
    UILabel *invitationCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, passwordCodeLabel.frame.origin.y+passwordCodeLabel.bounds.size.height+10, 80, 36)];
    invitationCodeLabel.text = @"邀请码:";
    [invitationCodeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self.view addSubview:invitationCodeLabel];
    invitationCodeTextField = [[DefaultStyleTextField alloc]initWithFrame:CGRectMake(90, invitationCodeLabel.frame.origin.y+2, 155, 32)];
    invitationCodeTextField.tag = 500;
    invitationCodeTextField.delegate = self;
    invitationCodeTextField.font = [UIFont systemFontOfSize:14.f];
    invitationCodeTextField.placeholder = @"6-16位字母+数字";
    invitationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    invitationCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    invitationCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    invitationCodeTextField.backgroundColor = [UIColor whiteColor];
    invitationCodeTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:invitationCodeTextField];
    
    registerButton = [[UIButton alloc]initWithFrame:CGRectMake(60, invitationCodeTextField.frame.origin.y+invitationCodeTextField.bounds.size.height+25, 200, 36)];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 4;
    registerButton.backgroundColor = [UIColor colorWithRed:0/255.f green:164/255. blue:229/255.f alpha:1.0];
    [registerButton addTarget:self action:@selector(submitNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

    CheckBox *checkBox = [CheckBox checkBoxWithPoint:CGPointMake(45, registerButton.frame.origin.y + registerButton.bounds.size.height +15)];
    checkBox.selected = YES;
    checkBox.delegate = self;
    [self.view addSubview:checkBox];
    
    UILabel *lblAgree = [[UILabel alloc] initWithFrame:CGRectMake(82, checkBox.frame.origin.y, 120, 44)];
    lblAgree.textColor = [UIColor darkGrayColor];
    lblAgree.font = [UIFont systemFontOfSize:15.f];
    lblAgree.text = NSLocalizedString(@"read_and_agree", @"");
    [self.view addSubview:lblAgree];
    
    UIButton *btnShowDisclaimer = [[UIButton alloc] initWithFrame:CGRectMake(190, checkBox.frame.origin.y, 80, 44)];
    btnShowDisclaimer.backgroundColor = [UIColor clearColor];
    [btnShowDisclaimer setTitleColor:[UIColor appColor] forState:UIControlStateNormal];
    btnShowDisclaimer.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [btnShowDisclaimer setTitle:NSLocalizedString(@"disclaimer", @"") forState:UIControlStateNormal];
    [btnShowDisclaimer addTarget:self action:@selector(btnShowDisclaimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowDisclaimer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mobileTextField resignFirstResponder];
    [verifyCodeTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [invitationCodeTextField resignFirstResponder];

}

- (void)submitNewPassword:(id)sender {
    if([XXStringUtils isBlank:mobileTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if([XXStringUtils isBlank:verifyCodeTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"input_verify_code", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if([XXStringUtils isBlank:passwordTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"new_password_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if([XXStringUtils isBlank:invitationCodeTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"invitation_code_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];
    [accountService registerWithUserName:mobileTextField.text verifyCode:verifyCodeTextField.text invitationCode:invitationCodeTextField.text password:passwordTextField.text target:self success:@selector(registerSuccess:) failure:@selector(handleFailureHttpResponse:)];
    
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(200 == textField.tag) {
        [verifyCodeTextField becomeFirstResponder];
    } else if(300 == textField.tag) {
        [passwordTextField becomeFirstResponder];
    } else if(400 == textField.tag) {
        [invitationCodeTextField becomeFirstResponder];
    } else if(500 == textField.tag) {
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

- (void) showPassword:(id)sender
{
    passwordTextField.secureTextEntry = !passwordTextField.isSecureTextEntry;
    passwordTextField.text = passwordTextField.text;
}

- (void)btnShowDisclaimerButtonPressed:(id)sender {
    
}

- (void)checkBoxValueDidChanged:(CheckBox *)checkBox {
    if(checkBox.selected) {
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerButton.enabled = YES;
    } else {
        [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        registerButton.enabled = NO;
    }
}

- (void)getVerifyCodeButtonPressed:(id)sender {
    if(mobileTextField.text.length != 11) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_invalid", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    AccountService *accountService = [[AccountService alloc] init];
    [accountService getVerifyCodeWithPhoneNumber:mobileTextField.text verifyCodeType:VerifyCodeTypeRegister target:self success:@selector(getVerifyCodeSuccess:) failure:@selector(handleFailureHttpResponse:)];
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
}

- (void)registerSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
//        UITextField *mobileTextField = [textFields objectAtIndex:0];
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app doAfterLoginWithUserName:mobileTextField.text securityKey:[result objectForKey:@"securityKey"]];
        
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"register_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

- (void)getVerifyCodeSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"verify_code_send_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

@end
