//
//  ConsigneeModifyViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/7.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ConsigneeModifyViewController.h"
#import "ContactService.h"

@implementation ConsigneeModifyViewController
{
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *addressTextField;
    
    UIView *bottomView;
    
    Consignee *_consignee_;
}

- (instancetype)initWithConsignee:(Consignee *)consignee
{
    self = [super init];
    if (self) {
        _consignee_ = consignee;
        
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
        
        if (_consignee_ == nil) {
            nameTextField.text = @"";
            phoneTextField.text = @"";
            addressTextField.text = @"";
            bottomView.hidden = YES;
        }else{
            if ([_consignee_.isDefault isEqualToString:@"1"]) {
                bottomView.hidden = YES;
            }else{
                bottomView.hidden = NO;
            }
            nameTextField.text = _consignee_.name;
            phoneTextField.text = _consignee_.phoneNumber;
            addressTextField.text = _consignee_.address;
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改收货地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(updateContactAddress:)];
    
    //**********************
//    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.5)];
//    line4.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
//    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, self.view.bounds.size.width, 0.5)];
//    line5.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
    UIView *deleteConsigneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, 45)];
    deleteConsigneeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:deleteConsigneeView];
//    [deleteConsigneeLabel addSubview:line4];
//    [deleteConsigneeLabel addSubview:line5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [deleteConsigneeView addGestureRecognizer:tapGesture];
    
    UILabel *deleteConsigneeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, deleteConsigneeView.bounds.size.width, deleteConsigneeView.bounds.size.height)];
    deleteConsigneeLabel.text = @"删除收获地址";
    deleteConsigneeLabel.textAlignment = NSTextAlignmentCenter;
    deleteConsigneeLabel.textColor = [UIColor redColor];
    [deleteConsigneeView addSubview:deleteConsigneeLabel];
    
    //
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-64-50, self.view.bounds.size.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *defauleConsigneeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defauleConsigneeBtn.frame = CGRectMake(self.view.bounds.size.width/2 - 80, 10, 160, 30);
    [defauleConsigneeBtn.layer setMasksToBounds:YES];
    [defauleConsigneeBtn.layer setCornerRadius:6.0];
    [defauleConsigneeBtn setTitle:@"设成默认收货地址" forState:UIControlStateNormal];
    defauleConsigneeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    defauleConsigneeBtn.backgroundColor = [UIColor appLightBlue];
    [defauleConsigneeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [defauleConsigneeBtn addTarget:self action:@selector(setdefauleConsignee:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:defauleConsigneeBtn];

}

//设置成默认收货地址
-(void)setdefauleConsignee:(id)sender
{
    if (_consignee_ == nil) {
        return;
    }
    [[XXAlertView currentAlertView] setMessage:@"正在操作..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
    ContactService *contactService = [[ContactService alloc]init];
    [contactService setDefauleContact:_consignee_.identifier target:self success:@selector(setDefauleContactSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)setDefauleContactSuccess:(HttpResponse *)resp
{
    if(resp.statusCode == 200)
    {
        [[XXAlertView currentAlertView] setMessage:@"设置成功" forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }else{
        [self handleFailureHttpResponse:resp];
    }
}

//删除收货地址
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (_consignee_ == nil) {
        return;
    }
    [[XXAlertView currentAlertView] setMessage:@"正在删除..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];

    ContactService *contactService = [[ContactService alloc]init];
    [contactService deleteContactInfo:_consignee_.identifier target:self success:@selector(deleteSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)deleteSuccess:(HttpResponse *)resp
{
    if(resp.statusCode == 200)
    {
        [[XXAlertView currentAlertView] setMessage:@"删除成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

//修改 收获地址
-(void)updateContactAddress:(id)sender
{
    if (_consignee_ == nil) {
        return;
    }
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
    [[XXAlertView currentAlertView] setMessage:@"正在修改..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    ContactService *contactSerice = [[ContactService alloc]init];
    [contactSerice updateContactInfo:_consignee_.identifier name:nameTextField.text phoneNumber:phoneTextField.text address:addressTextField.text target:self success:@selector(updateContactSucess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)updateContactSucess:(HttpResponse *)resp
{
    if (resp.statusCode == 200) {
        
        [[XXAlertView currentAlertView] setMessage:@"修改成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

@end
