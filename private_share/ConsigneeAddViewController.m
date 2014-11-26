//
//  ConsigneeAddViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/9.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ConsigneeAddViewController.h"
#import "ContactService.h"
#import "AllConsignee.h"

@implementation ConsigneeAddViewController
{
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *addressTextField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.index = 1;
    
    self.title = @"增加收货地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addContactAddress:)];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, self.view.bounds.size.width, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, self.view.bounds.size.width, 0.5)];
    line2.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, self.view.bounds.size.width, 0.5)];
    line3.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [bgView1 addSubview:line1];
    [self.view addSubview:bgView1];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 70, 40)];
    labelName.text = @"收货人";
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.font = [UIFont systemFontOfSize:13.f];
    [bgView1 addSubview:labelName];
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 2, self.view.bounds.size.width - 90, 40)];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.font = [UIFont systemFontOfSize:14.f];
    nameTextField.textAlignment = NSTextAlignmentLeft;
    [nameTextField becomeFirstResponder];
    [bgView1 addSubview:nameTextField];
    
    //**************
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, 45)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [bgView2 addSubview:line2];
    [self.view addSubview:bgView2];
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 80, 40)];
    labelPhone.text = @"手机号码";
    labelPhone.textAlignment = NSTextAlignmentLeft;
    labelPhone.font = [UIFont systemFontOfSize:13.f];
    [bgView2 addSubview:labelPhone];
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 2, self.view.bounds.size.width - 90, 40)];
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.font = [UIFont systemFontOfSize:14.f];
    phoneTextField.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:phoneTextField];
    
    //***********
    UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, self.view.bounds.size.width, 45)];
    bgView3.backgroundColor = [UIColor whiteColor];
    [bgView3 addSubview:line3];
    [self.view addSubview:bgView3];
    
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 80, 40)];
    labelAddress.text = @"详细地址";
    labelAddress.textAlignment = NSTextAlignmentLeft;
    labelAddress.font = [UIFont systemFontOfSize:13.f];
    [bgView3 addSubview:labelAddress];
    addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 2, self.view.bounds.size.width - 90, 40)];
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.font = [UIFont systemFontOfSize:14.f];
    addressTextField.textAlignment = NSTextAlignmentLeft;
    [bgView3 addSubview:addressTextField];
}

-(void)addContactAddress:(id)sender
{
    if ([XXStringUtils isBlank:nameTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:@"请输入收货人姓名" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    else if ([XXStringUtils isBlank:phoneTextField.text])
    {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    else if ([XXStringUtils isBlank:addressTextField.text])
    {
        [[XXAlertView currentAlertView] setMessage:@"请输入详细地址" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[XXAlertView currentAlertView] setMessage:@"正在保存..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    NSString *isDefaule = nil;
    if (self.index == 0) {
        isDefaule = @"1";
    }else{
        isDefaule = @"0";
    }
    
    ContactService *contactSerice = [[ContactService alloc]init];
    [contactSerice addContactIsDefaule:isDefaule name:nameTextField.text phoneNumber:phoneTextField.text address:addressTextField.text target:self success:@selector(addContactSucess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)addContactSucess:(HttpResponse *)resp
{
    if (resp.statusCode == 201) {
        [[AllConsignee myAllConsignee] getContact];
        [[XXAlertView currentAlertView] setMessage:@"保存成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [self performSelector:@selector(closeViewController) withObject:nil afterDelay:1.0f];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
    
}

- (void)closeViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
