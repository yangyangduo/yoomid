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
    UITableView *tblPasswordChange;
    NSMutableArray *textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"account_register", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(submitNewPassword:)];
    
    CGFloat y = 10;
    tblPasswordChange = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - 216 - y - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    tblPasswordChange.dataSource = self;
    tblPasswordChange.delegate = self;
    [self.view addSubview:tblPasswordChange];
    
    if([UIScreen mainScreen].bounds.size.height > 480) {
        tblPasswordChange.scrollEnabled = NO;
    }
    
    tblPasswordChange.contentOffset = CGPointMake(0, 30);
}

- (void)viewWillAppear:(BOOL)animated {
    tblPasswordChange.contentOffset = CGPointMake(0, 0);
}

- (void)submitNewPassword:(id)sender {
    if(!self.navigationItem.rightBarButtonItem.enabled) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"should_agree_disclaimer", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    UITextField *mobileTextField = [textFields objectAtIndex:0];
    UITextField *verifyCodeTextField = [textFields objectAtIndex:1];
    UITextField *passwordTextField = [textFields objectAtIndex:2];
    UITextField *invitationCodeTextField = [textFields objectAtIndex:3];
    
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
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell != nil) return cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    if(indexPath.row == 4) {
        CheckBox *checkBox = [CheckBox checkBoxWithPoint:CGPointMake(38, 0)];
        checkBox.selected = YES;
        checkBox.delegate = self;
        [cell addSubview:checkBox];
        
        UILabel *lblAgree = [[UILabel alloc] initWithFrame:CGRectMake(82, checkBox.frame.origin.y, 120, 44)];
        lblAgree.textColor = [UIColor darkGrayColor];
        lblAgree.font = [UIFont systemFontOfSize:15.f];
        lblAgree.text = NSLocalizedString(@"read_and_agree", @"");
        [cell addSubview:lblAgree];
        
        UIButton *btnShowDisclaimer = [[UIButton alloc] initWithFrame:CGRectMake(190, checkBox.frame.origin.y, 80, 44)];
        btnShowDisclaimer.backgroundColor = [UIColor clearColor];
        [btnShowDisclaimer setTitleColor:[UIColor appColor] forState:UIControlStateNormal];
        btnShowDisclaimer.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btnShowDisclaimer setTitle:NSLocalizedString(@"disclaimer", @"") forState:UIControlStateNormal];
        [btnShowDisclaimer addTarget:self action:@selector(btnShowDisclaimerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnShowDisclaimer];
        
        return cell;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FixedTextField *txtField = [[FixedTextField alloc] initWithFrame:CGRectMake(90, 5, 215, 34)];
    txtField.delegate = self;
    txtField.font = [UIFont systemFontOfSize:15.f];
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:txtField];
    
    if(textFields == nil) {
        textFields = [NSMutableArray array];
    }
    [textFields addObject:txtField];
    
    if(indexPath.row == 0) {
        txtField.tag = 200;
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"mobile", @"")];
        txtField.placeholder = NSLocalizedString(@"register_mobile_tips", @"");
        [txtField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        txtField.tag = 300;
        txtField.keyboardType = UIKeyboardTypeASCIICapable;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"verify_code", @"")];
        txtField.placeholder = NSLocalizedString(@"register_vc_tips", @"");
        
        UIButton *getVerifyCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 8, 50, 28)];
        [getVerifyCodeButton setTitle:NSLocalizedString(@"get_verify_code", @"") forState:UIControlStateNormal];
        [getVerifyCodeButton addTarget:self action:@selector(getVerifyCodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        getVerifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        getVerifyCodeButton.layer.borderWidth = 1;
        getVerifyCodeButton.layer.borderColor = [UIColor appColor].CGColor;
        getVerifyCodeButton.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
        getVerifyCodeButton.layer.cornerRadius = 8;
        [getVerifyCodeButton setTitleColor:[UIColor appColor] forState:UIControlStateNormal];
        [cell addSubview:getVerifyCodeButton];
    } else if(indexPath.row == 2) {
        txtField.tag = 400;
        CGRect frame = txtField.frame;
        frame.size.width = 160;
        txtField.frame = frame;
        txtField.secureTextEntry = YES;
        txtField.keyboardType = UIKeyboardTypeASCIICapable;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"new_password", @"")];
        txtField.placeholder = NSLocalizedString(@"register_pwd_tips", @"");
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(260, 7, 30, 30)];
        switchButton.onTintColor = [UIColor appColor];
        [switchButton addTarget:self action:@selector(switchButtonChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchButton];
    } else if(indexPath.row == 3){
        txtField.tag = 500;
        txtField.keyboardType = UIKeyboardTypeASCIICapable;
        txtField.returnKeyType = UIReturnKeyDone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"invitation_code", @"")];
        txtField.placeholder = NSLocalizedString(@"register_ic_tips", @"");
    } else {
        
    }
    return cell;
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(200 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:1];
        [nextTextField becomeFirstResponder];
    } else if(300 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:2];
        [nextTextField becomeFirstResponder];
    } else if(400 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:3];
        [nextTextField becomeFirstResponder];
    } else if(500 == textField.tag) {
        [self submitNewPassword:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(200 == textField.tag || 300 == textField.tag) {
        [tblPasswordChange scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if(400 == textField.tag || 500 == textField.tag) {
        [tblPasswordChange scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

- (void)switchButtonChanged:(UISwitch *)switchButton {
    UITextField *textField = [textFields objectAtIndex:2];
    textField.secureTextEntry = !switchButton.isOn;
    textField.text = textField.text;
}

- (void)btnShowDisclaimerButtonPressed:(id)sender {
    
}

- (void)checkBoxValueDidChanged:(CheckBox *)checkBox {
    if(checkBox.selected) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)getVerifyCodeButtonPressed:(id)sender {
    UITextField *mobileTextField = [textFields objectAtIndex:0];
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
        UITextField *mobileTextField = [textFields objectAtIndex:0];
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
