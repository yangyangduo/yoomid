//
//  ConsigneeGanageViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/7.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ConsigneeManageViewController.h"
#import "SelectContactAddressTableViewCell.h"
#import "UpdateContactInfoViewController.h"
#import "Consignee.h"
#import "ConsigneeModifyViewController.h"
#import "ConsigneeAddViewController.h"

@implementation ConsigneeManageViewController
{
    UITableView *tableview;
    NSMutableArray *_consignee;

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"收获地址管理";
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64:44)) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 65, self.view.bounds.size.width, 65)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIButton *addContact = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-40, 40)];
    [addContact setTitle:@"新增收货地址" forState:UIControlStateNormal];
    addContact.layer.cornerRadius = 4;
    addContact.layer.masksToBounds = YES;
    addContact.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [addContact setTintColor:[UIColor whiteColor]];
    [addContact setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [addContact setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [addContact addTarget:self action:@selector(pushAddContact) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addContact];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getConsigneeInfo];
}

- (void)getConsigneeInfo{
    ContactService *contactService = [[ContactService alloc]init];
    [contactService getContactInfo:self success:@selector(getContactSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getContactSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        if(_consignee == nil) {
            _consignee = [NSMutableArray array];
        } else {
            [_consignee removeAllObjects];
        }
        NSMutableArray *_contacts_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
//        Consignee *defaultConsignee = nil;
        if(_contacts_ != nil) {
            for(int i=0; i<_contacts_.count; i++) {
                NSDictionary *contactJson = [_contacts_ objectAtIndex:i];
                Consignee *consignee = [[Consignee alloc] initWithJson:contactJson];
                [_consignee addObject:consignee];
                
            }
        }
        [tableview reloadData];
        return;
    }else{
        [self handleFailureHttpResponse:resp];
    }
}

//push 到添加收货人
-(void)pushAddContact
{
    ConsigneeAddViewController *add = [[ConsigneeAddViewController alloc] init];
    add.index = _consignee.count;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _consignee.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    //    用TableSampleIdentifier表示需要重用的单元
    SelectContactAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[SelectContactAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.selectedImageView.image = [UIImage imageNamed:@"into"];
//    cell.selectedImageView.frame = CGRectMake(cell.bounds.size.width-40-20, cell.bounds.size.height/2-20, 121.0/2, 121.0/2);
    cell.consignee = [_consignee objectAtIndex:indexPath.row];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UpdateContactInfoViewController *updateContact = [[UpdateContactInfoViewController alloc]initWithContactInfo:_consignee itmes:indexPath.row];
    ConsigneeModifyViewController *modify = [[ConsigneeModifyViewController alloc] initWithConsignee:[_consignee objectAtIndex:indexPath.row]];
//    [modify setConsignees:[_consignee objectAtIndex:indexPath.row]];
//    modify.consignee = [_consignee objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:modify animated:YES];
}

@end
