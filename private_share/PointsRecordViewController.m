//
//  PointsRecordViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PointsRecordViewController.h"
#import "PointsOrderService.h"
#import "PointsOrder.h"

@interface PointsRecordViewController ()

@end

@implementation PointsRecordViewController {
    UISegmentedControl *_segmentedControl_;
    
    NSMutableArray *pointsOrders;
    PullTableView *pointsOrderTableView;
    NSDateFormatter *dateFormatter;
    
    NSInteger pageIndex;
    PointsOrderType pointsOrderType;
    
    NSMutableArray *reducePointsOrders;
    NSMutableArray *additionPointsOrders;
    NSDate *reducePointsOrdersRefreshDate;
    NSDate *additionPointsOrdersRefreshDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"points_record_view_title", @"");
    self.view.backgroundColor = [UIColor appSilver];
    
    _segmentedControl_ = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"earn_record", @""), NSLocalizedString(@"exchange_record", @""), nil]];
    _segmentedControl_.frame = CGRectMake(10, 10, 300, 30);
    _segmentedControl_.tintColor = [UIColor colorWithRed:92.f / 255.f green:99.f / 255.f blue:112.f / 255.f alpha:1];
    //    _segmentedControl_.tintColor = [UIColor appBlue];
    _segmentedControl_.selectedSegmentIndex = 0;
    [_segmentedControl_ addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl_];
    
    pointsOrderType = PointsOrderTypeIncome;
    pointsOrderTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, _segmentedControl_.bounds.size.height + 10 + 15, self.view.bounds.size.width, self.view.bounds.size.height - _segmentedControl_.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 10 - 15) style:UITableViewStylePlain];
    pointsOrderTableView.backgroundColor = [UIColor appSilver];
    pointsOrderTableView.delegate = self;
    pointsOrderTableView.dataSource = self;
    pointsOrderTableView.pullDelegate = self;
    [self.view addSubview:pointsOrderTableView];
    
    [self refresh:YES];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == 0) {
        pointsOrderType = PointsOrderTypeIncome;
        pointsOrderTableView.pullLastRefreshDate = additionPointsOrdersRefreshDate;
        pointsOrders = [NSMutableArray arrayWithArray:additionPointsOrders];
    } else {
        pointsOrderType = PointsOrderTypePay;
        pointsOrderTableView.pullLastRefreshDate = reducePointsOrdersRefreshDate;
        pointsOrders = [NSMutableArray arrayWithArray:reducePointsOrders];
    }
    [pointsOrderTableView reloadData];
    if(pointsOrderTableView.pullLastRefreshDate == nil) {
        [self refresh:YES];
    }
}

- (void)refresh:(BOOL)animated {
    if(animated) {
        pointsOrderTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5f];
        return;
    }
    [self refresh];
}

- (void)refresh {
    pageIndex = 0;
    PointsOrderService *service = [[PointsOrderService alloc] init];
    [service getPointsOrdersByPageIndex:pageIndex orderType:pointsOrderType target:self success:@selector(getPointsOrdersSuccess:) failure:@selector(getPointsOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex], @"orderType" : [NSNumber numberWithInt:pointsOrderType]}];
}

- (void)loadMore {
    PointsOrderService *service = [[PointsOrderService alloc] init];
    [service getPointsOrdersByPageIndex:pageIndex + 1 orderType:pointsOrderType target:self success:@selector(getPointsOrdersSuccess:) failure:@selector(getPointsOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex  + 1], @"orderType" : [NSNumber numberWithInt:pointsOrderType]}];
}

- (void)getPointsOrdersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        
        NSInteger page = ((NSNumber *)[resp.userInfo objectForKey:@"page"]).integerValue;
        NSInteger oType = ((NSNumber *)[resp.userInfo objectForKey:@"orderType"]).integerValue;
        
        if(oType != pointsOrderType) return;
        
        if(pointsOrders == nil) {
            pointsOrders = [NSMutableArray array];
        } else {
            if(page == 0) {
                [pointsOrders removeAllObjects];
            }
        }
        
        NSArray *results = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSUInteger lastIndex = pointsOrders.count;
        if(results != nil) {
            for(int i=0; i<results.count; i++) {
                PointsOrder *order = [[PointsOrder alloc] initWithJson:[results objectAtIndex:i]];
                [pointsOrders addObject:order];
                if(page > 0) {
                    [indexPaths addObject:[NSIndexPath indexPathForItem:lastIndex + i inSection:0]];
                }
            }
        }
        
        if(page > 0) {
            if(results != nil && results.count > 0) {
                pageIndex++;
                [pointsOrderTableView beginUpdates];
                [pointsOrderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [pointsOrderTableView endUpdates];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            pointsOrderTableView.pullLastRefreshDate = [NSDate date];
            [pointsOrderTableView reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        if(page == 0) {
            if(PointsOrderTypePay == pointsOrderType) {
                reducePointsOrders = [NSMutableArray arrayWithArray:pointsOrders];
                reducePointsOrdersRefreshDate = pointsOrderTableView.pullLastRefreshDate;
            } else {
                additionPointsOrders = [NSMutableArray arrayWithArray:pointsOrders];
                additionPointsOrdersRefreshDate = pointsOrderTableView.pullLastRefreshDate;
            }
        }
        
        return;
    }
    
    [self getPointsOrdersFailure:resp];
}

- (void)getPointsOrdersFailure:(HttpResponse *)resp {
    if(resp.statusCode == 403) {
        [pointsOrders removeAllObjects];
        [pointsOrderTableView reloadData];
    }
    [self cancelRefresh];
    [self cancelLoadMore];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (pointsOrders == nil || pointsOrders.count == 0) ? 0 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return pointsOrders == nil ? 0 : pointsOrders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = self.view.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 100, 30)];
        pointsLabel.tag = 999;
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.textAlignment = NSTextAlignmentRight;
        pointsLabel.font = [UIFont systemFontOfSize:14.f];
        pointsLabel.textColor = [UIColor appColor];
        [cell addSubview:pointsLabel];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.f];
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    PointsOrder *order = [pointsOrders objectAtIndex:indexPath.row];
    
    ((UILabel *)[cell viewWithTag:999]).text = [NSString stringWithFormat:@"%@ %ld%@", (order.points > 0 ? @"+" : @""), (long)order.points, NSLocalizedString(@"points", @"")];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:order.createTime];
    
    
    NSString *orderTypeName = [NSString stringWithFormat:@"%@", [PointsOrder pointsOrderTypeAsString:order.orderType]];
    if(/*PointsOrderTypeAdTask == order.orderType*/![XXStringUtils isBlank:order.providerName]) {
        orderTypeName = [NSString stringWithFormat:@"%@%@", order.providerName, orderTypeName];
    }
    if(![XXStringUtils isBlank:order.taskName]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", orderTypeName, order.taskName];
    } else {
        cell.textLabel.text = orderTypeName;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark -
#pragma mark Pull table view delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(pointsOrderTableView.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(pointsOrderTableView.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    pointsOrderTableView.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    pointsOrderTableView.pullTableIsLoadingMore = NO;
}

@end
