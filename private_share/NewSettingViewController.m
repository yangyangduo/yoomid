//
//  NewSettingViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/6.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "NewSettingViewController.h"
#import "SettingViewController.h"
#import "UINavigationViewInitializer.h"
#import "AppDelegate.h"
#import "ViewControllerAccessor.h"
#import "LoginViewController.h"
#import "PasswordChangeViewController.h"
#import "MerchandiseOrdersViewController.h"
#import "ManageContactInfoViewController.h"
#import "DiskCacheManager.h"
#import "ConsigneeManageViewController.h"

@implementation NewSettingViewController
{
    UITableView *tableview;
    
    NSArray *_items;
    NSMutableArray *contacts;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    
    _items = @[@[@"资料管理"],@[@"我的订单", @"收获地址管理"],@[ @"修改密码", @"关于有米得"]];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];

    UIButton *exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, 350, tableview.bounds.size.width-40, 40)];
    [exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [exitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tableview addSubview:exitBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getContactInfo];
}

- (void)exitBtnClick
{
    [[XXAlertView currentAlertView] setMessage:@"正在退出..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [self performSelector:@selector(delayLogout) withObject:nil afterDelay:0.6f];
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
        [[DiskCacheManager manager] setContacts:contacts];
    } else {
        [self handleFailureHttpResponse:resp];
    }
}


- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)delayLogout {
    
    [self dismissViewControllerAnimated:NO completion:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app doAfterLogout];
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        //.homeViewController
        [[ViewControllerAccessor defaultAccessor].homePageViewController presentViewController:loginNavigationViewController animated:YES completion:^{
            [self dismissViewController];
            
        }];
        [[XXAlertView currentAlertView] setMessage:@"已退出" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
    }];
}


#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_items objectAtIndex:section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor redColor];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 45);
    }
    
    NSArray *array = [_items objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

//section头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {//资料管理
        case 0:
        {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
            [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
            [self rightPresentViewController:navigationController animated:YES];
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {//我的订单
                [self.navigationController pushViewController:[[MerchandiseOrdersViewController alloc] init] animated:YES];
            }else  //收获地址管理
            {
//                [self.navigationController pushViewController:[[ManageContactInfoViewController alloc] initWithContactInfo:contacts] animated:YES];
                [self.navigationController pushViewController:[[ConsigneeManageViewController alloc] init] animated:YES];
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) { //修改密码
                [self.navigationController pushViewController:[[PasswordChangeViewController alloc] init] animated:YES];
            }else  //关于有米得
            {
                
            }
        }
            break;
        default:
            break;
    }
}

@end
