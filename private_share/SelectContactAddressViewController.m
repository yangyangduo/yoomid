//
//  SelectContactAddressViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SelectContactAddressViewController.h"
#import "SelectContactAddressTableViewCell.h"
#import "ManageContactInfoViewController.h"
#import "UIImage+Color.h"

@interface SelectContactAddressViewController ()

@end

@implementation SelectContactAddressViewController
{
    NSMutableArray *contactArray;
    NSInteger fags;
}

-(instancetype)initWithContactInfo:(NSMutableArray *)contactArrays fag:(NSInteger)fag
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        contactArray = contactArrays;
        fags = fag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收获地址";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContactArray:) name:@"deleteContactArray" object:nil];
    
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
    if (fags==contactArray.count) {
        fags = 0;
    }
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
}

-(void)manageContactAddress:(id)sender
{
    ManageContactInfoViewController *add = [[ManageContactInfoViewController alloc]initWithContactInfo:contactArray];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark UITableView delegate mothed

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    SelectContactAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[SelectContactAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    NSDictionary *rowData = [contactArray objectAtIndex:indexPath.row];
    cell.rowData = rowData;
    if (indexPath.row == fags) {
        cell.selectedImageView.image = [UIImage imageNamed:@"cb_select"];
    }else {
        cell.selectedImageView.image = [UIImage imageNamed:@"cb_unselect"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    NSDictionary *rowData = [contactArray objectAtIndex:indexPath.row];
    if(rowData == nil)return 0;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    CGFloat addressLabelHeight = [[rowData objectForKey:@"deliveryAddress"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-42, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    cellHeight = 35 + addressLabelHeight + 15;
    
    return 82.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate contactInfo:[contactArray objectAtIndex:indexPath.row] fag:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

@end
