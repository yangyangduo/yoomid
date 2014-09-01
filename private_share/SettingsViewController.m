//
//  SettingsViewController.m
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SettingsViewController.h"
#import "PointsRecordViewController.h"
#import "MerchandiseOrdersViewController.h"
#import "AboutYoomidViewController.h"
#import "SecurityConfig.h"
#import "AppDelegate.h"
#import "AccountViewController.h"

@implementation SettingsViewController {
    UITableView *tblYoomid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"settings", @"");
    
    tblYoomid = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStyleGrouped];
    tblYoomid.delegate = self;
    tblYoomid.dataSource = self;
    [self.view addSubview:tblYoomid];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
        cell.textLabel.text = @"我的账户";
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"about_yoomid", @"");
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        if(![app checkLogin]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
    
    if(indexPath.section == 0) {
         [self.navigationController pushViewController:[[AccountViewController alloc] init] animated:YES];
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [self.navigationController pushViewController:[[WebViewController alloc] initWithLocalHtmlFileName:@"contact_us"] animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
