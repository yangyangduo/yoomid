//
//  SettingViewController.m
//  private_share
//
//  Created by 曹大为 on 14-9-1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SettingViewController.h"
#import "AddContactInfoViewController.h"
#import "UIDevice+ScreenSize.h"
#import "AppDelegate.h"
#import "ViewControllerAccessor.h"
#import "LoginViewController.h"
#import "UINavigationViewInitializer.h"
#import "PasswordChangeViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UIImageView *perfectinformation2;
    UITableView *tableview;
    
    NSMutableArray *userInfoArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";

    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    userInfoArray = [[NSMutableArray alloc]initWithObjects:@"忧伤的鑫",@"李四",@"1990-02-23",@"男",@"白领",@"哈佛大学", nil];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];

    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableview.bounds.size.width, 81)];
    topView.backgroundColor = [UIColor clearColor];
    tableview.tableHeaderView = topView;

    UIImageView *perfectinformation1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 34, 345/2, 35/2)];
    perfectinformation1.image = [UIImage imageNamed:@"perfectinformation1"];
    [topView addSubview:perfectinformation1];
    
     perfectinformation2 = [[UIImageView alloc]initWithFrame:CGRectMake(30+perfectinformation1.bounds.size.width, 1, 200/2, 162/2)];
    perfectinformation2.image = [UIImage imageNamed:@"perfectinformation2"];
    [topView addSubview:perfectinformation2];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableview.bounds.size.width, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    tableview.tableFooterView = bottomView;
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, -15, 143/2, 91/2)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editBtn];
    
    UIButton *exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, editBtn.bounds.size.height-15, tableview.bounds.size.width-40, 40)];
    [exitBtn setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [exitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:exitBtn];

}

-(void)editBtnClick
{
    AddContactInfoViewController *add = [[AddContactInfoViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}


-(void)exitBtnClick
{
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"being_logout", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [self performSelector:@selector(delayLogout) withObject:nil afterDelay:0.8f];

}

- (void)delayLogout {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app doAfterLogout];
    [[XXAlertView currentAlertView] dismissAlertView];

    UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
    [self.navigationController presentViewController:loginNavigationViewController animated:YES completion:^{
}];
}

#pragma mark -
#pragma mark Text view controller delegate
-(void)textViewController2:(TextViewController2 *)textViewController didConfirmNewText:(NSString *)newText
{
    if ([@"kNickName" isEqualToString:textViewController.identifier]) {
        [userInfoArray replaceObjectAtIndex:0 withObject:newText];
    }
    else if ([@"kUserName" isEqualToString:textViewController.identifier])
    {
        [userInfoArray replaceObjectAtIndex:1 withObject:newText];
    }
    else if ([@"kCompanyOrSchoolName" isEqualToString:textViewController.identifier])
    {
        [userInfoArray replaceObjectAtIndex:5 withObject:newText];
    }
    [tableview reloadData];
    [textViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark- agePickerPopupView delegate
-(void)setDate:(NSString *)date
{
    [userInfoArray replaceObjectAtIndex:2 withObject:date];
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
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, cell.bounds.size.width-30, 47)];
    [cell addSubview:bgView];

    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, bgView.bounds.size.width-30, 47)];
    textLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12,46, bgView.bounds.size.width-24, 1)];
    line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
    UIImageView *intoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(243, 0, 47, 47)];
    intoImageView.image = [UIImage imageNamed:@"into"];
    
    UIImage *bgImage = [UIImage imageNamed:@"setupbg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
    CGRect rect;
    UIImage *image;

    
    if (indexPath.row == 0) {
        textLabel.text = [NSString stringWithFormat:@"昵称:  %@",[userInfoArray objectAtIndex:indexPath.row]];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 0, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片

        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 1)
    {
        textLabel.text = [NSString stringWithFormat:@"姓名:  %@",[userInfoArray objectAtIndex:indexPath.row]];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 2)
    {
        textLabel.text = [NSString stringWithFormat:@"生日:  %@",[userInfoArray objectAtIndex:indexPath.row]];        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];

    }
    else if (indexPath.row == 3)
    {
        textLabel.text = [NSString stringWithFormat:@"性别:  %@",[userInfoArray objectAtIndex:indexPath.row]];        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 4)
    {
        textLabel.text = [NSString stringWithFormat:@"职位:  %@",[userInfoArray objectAtIndex:indexPath.row]];        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 5)
    {
        textLabel.text = [NSString stringWithFormat:@"单位/学校名称:  %@",[userInfoArray objectAtIndex:indexPath.row]];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 6)
    {
        textLabel.text = @"收货地址管理";
        textLabel.frame = CGRectMake(15, 0, 150, 47);
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 20, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];
    }
    else if (indexPath.row == 7)
    {
        textLabel.text = @"修改密码";
        textLabel.frame = CGRectMake(15, 0, 150, 47);
        [line setHidden:YES];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, 47)];
        
        rect = CGRectMake(0, 50, 97, 47);//创建矩形框
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([bgImage CGImage], rect)];//截取背景图片
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];//拉伸背景图片
        
        imageview.image = image;
        [bgView addSubview:imageview];

    }else{}
    [bgView addSubview:textLabel];
    [bgView addSubview:intoImageView];
    [bgView addSubview:line];

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
            textView.defaultValue = [userInfoArray objectAtIndex:indexPath.row];
            textView.descriptionText = @"请输入昵称:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 1:
        {
            textView.identifier = @"kUserName";
            textView.defaultValue = [userInfoArray objectAtIndex:indexPath.row];
            textView.descriptionText = @"请输入姓名:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 2:
        {
            AgePickerPopupView *agePickerPopupView = [[AgePickerPopupView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 250) date:[userInfoArray objectAtIndex:indexPath.row]];
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
            UIActionSheet *professionActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择职业:" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"白领" otherButtonTitles:@"红领", @"蓝领", nil];
            professionActionSheet.tag = 400;
            [professionActionSheet showInView:self.view];

            break;
        }
        case 5:
        {
            textView.identifier = @"kCompanyOrSchoolName";
            textView.defaultValue = [userInfoArray objectAtIndex:indexPath.row];
            textView.descriptionText = @"请输入单位/学校名称:";
            [self.navigationController pushViewController:textView animated:YES];
            break;
        }
        case 6:
        {
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
            [userInfoArray replaceObjectAtIndex:3 withObject:@"男"];
        }
        else if (buttonIndex == 1)
        {
            [userInfoArray replaceObjectAtIndex:3 withObject:@"女"];
        }
    }
    else if (actionSheet.tag == 400)
    {
        if (buttonIndex == 0) {
            [userInfoArray replaceObjectAtIndex:4 withObject:@"白领"];
        }
        else if (buttonIndex == 1)
        {
            [userInfoArray replaceObjectAtIndex:4 withObject:@"红领"];
        }
        else if (buttonIndex == 2)
        {
            [userInfoArray replaceObjectAtIndex:4 withObject:@"蓝领"];
        }
    }
    
    [tableview reloadData];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

@end
