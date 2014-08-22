//
//  RegisterCompleteViewController.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "RegisterCompleteViewController.h"
#import "DefaultStyleButton.h"
#import "DefaultStyleTextField.h"
#import "AccountService.h"
#import "AppDelegate.h"

@interface RegisterCompleteViewController ()

@end

@implementation RegisterCompleteViewController {
    NSString *_userName_;
    UITextField *verificationCodeTextField;
}

- (instancetype)initWithUserName:(NSString *)userName {
    self = [super init];
    if(self) {
        _userName_ = userName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"input_verify_code", @"");
    
    verificationCodeTextField = [[DefaultStyleTextField alloc] initWithFrame:CGRectMake(0, 25, 260, 36)];
    verificationCodeTextField.center = CGPointMake(self.view.center.x, verificationCodeTextField.center.y);
    verificationCodeTextField.layer.borderColor = [UIColor appTextFieldGray].CGColor;
    verificationCodeTextField.layer.borderWidth = 1;
    verificationCodeTextField.layer.cornerRadius = 4;
    verificationCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verificationCodeTextField.placeholder = NSLocalizedString(@"please_input_verify_code", @"");
    [self.view addSubview:verificationCodeTextField];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, verificationCodeTextField.bounds.size.height + verificationCodeTextField.frame.origin.y + 5, 230, 56)];
    tipsLabel.text = NSLocalizedString(@"verify_code_message2", @"");
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.numberOfLines = 2;
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.center = CGPointMake(self.view.center.x, tipsLabel.center.y);
    [self.view addSubview:tipsLabel];
    
    DefaultStyleButton *completeRegisterButton = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(verificationCodeTextField.frame.origin.x, tipsLabel.frame.origin.y + tipsLabel.bounds.size.height + 2, 260, 36)];
    [completeRegisterButton setTitle:NSLocalizedString(@"complete_register", @"") forState:UIControlStateNormal];
    [completeRegisterButton addTarget:self action:@selector(completeRegisterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeRegisterButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [verificationCodeTextField becomeFirstResponder];
}

- (void)completeRegisterButtonPressed:(id)sender {
    /*
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *accountService = [[AccountService alloc] init];
    [accountService registerWithUserName:_userName_ verifyCode:verificationCodeTextField.text target:self success:@selector(registerSuccess:) failure:@selector(handleFailureHttpResponse:)];
     */
}

- (void)registerSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app doAfterLoginWithUserName:_userName_ securityKey:[result objectForKey:@"securityKey"]];
        
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"register_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

@end
