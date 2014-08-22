//
//  TaskViewController.m
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskViewController.h"
#import "ExperienceTasksViewController.h"
#import "AppDelegate.h"
#import "Account.h"
#import "XXEventNameFilter.h"
#import "AccountPointsUpdatedEvent.h"

@interface TaskViewController ()

@end

@implementation TaskViewController {
    UIImageView *levelImageView;
    UITableView *taskTableView;
    
    UILabel *totalPointsMessageLabel;
    UILabel *todayPointsMessageLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"task_view_title", @"");
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    backgroundView.backgroundColor = [UIColor appColor];
    [self.view addSubview:backgroundView];
    
    levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 134.f / 2, 134.f / 2)];
    levelImageView.image = [UIImage imageNamed:@"level1"];
    levelImageView.center = CGPointMake(backgroundView.center.x, levelImageView.center.y);
    [backgroundView addSubview:levelImageView];
    
    totalPointsMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, backgroundView.bounds.size.height - 26 - 10, 150, 26)];
    totalPointsMessageLabel.text = @"";
    totalPointsMessageLabel.textColor = [UIColor whiteColor];
    totalPointsMessageLabel.backgroundColor = [UIColor clearColor];
    totalPointsMessageLabel.font = [UIFont systemFontOfSize:13.f];
    [backgroundView addSubview:totalPointsMessageLabel];
    
    todayPointsMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, totalPointsMessageLabel.frame.origin.y, 150, 26)];
    todayPointsMessageLabel.text =  @"";
    todayPointsMessageLabel.textAlignment = NSTextAlignmentRight;
    todayPointsMessageLabel.textColor = [UIColor whiteColor];
    todayPointsMessageLabel.backgroundColor = [UIColor clearColor];
    todayPointsMessageLabel.font = [UIFont systemFontOfSize:13.f];
    [backgroundView addSubview:todayPointsMessageLabel];
    
    taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, backgroundView.frame.origin.y + backgroundView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - 160 - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    [self.view addSubview:taskTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setPoins:[Account currentAccount].points];
    [self setPointsToday:0];
    
    XXEventNameFilter *filter = [[XXEventNameFilter alloc] initWithSupportedEventName:kEventAccountPointsUpdated];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filter];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)setPoins:(NSInteger)points {
    totalPointsMessageLabel.text = [NSString stringWithFormat:@"%@: %ld%@", NSLocalizedString(@"total_points", @""), (long)points, NSLocalizedString(@"points_short", @"")];
}

- (void)setPointsToday:(NSInteger)points {
    todayPointsMessageLabel.text = [NSString stringWithFormat:@"%@: %ld%@", NSLocalizedString(@"points_today", @""), (long)points, NSLocalizedString(@"points_short", @"")];
}

#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"视频类任务";
        cell.detailTextLabel.text = @"看视频也能挣积分哦";
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"体验类任务";
        cell.detailTextLabel.text = @"高品质打榜任务,下手,赶紧的!";
        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if(![app checkLogin]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if(indexPath.row == 1) {
        [self.navigationController pushViewController:[[ExperienceTasksViewController alloc] init] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark -
#pragma mark

- (NSString *)xxEventSubscriberIdentifier {
    return @"TaskSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[AccountPointsUpdatedEvent class]]) {
        AccountPointsUpdatedEvent *aEvent = (AccountPointsUpdatedEvent *)event;
        [self setPoins:aEvent.newPoints];
    }
}

@end
