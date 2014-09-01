//
//  ContactInfoPickerViewController.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ContactInfoPickerViewController.h"
#import "ShoppingCart.h"
#import "Contact.h"
#import "CheckBox.h"
#import "AccountService.h"
#import "DefaultStyleButton.h"
#import "MerchandiseService.h"
#import "Account.h"
#import "ShoppingCompleteViewController.h"

@implementation ContactInfoPickerViewController {
    UITableView *contactInfoTableView;
    CheckBox *checkbox;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"my_address", @"");
    
    contactInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    contactInfoTableView.delegate = self;
    contactInfoTableView.dataSource = self;
    contactInfoTableView.backgroundColor = [UIColor whiteColor];
    contactInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contactInfoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if([ShoppingCart myShoppingCart].orderContact.isEmpty) {
        [self getContactInfo];
    }
}

- (void)getContactInfo {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"getting", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    AccountService *service = [[AccountService alloc] init];
    [service getContactInfo:self success:@selector(getContactInfoSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getContactInfoSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200)
    {
        NSArray *contacts = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(contacts != nil && contacts.count > 0)
        {
            NSDictionary *_json_ = [contacts objectAtIndex:0];
            [ShoppingCart myShoppingCart].orderContact = [[Contact alloc] initWithJson:_json_];
            [contactInfoTableView reloadData];
        }
        [[XXAlertView currentAlertView] dismissAlertView];
    } else
    {
        [self handleFailureHttpResponse:resp];
    }
}

- (void)submitOrder {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"order_being_submitted", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service submitShoppingCart:self success:@selector(submitOrderSuccess:) failure:@selector(handleFailureHttpResponse:) saveContact:checkbox.selected userInfo:nil];
}

- (void)submitOrderSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        [[ShoppingCart myShoppingCart] clearShoppingItemss];
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(result != nil) {
            [Account currentAccount].points = [result numberForKey:@"points"].integerValue;
        }
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"submitted_success", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        [self.navigationController pushViewController:[[ShoppingCompleteViewController alloc] init] animated:YES];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:245.f / 255.f green:245.f / 255.f blue:245.f / 255.f alpha:1.0f];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.0f];
        
        UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 7, 195, 30)];
        detailTextLabel.tag = 9999;
        detailTextLabel.font = [UIFont systemFontOfSize:13.f];
        detailTextLabel.textColor = [UIColor lightGrayColor];
        detailTextLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:detailTextLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, cell.bounds.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [cell addSubview:line];
    }
    
    Contact *contact = [ShoppingCart myShoppingCart].orderContact;
    UILabel *lblDetails = (UILabel *)[cell viewWithTag:9999];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact", @"")];
            lblDetails.text = (contact && contact.name) ? contact.name : @"";
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"contact_phone", @"")];
            lblDetails.text = (contact && contact.phoneNumber) ? contact.phoneNumber : @"";
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"delivery_address", @"")];
            lblDetails.text = (contact && contact.address) ? contact.address : @"";
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 51)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 36.f / 2, 36.f / 2)];
    imgView.center = CGPointMake(imgView.center.x, 15 + 30 / 2);
    imgView.image = [UIImage imageNamed:@"icon_contact"];
    [headerView addSubview:imgView];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + 5, 5, 150, 30)];
    lblTitle.center = CGPointMake(lblTitle.center.x, imgView.center.y);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = NSLocalizedString(@"contact_info", @"");
    lblTitle.textColor = [UIColor darkGrayColor];
    [headerView addSubview:lblTitle];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 84)];
    if(checkbox == nil) {
        checkbox = [CheckBox checkBoxWithPoint:CGPointMake(10, 0)];
        checkbox.center = CGPointMake(self.view.center.x, checkbox.center.y);
        checkbox.title = NSLocalizedString(@"save_contact_tips", @"");
    }
    [footView addSubview:checkbox];
    
    UIButton *submitButton = [[DefaultStyleButton alloc] initWithFrame:CGRectMake(0, 45, 260, 30)];
    [submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    submitButton.center = CGPointMake(self.view.center.x, submitButton.center.y);
    [submitButton setTitle:NSLocalizedString(@"submit_order", @"") forState:UIControlStateNormal];
    [footView addSubview:submitButton];
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 84.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [ShoppingCart myShoppingCart].orderContact;
    TextViewController *textView = [[TextViewController alloc] init];
    textView.title = NSLocalizedString(@"contact_info_modify", @"");
    textView.delegate = self;
    if(indexPath.row == 0) {
        textView.identifier = @"kName";
        textView.defaultValue = (contact && contact.name) ? contact.name : @"";
        textView.descriptionText = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"contact_name", @"")];
    } else if(indexPath.row == 1) {
        textView.identifier = @"kPhone";
        textView.defaultValue = (contact && contact.phoneNumber) ? contact.phoneNumber : @"";
        textView.textField.keyboardType = UIKeyboardTypeNumberPad;
        textView.descriptionText = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"contact_phone", @"")];
    } else if(indexPath.row == 2) {
        textView.identifier = @"kAddress";
        textView.defaultValue = (contact && contact.address) ? contact.address : @"";
        textView.descriptionText = [NSString stringWithFormat:@"%@%@:", NSLocalizedString(@"please_enter", @""), NSLocalizedString(@"delivery_address", @"")];
    }
    [self.navigationController pushViewController:textView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Text view controller delegate

- (void)textViewController:(TextViewController *)textViewController didConfirmNewText:(NSString *)newText {
    Contact *contact = [ShoppingCart myShoppingCart].orderContact;
    if([@"kName" isEqualToString:textViewController.identifier]) {
        contact.name = newText;
    } else if([@"kPhone" isEqualToString:textViewController.identifier]) {
        contact.phoneNumber = newText;
    } else if([@"kAddress" isEqualToString:textViewController.identifier]) {
        contact.address = newText;
    }
    [contactInfoTableView reloadData];
    [textViewController.navigationController popViewControllerAnimated:YES];
}

@end
