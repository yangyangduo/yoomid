//
//  NotificationsViewController.m
//  private_share
//
//  Created by 曹大为 on 14-9-10.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "NotificationsViewController.h"
#import "UIColor+App.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController
{
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
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    self.title = @"消息盒子";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-24, 0, 44, 44)];
    [settingButton addTarget:self action:@selector(actionSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64:44)) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 65, self.view.bounds.size.width, 65)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 40)];
    [deleteBtn setTitle:@"立即删除" forState:UIControlStateNormal];
    deleteBtn.layer.cornerRadius = 4;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [deleteBtn setTintColor:[UIColor whiteColor]];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [deleteBtn addTarget:self action:@selector(actionDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteBtn];

}

-(void)actionDeleteClick
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)actionSettingClick
{
    
}

#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, cell.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [cell addSubview:lineView];
    }
    cell.textLabel.text = @"huode";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}
@end
