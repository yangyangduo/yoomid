//
//  AccountViewController.m
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "ViewControllerAccessor.h"
#import "LeftDrawerViewController.h"
#import "PasswordChangeViewController.h"

@implementation AccountViewController {
    UITableView *accountTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"my_account", @"");
    
    accountTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStyleGrouped];
    accountTable.delegate = self;
    accountTable.dataSource = self;
    [self.view addSubview:accountTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) return 103;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"password_modify", @"");
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 103)];
        UIButton *btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(9.5f, 30, 301, 38)];
        [btnLogout setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
        [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red_highlighted"] forState:UIControlStateHighlighted];
        [btnLogout addTarget:self action:@selector(btnLogoutPressed:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btnLogout];
        return footView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        [self.navigationController pushViewController:[[PasswordChangeViewController alloc] init] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)delayLogout {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app doAfterLogout];
    [[XXAlertView currentAlertView] dismissAlertView];
    [self.navigationController popToRootViewControllerAnimated:NO];
    LeftDrawerViewController *leftViewController = (LeftDrawerViewController *)[ViewControllerAccessor defaultAccessor].drawerViewController.leftViewController;
    leftViewController.selectedItem = @"portal";
    [[ViewControllerAccessor defaultAccessor].drawerViewController enableGestureForDrawerView];
    [app checkLogin];
}

- (void)btnLogoutPressed:(id)sender {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"being_logout", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    [self performSelector:@selector(delayLogout) withObject:nil afterDelay:0.8f];
}

@end
