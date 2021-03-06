//
//  SelectContactAddressViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SelectContactAddressViewController.h"
#import "ManageContactInfoViewController.h"
#import "UIImage+Color.h"
#import "ConsigneeManageViewController.h"
#import "AllConsignee.h"

@interface SelectContactAddressViewController ()

@end

@implementation SelectContactAddressViewController
{
    NSMutableArray *contactArray;
    NSInteger _select;
    
    NSMutableArray *consignee;
}

-(instancetype)initWithContactInfo:(NSMutableArray *)contactArrays selected:(NSInteger)select
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        contactArray = contactArrays;
        _select = select;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContactArray:) name:@"deleteContactArray" object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64:44)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 65, self.view.bounds.size.width, 65)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIButton *manageContact = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 40)];
    [manageContact setTitle:@"管理收货地址" forState:UIControlStateNormal];
    manageContact.layer.cornerRadius = 4;
    manageContact.layer.masksToBounds = YES;
    manageContact.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [manageContact setTintColor:[UIColor whiteColor]];
    [manageContact setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [manageContact setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [manageContact addTarget:self action:@selector(manageContactAddress:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:manageContact];
}

-(void)deleteContactArray:(NSNotification*)notif
{
    contactArray = notif.object;
//    if (_select==contactArray.count) {
        _select = 0;
//    }
    [_tableView reloadData];
}

-(void)updateContactArray:(NSNotification*)notif
{
    contactArray = notif.object;
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    consignee = [[AllConsignee myAllConsignee] consignee];
    [_tableView reloadData];

}

-(void)manageContactAddress:(id)sender
{
//    ManageContactInfoViewController *add = [[ManageContactInfoViewController alloc]initWithContactInfo:contactArray];
    ConsigneeManageViewController *manage = [[ConsigneeManageViewController alloc] init];
    [self.navigationController pushViewController:manage animated:YES];
}

#pragma mark UITableView delegate mothed

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return consignee.count;
//    return contactArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    SelectContactAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[SelectContactAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    
//    cell.contact = [contactArray objectAtIndex:indexPath.row];

//    cell.consignee = [contactArray objectAtIndex:indexPath.row];
    cell.consignee = [consignee objectAtIndex:indexPath.row];


    if (indexPath.row == _select) {
        cell.selectedImageView.image = [UIImage imageNamed:@"cb_select"];
    }else {
        cell.selectedImageView.image = nil;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat cellHeight;
//    NSDictionary *rowData = [contactArray objectAtIndex:indexPath.row];
//    if(rowData == nil)return 0;
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
//    CGFloat addressLabelHeight = [[rowData objectForKey:@"deliveryAddress"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-42, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
//    cellHeight = 35 + addressLabelHeight + 15;
//    
    return 82.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate contactInfo:[contactArray objectAtIndex:indexPath.row] selectd:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[AllConsignee myAllConsignee] setCurrentConsignee:indexPath.row];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

@end
