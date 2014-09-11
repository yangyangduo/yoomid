//
//  LoginViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "LoginViewController.h"
#import "DefaultStyleTextField.h"
#import "DefaultStyleButton.h"
#import "RegisterViewController.h"
#import "XXAlertView.h"
#import "AccountService.h"
#import "AppDelegate.h"
#import "ViewControllerAccessor.h"
#import "UIDevice+ScreenSize.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    UIScrollView *scrollView;
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    
    BOOL keyboardIsShow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"app_name", @"");
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background_image"]];
    
    self.navigationController.delegate = self;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    [backButton addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(resignKeyBoard:)];
    [scrollView addGestureRecognizer:tapGesture];
    [self.view addSubview:scrollView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice is4InchDevice] ? 90 : 60 , 215.f / 2, 181.f / 2)];
    logoImageView.center = CGPointMake(self.view.center.x, logoImageView.center.y);
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [scrollView addSubview:logoImageView];
    
    userNameTextField = [[DefaultStyleTextField alloc] initWithFrame:CGRectMake(10, logoImageView.frame.origin.y + logoImageView.bounds.size.height + 50, 200, 30)];
    userNameTextField.center = CGPointMake(self.view.center.x, userNameTextField.center.y);
    userNameTextField.layer.borderColor = [UIColor colorWithRed:153.f / 255.f green:205.f / 255.f blue:235.f / 255.f alpha:1.0f].CGColor;
    userNameTextField.layer.borderWidth = 1;
    userNameTextField.backgroundColor = [UIColor colorWithRed:140.f / 255.f green:205.f / 255.f blue:237.f / 255.f alpha:1.f];
    userNameTextField.layer.cornerRadius = 4;
    userNameTextField.textColor = [UIColor whiteColor];
    userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"mobile", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:userNameTextField];
    
    passwordTextField = [[DefaultStyleTextField alloc] initWithFrame:CGRectMake(10, userNameTextField.frame.origin.y + userNameTextField.bounds.size.height + 20, 200, 30)];
    passwordTextField.center = CGPointMake(self.view.center.x, passwordTextField.center.y);
    passwordTextField.layer.borderColor = [UIColor colorWithRed:153.f / 255.f green:205.f / 255.f blue:235.f / 255.f alpha:1.0f].CGColor;
    passwordTextField.layer.borderWidth = 1;
    passwordTextField.layer.cornerRadius = 4;
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.backgroundColor = [UIColor colorWithRed:140.f / 255.f green:205.f / 255.f blue:237.f / 255.f alpha:1.f];
    passwordTextField.delegate = self;
    passwordTextField.returnKeyType = UIReturnKeyJoin;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"password", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    [scrollView addSubview:passwordTextField];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 20, 200, 86/2)];
    [loginButton setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
    loginButton.center = CGPointMake(self.view.center.x, loginButton.center.y);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"newlogin"] forState:UIControlStateNormal];
    [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    loginButton.layer.cornerRadius = 8;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginButton];
    
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 75, 5, 44)];
    seperatorLabel.text = @"|";
    seperatorLabel.font = [UIFont systemFontOfSize:17];
    seperatorLabel.backgroundColor = [UIColor clearColor];
    seperatorLabel.textColor = [UIColor lightTextColor];
    seperatorLabel.center = CGPointMake(self.view.center.x, seperatorLabel.center.y);
    [scrollView addSubview:seperatorLabel];
    
    UIButton *forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(seperatorLabel.frame.origin.x - 80, self.view.frame.size.height - 75, 80, 44)];
    [forgotPasswordButton setTitle:NSLocalizedString(@"forgot_password", @"") forState:UIControlStateNormal];
    forgotPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [forgotPasswordButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgotPasswordButton];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(seperatorLabel.frame.origin.x + 5, forgotPasswordButton.frame.origin.y, 80, 44)];
    registerButton.tag = 100;
    [registerButton setTitle:NSLocalizedString(@"account_register", @"") forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [registerButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(registerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if(keyboardIsShow) return;
    keyboardIsShow = YES;
    BOOL after4s = [UIScreen mainScreen].bounds.size.height > 480;
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height + rect.size.height);
    [UIView animateWithDuration:0.3f animations:^{
        scrollView.contentOffset = CGPointMake(0, after4s ? 0 : 30);
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if(!keyboardIsShow) return;
    keyboardIsShow = NO;
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3f animations:^{
        scrollView.contentOffset = CGPointMake(0, -20);
    } completion:^(BOOL finished) {
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height - rect.size.height);
    }];
}

- (void)resignKeyBoard:(UITapGestureRecognizer *)tapGestureRecognizer {
    if(userNameTextField.isFirstResponder) {
        [userNameTextField resignFirstResponder];
    } else if(passwordTextField.isFirstResponder) {
        [passwordTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginButtonPressed:textField];
    return YES;
}

- (void)loginButtonPressed:(id)sender {
    if([XXStringUtils isBlank:userNameTextField.text]
       || [XXStringUtils isBlank:passwordTextField.text])
    {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"username_password_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    AccountService *accountService = [[AccountService alloc] init];
    [accountService loginWithUserName:userNameTextField.text password:passwordTextField.text target:self success:@selector(loginSuccess:) failure:@selector(handleFailureHttpResponse:)];
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"waitting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
}

- (void)loginSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        
        // do after login
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app doAfterLoginWithUserName:userNameTextField.text securityKey:[result objectForKey:@"securityKey"]];
        
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [self.navigationController dismissViewControllerAnimated:NO completion:^{ }];
        
        return;
    }
    [self handleFailureHttpResponse:resp];
}

- (void)registerButtonPressed:(id)sender {
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
}

- (void)forgotPasswordButtonPressed:(id)sender {
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:[LoginViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
