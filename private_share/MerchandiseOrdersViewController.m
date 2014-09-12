//
//  MerchandiseOrdersViewController.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseOrdersViewController.h"

#import "ShoppingItemConfirmCell.h"
#import "ShoppingItemHeaderView.h"
#import "ShoppingItemFooterView.h"

#import "DateTimeUtil.h"
#import "MerchandiseService.h"

@interface MerchandiseOrdersViewController ()

@end

@implementation MerchandiseOrdersViewController {
    NSMutableArray *merchandiseOrders;
    
    UISegmentedControl *_segmentedControl_;
    PullCollectionView *_collectionView_;
    
    NSInteger pageIndex;
    NSInteger orderState;
    
    NSString *orderItemCellIdentifier;
    NSString *orderFooterViewIdentifier;
    NSString *orderHeaderViewIdentifier;
    NSString *orderHeaderViewIdentifierFirst;
    
    
    NSMutableArray *submittedOrders;
    NSMutableArray *transactionOrders;
    NSMutableArray *cancelledOrders;
    NSDate *submittedOrdersRefreshDate;
    NSDate *transactionOrdersRefreshDate;
    NSDate *cancelledOrdersRefreshDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"我的商品";
    
    orderItemCellIdentifier = @"orderItemCellIdentifier";
    orderFooterViewIdentifier = @"orderFooterViewIdentifier";
    orderHeaderViewIdentifier= @"orderHeaderViewIdentifier";
    orderHeaderViewIdentifierFirst = @"orderHeaderViewIdentifierFirst";
    
    orderState = MerchandiseOrderStateUnCashPayment;

    _segmentedControl_ = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"未支付", @"处理中", @"已完成", nil]];
    _segmentedControl_.frame = CGRectMake(10, 17, 300, 30);
    _segmentedControl_.tintColor = [UIColor appLightBlue];
    _segmentedControl_.backgroundColor = [UIColor whiteColor];
    [_segmentedControl_ setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:15.f] } forState:UIControlStateNormal];
    [_segmentedControl_ setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.f] } forState:UIControlStateSelected];
    _segmentedControl_.selectedSegmentIndex = 0;
    [_segmentedControl_ addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl_];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView_ = [[PullCollectionView alloc] initWithFrame:CGRectMake(0, _segmentedControl_.bounds.size.height + 17 + 15, self.view.bounds.size.width, self.view.bounds.size.height - _segmentedControl_.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 17 - 15) collectionViewLayout:layout];
    _collectionView_.backgroundColor = [UIColor clearColor];
    [_collectionView_ registerClass:[ShoppingItemConfirmCell class] forCellWithReuseIdentifier:orderItemCellIdentifier];
    [_collectionView_ registerClass:[ShoppingItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:orderFooterViewIdentifier];
    [_collectionView_ registerClass:[ShoppingItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:orderHeaderViewIdentifierFirst];
    [_collectionView_ registerClass:[ShoppingItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:orderHeaderViewIdentifier];
    _collectionView_.alwaysBounceVertical = YES;
    _collectionView_.delegate = self;
    _collectionView_.dataSource = self;
    _collectionView_.pullDelegate = self;
    [self.view addSubview:_collectionView_];
    
    [self refresh:YES];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == 0) {
        orderState = MerchandiseOrderStateUnCashPayment;
        merchandiseOrders = [NSMutableArray arrayWithArray:submittedOrders];
        _collectionView_.pullLastRefreshDate = submittedOrdersRefreshDate;
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        orderState = (MerchandiseOrderStateSubmitted | MerchandiseOrderStateUnConfirmed);
        merchandiseOrders = [NSMutableArray arrayWithArray:transactionOrders];
        _collectionView_.pullLastRefreshDate = transactionOrdersRefreshDate;
    } else {
        orderState = MerchandiseOrderStateConfirmed;
        merchandiseOrders = [NSMutableArray arrayWithArray:cancelledOrders];
        _collectionView_.pullLastRefreshDate = cancelledOrdersRefreshDate;
    }
    [_collectionView_ reloadData];
    if(merchandiseOrders.count > 0) {
        //[_collectionView_ scrollToItemAtIndexPath:nil atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
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
    [service getMerchandiseOrdersByPageIndex:pageIndex + 1 orderState:orderState target:self success:@selector(getMerchandiseOrdersSuccess:) failure:@selector(getMerchandiseOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex + 1], @"orderState" : [NSNumber numberWithInteger:orderState]}];
}

#pragma mark -
#pragma mark Service call back

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
                NSDictionary *_merchandise_order_ = [jsonObject dictionaryForKey:@"basicInfo"];
                if(_merchandise_order_ != nil) {
                    MerchandiseOrder *merchandiseOrder = [[MerchandiseOrder alloc] initWithJson:_merchandise_order_];
                    [merchandiseOrders addObject:merchandiseOrder];
                    NSArray *_shopping_items_ = [jsonObject arrayForKey:@"shoppingItems"];
                    if(_shopping_items_ != nil) {
                        for(int i=0; i<_shopping_items_.count; i++) {
                            ShoppingItem *shoppingItem = [[ShoppingItem alloc] initWithJson:[_shopping_items_ objectAtIndex:i]];
                            [merchandiseOrder.merchandiseLists addObject:shoppingItem];
                        }
                    }
                }
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
            if(MerchandiseOrderStateUnCashPayment == orderState) {
                submittedOrders = [NSMutableArray arrayWithArray:merchandiseOrders];
                submittedOrdersRefreshDate = _collectionView_.pullLastRefreshDate;
            } else if(MerchandiseOrderStateUnCashPayment != orderState && MerchandiseOrderStateConfirmed != orderState) {
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
    ShoppingItemConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:orderItemCellIdentifier forIndexPath:indexPath];
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:indexPath.section];
    ShoppingItem *shoppingItem = [merchandiseOrder.merchandiseLists objectAtIndex:indexPath.row];
    cell.shoppingItem = shoppingItem;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:indexPath.section];
    CGFloat height = [ShoppingItemConfirmCell calcCellHeightWithShoppingItem:[merchandiseOrder.merchandiseLists objectAtIndex:indexPath.row]];
    return CGSizeMake(self.view.bounds.size.width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) return CGSizeMake(self.view.bounds.size.width, 54);
    return CGSizeMake(self.view.bounds.size.width, 74);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MerchandiseOrder *merchandiseOrder = [merchandiseOrders objectAtIndex:indexPath.section];
    if(UICollectionElementKindSectionFooter == kind) {
        ShoppingItemFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:orderFooterViewIdentifier forIndexPath:indexPath];
        
       // [footerView setTotalPayment:shopShoppingItems.totalSelectPayment];
    
        return footerView;
    } else {
        NSString *identifier = (indexPath.section == 0 ? orderHeaderViewIdentifierFirst : orderHeaderViewIdentifier);
        
        ShoppingItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        [headerView setSelectButtonHidden];
        [headerView setOrderId:merchandiseOrder.orderId];
        return headerView;
    }
    return nil;
}

@end
