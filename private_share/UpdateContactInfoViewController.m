//
//  UpdateContactInfoViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-15.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UpdateContactInfoViewController.h"
#import "Contact.h"
#import "DiskCacheManager.h"

@interface UpdateContactInfoViewController ()

@end

@implementation UpdateContactInfoViewController
{
    UITableView *tableview;
    NSMutableArray *textFields;
    Contact *contact;
    
    NSMutableArray *contactArray;
    NSInteger items;
}

-(instancetype)initWithContactInfo:(NSMutableArray *)array itmes:(NSInteger)item
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        contactArray = array;
        items = item;
        contact = [contactArray objectAtIndex:item];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(updateContactAddress:)];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64:44)) style:UITableViewStyleGrouped];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
}

-(void)updateContactAddress:(id)sender
{
    UITextField *nameTextField = [textFields objectAtIndex:0];
    UITextField *phoneNumberTextField = [textFields objectAtIndex:1];
    UITextField *addressTextField = [textFields objectAtIndex:2];
    
    if ([XXStringUtils isBlank:nameTextField.text]) {
        [[XXAlertView currentAlertView] setMessage:@"请输入收货人姓名" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    else if ([XXStringUtils isBlank:phoneNumberTextField.text])
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
    [contactSerice updateContactInfo:contact.identifier name:nameTextField.text phoneNumber:phoneNumberTextField.text address:addressTextField.text target:self success:@selector(updateContactSucess:) failure:@selector(handleFailureHttpResponse:)];
    
//    NSDictionary *tempD = [[NSDictionary alloc]initWithObjectsAndKeys:phoneNumberTextField.text,@"contactPhone",addressTextField.text,@"deliveryAddress",contact.identifier,@"id",nameTextField.text,@"name",contact.isDefault,@"default", nil];
    
    Contact *updateContact = [[Contact alloc]init];
    updateContact.identifier = contact.identifier;
    updateContact.name = nameTextField.text;
    updateContact.phoneNumber = phoneNumberTextField.text;
    updateContact.address = addressTextField.text;
    updateContact.isDefault = contact.isDefault;
    [contactArray replaceObjectAtIndex:items withObject:updateContact];
}

-(void)updateContactSucess:(HttpResponse *)resp
{
//      NSInteger code = resp.statusCode;
    if (resp.statusCode == 200) {

        [[XXAlertView currentAlertView] setMessage:@"修改成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactArray" object:contactArray];
        [[DiskCacheManager manager] setContacts:contactArray];

        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, cell.bounds.size.width-20, 50.f)];
    
    if(textFields == nil) {
        textFields = [NSMutableArray array];
    }
    [textFields addObject:textField];
    
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:15.f];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:textField];
    
    if (indexPath.row == 0) {
        textField.tag = 100;
//        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"收货人姓名";
        textField.text = contact.name;
        [textField becomeFirstResponder];
    }
    else if (indexPath.row == 1)
    {
        textField.tag = 200;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"手机号码";
        textField.text = contact.phoneNumber;

    }
    else if (indexPath.row == 2)
    {
        textField.tag = 300;
//        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"详细地址";
        textField.text = contact.address;

    }else{}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(100 == textField.tag)
    {
        UITextField *nextTextField = [textFields objectAtIndex:1];
        [nextTextField becomeFirstResponder];
    }
    else if(300 == textField.tag)
    {
        [self updateContactAddress:nil];
    }
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
