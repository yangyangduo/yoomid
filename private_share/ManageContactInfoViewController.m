//
//  ManageContactInfoViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ManageContactInfoViewController.h"
#import "UIImage+Color.h"
#import "SelectContactAddressTableViewCell.h"
#import "AddContactInfoViewController.h"
#import "UpdateContactInfoViewController.h"

@interface ManageContactInfoViewController ()

@end

@implementation ManageContactInfoViewController
{
    UITableView *tableview;
    NSMutableArray *contactArray;
}

-(instancetype)initWithContactInfo:(NSMutableArray *)contactArrays
{
    self = [super init];
    if (self) {
        contactArray = [[NSMutableArray alloc]init];
        contactArray = contactArrays;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"管理收货地址";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tableview setEditing:NO];
}

-(void)updateContactArray:(NSNotification*)notif
{
    contactArray = notif.object;
    [tableview reloadData];
}

-(void)deleteSuccess:(HttpResponse *)resp
{
    if(resp.statusCode == 200)
    {
        [[XXAlertView currentAlertView] setMessage:@"删除成功" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];

        [tableview reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteContactArray" object:contactArray];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

-(void)pushAddContact
{
    AddContactInfoViewController *addContact = [[AddContactInfoViewController alloc]init];
    [self.navigationController pushViewController:addContact animated:YES];
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
    return contactArray.count;
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
    cell.selectedImageView.frame = CGRectMake(cell.bounds.size.width-40-20, cell.bounds.size.height/2-20, 121.0/2, 121.0/2);
    cell.contact = [contactArray objectAtIndex:indexPath.row];
    
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
    
    UpdateContactInfoViewController *updateContact = [[UpdateContactInfoViewController alloc]initWithContactInfo:contactArray itmes:indexPath.row];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:updateContact animated:YES];
}

//右滑出现del按钮
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据....
        NSDictionary *rowData = [contactArray objectAtIndex:indexPath.row];
        
        ContactService *contactService = [[ContactService alloc]init];
        [contactService deleteContactInfo:[rowData objectForKey:@"id"] target:self success:@selector(deleteSuccess:) failure:@selector(handleFailureHttpResponse:)];
        
        [contactArray removeObjectAtIndex:indexPath.row];
        //删除cell
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

@end
