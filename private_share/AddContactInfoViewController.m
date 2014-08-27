//
//  AddContactInfoViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AddContactInfoViewController.h"
#import "XXStringUtils.h"

@interface AddContactInfoViewController ()

@end

@implementation AddContactInfoViewController
{
    UITableView *tableview;
    NSMutableArray *textFields;
    NSMutableArray *contactArray;
    NSInteger fag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        fag = 1;
    }
    return self;
}

-(instancetype)initWithContactArray:(NSInteger)fags
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        fag = fags;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addContactAddress:)];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 200:44)) style:UITableViewStyleGrouped];
//    tableview.backgroundColor = [UIColor clearColor];

    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(0, 0, 38.5, 30)];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnMoreitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = btnMoreitem;
}

-(void)actionBack
{
    if (fag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)addContactAddress:(id)sender
{
    UITextField *name = [textFields objectAtIndex:0];
    UITextField *phoneNumber = [textFields objectAtIndex:1];
    UITextField *address = [textFields objectAtIndex:2];
    
    if ([XXStringUtils isBlank:name.text]) {
        [[XXAlertView currentAlertView] setMessage:@"请输入收货人姓名" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    else if ([XXStringUtils isBlank:phoneNumber.text])
    {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    else if ([XXStringUtils isBlank:address.text])
    {
        [[XXAlertView currentAlertView] setMessage:@"请输入详细地址" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [[XXAlertView currentAlertView] setMessage:@"正在保存..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];

    ContactService *contactSerice = [[ContactService alloc]init];
    [contactSerice addContactName:name.text phoneNumber:phoneNumber.text address:address.text target:self success:@selector(addContactSucess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)addContactSucess:(HttpResponse *)resp
{
  //  NSInteger code = resp.statusCode;
    if (resp.statusCode == 201) {
        [[XXAlertView currentAlertView] setMessage:@"保存成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        [self getContactInfo];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }

}

-(void)getContactInfo
{
    ContactService *contactService = [[ContactService alloc]init];
    [contactService getContactInfo:self success:@selector(getContactSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)getContactSuccess:(HttpResponse *)resp
{
    if(resp.statusCode == 200)
    {
        NSMutableDictionary *contactDictionary =  [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        
        for (NSDictionary *tmpDic in contactDictionary)
        {
            [contactArray addObject:tmpDic];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactArray" object:contactArray];
        
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
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"收货人姓名";
        [textField becomeFirstResponder];
    }
    else if (indexPath.row == 1)
    {
        textField.tag = 200;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"手机号码";

    }
    else if (indexPath.row == 2)
    {
        textField.tag = 300;
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"详细地址";
        
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
//    else if(200 == textField.tag)
//    {
//        UITextField *nextTextField = [textFields objectAtIndex:2];
//        [nextTextField becomeFirstResponder];
//    }
    else if(300 == textField.tag)
    {
        [self addContactAddress:nil];
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
