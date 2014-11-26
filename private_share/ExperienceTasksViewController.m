//
//  ExperienceTasksViewController.m
//  private_share
//
//  Created by Zhao yang on 6/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ExperienceTasksViewController.h"

#import "SecurityConfig.h"
#import "Constants.h"

@implementation ExperienceTasksViewController {
    UITableView *taskTableView;
    
}

//adwo error list
static NSString* const errCodeList[] = {
    @"successful",
    @"offer wall is disabled",
    @"login connection failed",
    @"offer wall has not been loginned",
    @"offer wall is not initialized",
    @"offer wall has been loginned",
    @"unknown error",
    @"invalid event flag",
    @"app list request failed",
    @"app list response failed",
    @"app list parameter malformatted",
    @"app list is being requested",
    @"offer wall is not ready for show",
    @"keywords malformatted",
    @"current device has not enough space to save resource",
    @"resource malformatted",
    @"resource load failed",
    @"you are have already loginned",
    @"exceed max show count",
    @"exceed max login count",
    @"you have not enough points",
    @"points consumption is not available",
    @"point is negative number",
    @"receive point is error",
    @"network request error"
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体验类任务";
    
    taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    [self.view addSubview:taskTableView];
    
    //init dianru
//    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

//dianru application key
-(NSString *)applicationKey {
    return kDianruAppKey;
}

//dianru required user id
-(NSString *)dianruAdWallAppUserId {
    return [SecurityConfig defaultConfig].userName;
}

- (void)didReceiveGetScoreResult:(int)point {
}

- (void)didReceiveSpendScoreResult:(BOOL)isSuccess {
}

@end
