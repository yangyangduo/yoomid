//
//  MerchandiseOrdersViewController.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseOrdersViewController.h"
#import "OrderItemCell.h"
#import "OrderFooterView.h"
#import "OrderHeaderView.h"
#import "DateTimeUtil.h"
#import "MerchandiseService.h"

@interface MerchandiseOrdersViewController ()

@end

@implementation MerchandiseOrdersViewController {
    UISegmentedControl *_segmentedControl_;
    PullCollectionView *_collectionView_;
    
    NSMutableArray *merchandiseOrders;
    NSInteger pageIndex;
    MerchandiseOrderState orderState;
    
    NSString *orderItemCellIdentifier;
    NSString *orderFooterViewIdentifier;
    NSString *orderHeaderViewIdentifier;
    
    NSMutableArray *submittedOrders;
    NSMutableArray *transactionOrders;
    NSMutableArray *cancelledOrders;
    NSDate *submittedOrdersRefreshDate;
    NSDate *transactionOrdersRefreshDate;
    NSDate *cancelledOrdersRefreshDate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"my_merchandise_orders", @"");
    self.view.backgroundColor = [UIColor appSilver];
    
    orderState = MerchandiseOrderStateSubmitted;

    _segmentedControl_ = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"order_unfinished", @""), NSLocalizedString(@"order_finished", @""), NSLocalizedString(@"order_cancelled", @""), nil]];
    _segmentedControl_.frame = CGRectMake(10, 10, 300, 30);
    _segmentedControl_.tintColor = [UIColor colorWithRed:92.f / 255.f green:99.f / 255.f blue:112.f / 255.f alpha:1];
//    _segmentedControl_.tintColor = [UIColor appBlue];
    _segmentedControl_.selectedSegmentIndex = 0;
    [_segmentedControl_ addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl_];
    
    orderItemCellIdentifier = @"orderItemCellIdentifier";
    orderFooterViewIdentifier = @"orderFooterViewIdentifier";
    orderHeaderViewIdentifier= @"orderHeaderViewIdentifier";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView_ = [[PullCollectionView alloc] initWithFrame:CGRectMake(0, _segmentedControl_.bounds.size.height + 10 + 15, self.view.bounds.size.width, self.view.bounds.size.height - _segmentedControl_.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 10 - 15) collectionViewLayout:layout];
    _collectionView_.backgroundColor = [UIColor clearColor];
    [_collectionView_ registerClass:[OrderItemCell class] forCellWithReuseIdentifier:orderItemCellIdentifier];
    [_collectionView_ registerClass:[OrderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:orderFooterViewIdentifier];
    [_collectionView_ registerClass:[OrderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:orderHeaderViewIdentifier];
    _collectionView_.alwaysBounceVertical = YES;
    _collectionView_.delegate = self;
    _collectionView_.dataSource = self;
    _collectionView_.pullDelegate = self;
    [self.view addSubview:_collectionView_];
    
    [self refresh:YES];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == 0) {
        orderState = MerchandiseOrderStateSubmitted;
        merchandiseOrders = [NSMutableArray arrayWithArray:submittedOrders];
        _collectionView_.pullLastRefreshDate = submittedOrdersRefreshDate;
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        orderState = MerchandiseOrderStateTransaction;
        merchandiseOrders = [NSMutableArray arrayWithArray:transactionOrders];
        _collectionView_.pullLastRefreshDate = transactionOrdersRefreshDate;
    } else {
        orderState = MerchandiseOrderStateCancelled;
        merchandiseOrders = [NSMutableArray arrayWithArray:cancelledOrders];
        _collectionView_.pullLastRefreshDate = cancelledOrdersRefreshDate;
    }
    [_collectionView_ reloadData];
    if(_collectionView_.pullLastRefreshDate == nil) {
        [self refresh:YES];
    }
}

- (void)refresh:(BOOL)animated {
    if(animated) {
        _collectionView_.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.6f];
        return;
    }
    [self refresh];
}

- (void)refresh {
    pageIndex = 0;
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandiseOrdersByPageIndex:pageIndex orderState:orderState target:self success:@selector(getMerchandiseOrdersSuccess:) failure:@selector(getMerchandiseOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex], @"orderState" : [NSNumber numberWithInteger:orderState]}];
}

