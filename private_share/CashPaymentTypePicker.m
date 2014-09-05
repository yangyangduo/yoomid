//
//  CashPaymentTypePicker.m
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CashPaymentTypePicker.h"
#import "UIColor+App.h"

@implementation CashPaymentTypePicker
{
    UITableView *tableview;
    NSArray *paymentTypeArray;
    NSInteger selectInt;
}

@synthesize delegate;

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        paymentTypeArray = [[NSArray alloc]initWithObjects:@"支付宝支付",@"微信安全支付",@"银联在线支付", nil];
        selectInt = 0;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"选择支付方式";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        [self.contentView addSubview:titleView];
        
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.contentView.bounds.size.width, 159) style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.scrollEnabled = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:tableview];
        
        UIButton *OkPaymentBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 223, self.contentView.bounds.size.width-40, 40)];
        [OkPaymentBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [OkPaymentBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
        OkPaymentBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [OkPaymentBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [OkPaymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [OkPaymentBtn addTarget:self action:@selector(actionPaymentClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:OkPaymentBtn];
    }
    return self;
}

-(void)actionPaymentClick
{
    
}

#pragma mark- uitableview delegeta
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return paymentTypeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 33, 33)];
    imageview.image = [UIImage imageNamed:@"social_sharing"];
    [cell addSubview:imageview];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 100, 25)];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = [paymentTypeArray objectAtIndex:indexPath.row];
    [cell addSubview:textLabel];
    
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(194, 3, 44, 44)];
    selectImageView.tag = 100;
    if (selectInt == indexPath.row) {
        selectImageView.image = [UIImage imageNamed:@"cb_select"];
    }
    else
    {
        selectImageView.image = [UIImage imageNamed:@"cb_unselect"];
    }
    
    [cell addSubview:selectImageView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,51.5, cell.bounds.size.width, 1.5)];
    line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
    [cell addSubview:line];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectInt = indexPath.row;
    [tableview reloadData];
}

@end
