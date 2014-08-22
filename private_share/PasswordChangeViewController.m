//
//  PasswordChangeViewController.m
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PasswordChangeViewController.h"
#import "FixedTextField.h"
#import "AccountService.h"

@implementation PasswordChangeViewController {
    UITableView *tblPasswordChange;
    NSMutableArray *textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"password_modify", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(submitNewPassword:)];
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height > 480 ? 30 : 14;
    tblPasswordChange = [[UITableView alloc] initWithFrame:
                         CGRectMake(0, y, self.view.bounds.size.width, 44 * 3) style:UITableViewStylePlain];
    tblPasswordChange.dataSource = self;
    tblPasswordChange.delegate = self;
    tblPasswordChange.scrollEnabled = NO;
    [self.view addSubview:tblPasswordChange];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, y == 14 ? 145 : 170, 280, 54)];
    lblTips.numberOfLines = 2;
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.font = [UIFont systemFontOfSize:13.f];
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.text = NSLocalizedString(@"password_tips", @"");
    [self.view addSubview:lblTips];
}

- (void)submitNewPassword:(id)sender {
    UITextField *oldTextField = [textFields objectAtIndex:0];
    UITextField *newTextField = [textFields objectAtIndex:1];
    UITextField *confirmTextField = [textFields objectAtIndex:2];
    
    if([XXStringUtils isBlank:oldTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if([XXStringUtils isBlank:newTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"new_password_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if(![newTextField.text isEqualToString:confirmTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"confirm_password_invalid", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *service = [[AccountService alloc] init];
    [service updatePasswordWithUserName:[GlobalConfig defaultConfig].userName oldPassword:oldTextField.text newPassword:newTextField.text target:self success:@selector(updatePasswordSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)updatePasswordSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 202) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"modify_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

- (void)handleFailureHttpResponse:(HttpResponse *)resp {
    [super handleFailureHttpResponse:resp];
    
}

#pragma mark -
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FixedTextField *txtField = [[FixedTextField alloc] initWithFrame:CGRectMake(90, 5, 215, 34)];
    txtField.delegate = self;
    txtField.font = [UIFont systemFontOfSize:15.f];
    txtField.secureTextEntry = YES;
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:txtField];
    
    if(textFields == nil) {
        textFields = [NSMutableArray array];
    }
    [textFields addObject:txtField];
    
    if(indexPath.row == 0) {
        txtField.tag = 200;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = NSLocalizedString(@"old_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_old_password", @"");
        [txtField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        txtField.tag = 300;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = NSLocalizedString(@"new_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_new_password", @"");
    } else {
        txtField.tag = 400;
        txtField.returnKeyType = UIReturnKeyDone;
        cell.textLabel.text = NSLocalizedString(@"confirm_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_password_again", @"");
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
    } else {
        [self submitNewPassword:textField];
    }
    return YES;
}

@end