- (void)loadMore {
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandiseOrdersByPageIndex:pageIndex + 1 orderState:MerchandiseOrderStateSubmitted target:self success:@selector(getMerchandiseOrdersSuccess:) failure:@selector(getMerchandiseOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex + 1], @"orderState" : [NSNumber numberWithInteger:orderState]}];
}

- (void)getMerchandiseOrdersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *userInfo = resp.userInfo;
        NSInteger page = ((NSNumber *)[userInfo objectForKey:@"page"]).integerValue;
        NSInteger oState = ((NSNumber *)[userInfo objectForKey:@"orderState"]).integerValue;
        
        if(oState != orderState) return;
        
        if(merchandiseOrders == nil) {
            merchandiseOrders = [NSMutableArray array];
        } else {
            if(page == 0) {
                [merchandiseOrders removeAllObjects];
            }
        }
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        NSUInteger lastIndex = merchandiseOrders.count;
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [merchandiseOrders addObject:[[MerchandiseOrder alloc] initWithDictionary:jsonObject]];
                if(page > 0) {
                    [indexSet addIndex:lastIndex + i];
                }
            }
        }
        
        if(page > 0) {
            if(jsonArray != nil && jsonArray.count > 0) {
                pageIndex++;
                [_collectionView_ insertSections:indexSet];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            _collectionView_.pullLastRefreshDate = [NSDate date];
            [_collectionView_ reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        if(page == 0) {
            if(MerchandiseOrderStateSubmitted == orderState) {
                submittedOrders = [NSMutableArray arrayWithArray:merchandiseOrders];
                submittedOrdersRefreshDate = _collectionView_.pullLastRefreshDate;
            } else if(MerchandiseOrderStateTransaction == orderState) {
                transactionOrders = [NSMutableArray arrayWithArray:merchandiseOrders];
                transactionOrdersRefreshDate = _collectionView_.pullLastRefreshDate;
            } else {
                cancelledOrders = [NSMutableArray arrayWithArray:merchandiseOrders];
                cancelledOrdersRefreshDate = _collectionView_.pullLastRefreshDate;
            }
        }
        return;
    }
    [self getMerchandiseOrdersFailure:resp];
}

- (void)getMerchandiseOrdersFailure:(HttpResponse *)resp {
    if(resp.statusCode == 403) {
        [merchandiseOrders removeAllObjects];
        [_collectionView_ reloadData];
    }
    [self cancelRefresh];
    [self cancelLoadMore];
}

#pragma mark -
#pragma mark Pull collection view delegate

- (void)pullTableViewDidTriggerRefresh:(PullCollectionView *)pullTableView {
    if(_collectionView_.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullCollectionView *)pullTableView {
    if(_collectionView_.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    _collectionView_.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    _collectionView_.pullTableIsLoadingMore = NO;
}

#pragma mark -
#pragma mark Collection view delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return merchandiseOrders == nil ? 0 : merchandiseOrders.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:section];
    return merchandiseOrder.merchandiseLists == nil ? 0 : merchandiseOrder.merchandiseLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:orderItemCellIdentifier forIndexPath:indexPath];
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:indexPath.section];
    MerchandiseOrderItem *orderItem = [merchandiseOrder.merchandiseLists objectAtIndex:indexPath.row];
    
    if(orderItem.paymentType == 1) {
        [cell setTitle:orderItem.name number:orderItem.number points:orderItem.points];
    } else if(orderItem.paymentType == 2) {
        [cell setTitle:orderItem.name number:orderItem.number cash:orderItem.cash];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 65);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:indexPath.section];
    if(UICollectionElementKindSectionFooter == kind) {
        OrderFooterView *orderFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:orderFooterViewIdentifier forIndexPath:indexPath];
        orderFooterView.containerViewController = self;
        [orderFooterView setTotalPoints:merchandiseOrder.totalPoints totalCash:merchandiseOrder.totalCash orderId:merchandiseOrder.orderId];
        return orderFooterView;
    } else {
        OrderHeaderView *orderHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:orderHeaderViewIdentifier forIndexPath:indexPath];
        [orderHeaderView setOrderId:merchandiseOrder.orderId orderTime:merchandiseOrder.createTime];
        return orderHeaderView;
    }
    return nil;
}

@end
