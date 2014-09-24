//
//  SettingViewController.m
//  private_share
//
//  Created by 曹大为 on 14-9-1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SettingViewController.h"
#import "UIDevice+ScreenSize.h"
#import "AppDelegate.h"
#import "ViewControllerAccessor.h"
#import "LoginViewController.h"
#import "UINavigationViewInitializer.h"
#import "PasswordChangeViewController.h"
#import "UIColor+App.h"
#import "UserInfoService.h"
#import "DiskCacheManager.h"
#import "ContactService.h"
#import "ManageContactInfoViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UIImageView *perfectinformation2;
    UITableView *tableview;
    
    NSMutableDictionary *userInfoDictionary;
    NSMutableDictionary *accountInfoDictionary;
    NSMutableArray *contacts;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";

    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContactArray:) name:@"deleteContactArray" object:nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-44, 0, 44, 44)];
    [saveButton addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [saveButton setTitleColor:[UIColor appLightBlue] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];

    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];

    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableview.bounds.size.width, 81)];
    topView.backgroundColor = [UIColor clearColor];
    tableview.tableHeaderView = topView;

    UIImageView *perfectinformation1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 36, 345/2, 35/2)];
    perfectinformation1.image = [UIImage imageNamed:@"perfectinformation1"];
    [topView addSubview:perfectinformation1];
    
     perfectinformation2 = [[UIImageView alloc]initWithFrame:CGRectMake(30+perfectinformation1.bounds.size.width, 3, 200/2, 162/2)];
    perfectinformation2.image = [UIImage imageNamed:@"perfectinformation2"];
    [topView addSubview:perfectinformation2];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableview.bounds.size.width, 60)];
    bottomView.backgroundColor = [UIColor clearColor];
    tableview.tableFooterView = bottomView;
    
    UIButton *exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, 15, tableview.bounds.size.width-40, 40)];
    [exitBtn setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [exitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:exitBtn];

    [self getUserInfo];
    [self mayGetContactInfo];
}

-(void)deleteContactArray:(NSNotification*)notif
{
    contacts = notif.object;
}

-(void)updateContactArray:(NSNotification*)notif
{
    contacts = notif.object;
}

- (void)mayGetContactInfo {
    BOOL isExpired;
    NSArray *_contacts_ = [[DiskCacheManager manager] contacts:&isExpired];
    
    if(_contacts_ != nil) {
        contacts = [NSMutableArray arrayWithArray:_contacts_];
    }
    
    if(isExpired || _contacts_ == nil) {
        [self getContactInfo];
    }
}

- (void)getContactInfo {
    ContactService *contactService = [[ContactService alloc]init];
    [contactService getContactInfo:self success:@selector(getContactSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getContactSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        
        if(contacts == nil) {
            contacts = [NSMutableArray array];
        } else {
            [contacts removeAllObjects];
        }
        
        NSMutableArray *_contacts_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_contacts_ != nil) {
            for(int i=0; i<_contacts_.count; i++) {
                NSDictionary *contactJson = [_contacts_ objectAtIndex:i];
                Contact *contact = [[Contact alloc] initWithJson:contactJson];
                if (i == 0) {
                    contact.isDefault = YES;
                }
                else
                {
                    contact.isDefault = NO;
                }
                [contacts addObject:contact];
            }
        }
        
        //
        [[DiskCacheManager manager] setContacts:contacts];
    } else {
        [self handleFailureHttpResponse:resp];
    }
}

