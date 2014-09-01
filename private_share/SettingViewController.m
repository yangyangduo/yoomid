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

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UIImageView *perfectinformation2;
    UITableView *tableview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    UIImageView *perfectinformation1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 22, 345/2, 35/2)];
    perfectinformation1.image = [UIImage imageNamed:@"perfectinformation1"];
    [self.view addSubview:perfectinformation1];
    
     perfectinformation2 = [[UIImageView alloc]initWithFrame:CGRectMake(30+perfectinformation1.bounds.size.width, 32, 200/2, 162/2)];
    perfectinformation2.image = [UIImage imageNamed:@"perfectinformation2"];
    [self.navigationController.navigationBar addSubview:perfectinformation2];

    UIImage *bgImage = [UIImage imageNamed:@"setupbg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    bgImage = [bgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 81-12, self.view.bounds.size.width-30, [UIDevice is4InchDevice] ? 330 :250)];
    bgImageView.image = bgImage;
    [self.view addSubview:bgImageView];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(35, bgImageView.frame.origin.y+2, bgImageView.bounds.size.width-40, [UIDevice is4InchDevice] ? 326 :246) style:UITableViewStyleGrouped];
    tableview.scrollEnabled = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];

    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, bgImageView.frame.origin.y + bgImageView.bounds.size.height, 143/2, 91/2)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    UIButton *exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, editBtn.frame.origin.y + editBtn.bounds.size.height, self.view.bounds.size.width-40, 40)];
    [exitBtn setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [exitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [perfectinformation2 setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [perfectinformation2 setHidden:YES];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    cell.backgroundColor = [UIColor grayColor];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.bounds.size.width-10, [UIDevice is4InchDevice] ? 46.5 : 35.1)];
    textLabel.font = [UIFont systemFontOfSize:14];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, [UIDevice is4InchDevice] ? 45.5 : 34.1, cell.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
    [cell addSubview:line];
    
    if (indexPath.row == 0) {
        textLabel.text = @"昵称: 忧伤的鑫";
    }
    else if (indexPath.row == 1)
    {
        textLabel.text = @"姓名: 张三";
    }
    else if (indexPath.row == 2)
    {
        textLabel.text = [NSString stringWithFormat:@"年龄: %@             性别: %@",@"24",@"男"];
    }
    else if (indexPath.row == 3)
    {
        textLabel.text = @"职业: 总裁";
    }
    else if (indexPath.row == 4)
    {
        textLabel.text = @"单位/学校名称: 哈佛大学";
    }
    else if (indexPath.row == 5)
    {
        textLabel.text = @"收货地址管理:";
        textLabel.frame = CGRectMake(5, 0, 150, [UIDevice is4InchDevice] ? 47 : 35.7);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 6)
    {
        textLabel.text = @"修改密码:";
        textLabel.frame = CGRectMake(5, 0, 150, [UIDevice is4InchDevice] ? 47 : 35.7);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [line setHidden:YES];
    }else{}

    [cell addSubview:textLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIDevice is4InchDevice] ? 46.5 : 35.7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
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