-(void)getUserInfo
{
    UserInfoService *service = [[UserInfoService alloc]init];
    [service getUserInfo:self success:@selector(getUserInfoSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)getUserInfoSuccess:(HttpResponse *)resp
{
    if(userInfoDictionary == nil) {
        userInfoDictionary = [NSMutableDictionary dictionary];
    }
    if (accountInfoDictionary == nil) {
        accountInfoDictionary = [NSMutableDictionary dictionary];
    }
    
    if (resp.statusCode == 200) {
        NSDictionary *_jsonDicti = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_jsonDicti != nil) {
            NSDictionary *userDetail = [_jsonDicti dictionaryForKey:@"detail"];
            NSDictionary *accountInfo = [_jsonDicti dictionaryForKey:@"accountInfo"];

            if (accountInfo != nil) {
                accountInfoDictionary = [NSMutableDictionary dictionaryWithDictionary:accountInfo];
            }
            if(userDetail != nil) {
                userInfoDictionary = [NSMutableDictionary dictionaryWithDictionary:userDetail];
                [tableview reloadData];
            }
        }
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

-(void)saveBtnClick
{
    NSDictionary *tempD = [[NSDictionary alloc]initWithObjectsAndKeys:accountInfoDictionary,@"accountInfo",userInfoDictionary,@"detail", nil];
    NSData *body = [JsonUtil createJsonDataFromDictionary:tempD];
    
    [[XXAlertView currentAlertView] setMessage:@"正在保存..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    UserInfoService *service = [[UserInfoService alloc]init];
    [service modifyUserInfoData:body target:self success:@selector(modifyUserInfoSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)modifyUserInfoSuccess:(HttpResponse *)resp
{
    if (resp.statusCode == 200) {
        [[XXAlertView currentAlertView] setMessage:@"保存成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

- (void)exitBtnClick {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"being_logout", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [self performSelector:@selector(delayLogout) withObject:nil afterDelay:0.6f];
}

- (void)delayLogout {

    [self dismissViewControllerAnimated:NO completion:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app doAfterLogout];
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [[ViewControllerAccessor defaultAccessor].homeViewController presentViewController:loginNavigationViewController animated:YES completion:^{
            [self dismissViewController];

        }];
        [[XXAlertView currentAlertView] setMessage:@"已退出" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
    }];
}

#pragma mark -
#pragma mark Text view controller delegate
-(void)textViewController2:(TextViewController2 *)textViewController didConfirmNewText:(NSString *)newText
{
    if ([@"kNickName" isEqualToString:textViewController.identifier]) {
        [userInfoDictionary setObject:newText forKey:@"nickName"];
    }
    else if ([@"kUserName" isEqualToString:textViewController.identifier])
    {
        [userInfoDictionary setObject:newText forKey:@"realName"];
    }
    else if ([@"kCompanyOrSchoolName" isEqualToString:textViewController.identifier])
    {
        [userInfoDictionary setObject:newText forKey:@"company"];
    }
    [tableview reloadData];
    [textViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark- PickerPopupView delegate
-(void)setDate:(NSString *)date
{
    [userInfoDictionary setObject:date forKey:@"birthday"];
    [tableview reloadData];
}

-(void)setProfession:(NSString *)profession
{
    [userInfoDictionary setObject:profession forKey:@"position"];
    [tableview reloadData];
}

#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, cell.bounds.size.width-30, 47)];
        bgView.tag = 100;
        [cell addSubview:bgView];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, bgView.bounds.size.width-30, 47)];
        textLabel.tag = 200;
        textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12,46, bgView.bounds.size.width-24, 1)];
        line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
        UIImageView *intoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(243, 0, 47, 47)];
        line.tag = 300;
        intoImageView.image = [UIImage imageNamed:@"into"];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width-30, 47)];
        imageview.tag = 400;
        [bgView addSubview:imageview];
        [bgView addSubview:textLabel];
        [bgView addSubview:intoImageView];
        [bgView addSubview:line];
    }
    
    UIImage *bgImage = [UIImage imageNamed:@"setupbg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);

    CGRect rect;
    UIImage *image;

    UIImageView *imageview = (UIImageView *)[cell viewWithTag:400];
    if (indexPath.row == 0) {

        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"nickName"] == nil ? @"昵称:" : [NSString stringWithFormat:@"昵称:  %@",[userInfoDictionary objectForKey:@"nickName"]];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);

        rect = CGRectMake(0, 0, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片

        imageview.image = image;
    }
    else if (indexPath.row == 1)
    {
        if ([userInfoDictionary objectForKey:@"realName"] == nil) {
            NSLog(@"字典:%@,姓名:%@ll",userInfoDictionary,[userInfoDictionary objectForKey:@"realName"]);
        }
        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"realName"] == nil ? @"姓名:" :[NSString stringWithFormat:@"姓名:  %@",[userInfoDictionary objectForKey:@"realName"]];
        
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 2)
    {
        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"birthday"] == nil ? @"生日:" : [NSString stringWithFormat:@"生日:  %@",[userInfoDictionary objectForKey:@"birthday"]];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);

        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 3)
    {
        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"sex"] == nil ? @"性别:" : [NSString stringWithFormat:@"性别:  %@",[userInfoDictionary objectForKey:@"sex"]];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 4)
    {
        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"position"] == nil ? @"职位:" : [NSString stringWithFormat:@"职位:  %@",[userInfoDictionary objectForKey:@"position"]];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 5)
    {
        ((UILabel *)[cell viewWithTag:200]).text = [userInfoDictionary objectForKey:@"company"] == nil ? @"单位/学校名称:" : [NSString stringWithFormat:@"单位/学校名称:  %@",[userInfoDictionary objectForKey:@"company"]];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 6)
    {
        ((UILabel *)[cell viewWithTag:200]).text = @"收货地址管理";
        ((UILabel *)[cell viewWithTag:200]).frame = CGRectMake(15, 0, 150, 47);
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }
    else if (indexPath.row == 7)
    {
        ((UILabel *)[cell viewWithTag:200]).text = @"修改密码";
        ((UILabel *)[cell viewWithTag:200]).frame = CGRectMake(15, 0, 150, 47);
        [(UIView *)[cell viewWithTag:300] setHidden:YES];
        imageview.frame = CGRectMake(0, 0, cell.bounds.size.width-30, 47);
        
        rect = CGRectMake(0, 50, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
    }else{}

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextViewController2 *textView = [[TextViewController2 alloc]init];
    textView.title = @"用户信息修改";
    textView.delegate = self;
    
    switch (indexPath.row) {
        case 0:
        {
            textView.identifier = @"kNickName";
            textView.defaultValue = [userInfoDictionary objectForKey:@"nickName"];
            textView.descriptionText = @"请输入昵称:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 1:
        {
            textView.identifier = @"kUserName";
            textView.defaultValue = [userInfoDictionary objectForKey:@"realName"];
            textView.descriptionText = @"请输入姓名:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 2:
        {
            PickerPopupView *agePickerPopupView = [[PickerPopupView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 250) date:[userInfoDictionary objectForKey:@"birthday"] == nil ? nil :[userInfoDictionary objectForKey:@"birthday"]];
            agePickerPopupView.delegate = self;
            [agePickerPopupView showInView:self.navigationController.view];
            break;
        }
        case 3:
        {
            UIActionSheet *sexActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别:" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
            sexActionSheet.tag = 300;
            [sexActionSheet showInView:self.view];
            break;
        }
        case 4:
        {
            PickerPopupView *professionPickerPopupView = [[PickerPopupView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) profession:[userInfoDictionary objectForKey:@"position"]];
            professionPickerPopupView.delegate = self;
            [professionPickerPopupView showInView:self.navigationController.view];
            break;
        }
        case 5:
        {
            textView.identifier = @"kCompanyOrSchoolName";
            textView.defaultValue = [userInfoDictionary objectForKey:@"company"];
            textView.descriptionText = @"请输入单位/学校名称:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 6:
        {
            [self.navigationController pushViewController:[[ManageContactInfoViewController alloc] initWithContactInfo:contacts] animated:YES];
            break;
        }
        case 7:
        {
            [self.navigationController pushViewController:[[PasswordChangeViewController alloc] init] animated:YES];
            break;
        }
    
        default:
            break;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

#pragma mark-
#pragma uiactionsheet delegeta
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 300) {
        if (buttonIndex == 0) {
            [userInfoDictionary setObject:@"男" forKey:@"sex"];
        }
        else if (buttonIndex == 1)
        {
            [userInfoDictionary setObject:@"女" forKey:@"sex"];
        }
    }
    [tableview reloadData];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor appLightBlue] forState:UIControlStateNormal];
        }
    }
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

@end
