//
//  ShoppingCartViewController2.m
//  private_share
//
//  Created by Zhao yang on 7/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCartViewController2.h"
#import "MerchandiseOrdersViewController.h"
#import "PurchaseViewController.h"

#import "ShoppingItemCell.h"
#import "ShoppingItemHeaderView.h"
#import "ShoppingItemFooterView.h"

#import "XXEventNameFilter.h"
#import "ShoppingItemsChangedEvent.h"
#import "ShoppingItemSelectPropertyChangedEvent.h"

#import "ShoppingCart.h"
#import "UIImage+Color.h"
#import "UIDevice+ScreenSize.h"

NSString * const ShoppingItemCellIdentifier   = @"ShoppingItemCellIdentifier";
NSString * const ShoppingItemHeaderIdentifier = @"ShoppingItemHeaderIdentifier";
NSString * const ShoppingItemFooterIdentifier = @"ShoppingItemFooterIdentifier";

@implementation ShoppingCartViewController2 {
    UIView *backgroundView;
    UICollectionView *_collectionView_;
    SettlementView *settlementView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [ShoppingCart myShoppingCart].allSelect = NO;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    self.title = NSLocalizedString(@"mi_repo2", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(showMerchandiseOrderViewController)];
    
    settlementView = [[SettlementView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60, self.view.bounds.size.width, 60)];
    settlementView.delegate = self;
    [self.view addSubview:settlementView];
    
    backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 1008/2)];
    imageView.center = CGPointMake(self.view.center.x, imageView.center.y);
    imageView.image = [UIImage imageNamed:@"miku2"];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.hidden = YES;
    [backgroundView addSubview:imageView];
    [self.view addSubview:backgroundView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView_ = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60) collectionViewLayout:layout];
    _collectionView_.backgroundColor = [UIColor clearColor];
    [_collectionView_ registerClass:[ShoppingItemCell class] forCellWithReuseIdentifier:ShoppingItemCellIdentifier];
    
    [_collectionView_ registerClass:[ShoppingItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ShoppingItemFooterIdentifier];
    [_collectionView_ registerClass:[ShoppingItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShoppingItemHeaderIdentifier];

    _collectionView_.alwaysBounceVertical = YES;
    _collectionView_.delegate = self;
    _collectionView_.dataSource = self;
    [self.view addSubview:_collectionView_];
    
    if(![ShoppingCart myShoppingCart].hasMerchandises) {
        backgroundView.hidden = NO;
        _collectionView_.hidden = YES;
        return;
    }
    
    [self refreshSettlementView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    XXEventNameFilter *eventFilter = [[XXEventNameFilter alloc] initWithSupportedEventNames:[NSArray arrayWithObjects:kEventShoppingItemSelectPropertyChangedEvent, kEventShoppingItemsChanged, nil]];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:eventFilter];
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)refreshAllShoppingItemsSelectProperty {
    NSArray *indexPaths = [_collectionView_ indexPathsForVisibleItems];
    for(NSIndexPath *indexPath in indexPaths) {
        ShoppingItemCell *cell = (ShoppingItemCell *)[_collectionView_ cellForItemAtIndexPath:indexPath];
        [cell refreshShoppingItemSelectProperty];
    }
}

- (void)refreshSettlementView {
    [settlementView setPayment:[ShoppingCart myShoppingCart].totalSelectPayment];
}

- (void)refresh {
    [_collectionView_ reloadData];
    [self refreshSettlementView];
}

- (void)showPurchaseViewController {
    [self.navigationController pushViewController:
        [[PurchaseViewController alloc] initWithShopShoppingItemss:[ShoppingCart myShoppingCart].selectShopShoppingItemss] animated:YES];
}

- (void)showMerchandiseOrderViewController {
    [self.navigationController pushViewController:[[MerchandiseOrdersViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if([ShoppingCart myShoppingCart].shopShoppingItemss == nil) return 0;
    return [ShoppingCart myShoppingCart].shopShoppingItemss.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ShopShoppingItems *ssi = [[ShoppingCart myShoppingCart].shopShoppingItemss objectAtIndex:section];
    return ssi.shoppingItems == nil ? 0 : ssi.shoppingItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *ssi = [[ShoppingCart myShoppingCart].shopShoppingItemss objectAtIndex:indexPath.section];
    ShoppingItem *si = [ssi.shoppingItems objectAtIndex:indexPath.row];
    ShoppingItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingItemCellIdentifier forIndexPath:indexPath];
    cell.shoppingCartViewController = self;
    cell.shoppingItem = si;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *ssi = [[ShoppingCart myShoppingCart].shopShoppingItemss objectAtIndex:indexPath.section];
    CGFloat height = [ShoppingItemCell calcCellHeightWithShoppingItem:[ssi.shoppingItems objectAtIndex:indexPath.row]];
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
    return CGSizeMake(self.view.bounds.size.width, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *shopShoppingItems = [[ShoppingCart myShoppingCart].shopShoppingItemss objectAtIndex:indexPath.section];
    if(UICollectionElementKindSectionFooter == kind) {
        ShoppingItemFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ShoppingItemFooterIdentifier forIndexPath:indexPath];
        [footerView setTotalPayment:shopShoppingItems.totalPayment];
        return footerView;
    } else {
        ShoppingItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ShoppingItemHeaderIdentifier forIndexPath:indexPath];
        headerView.shopId = shopShoppingItems.shopID;
        return headerView;
    }
    return nil;
}

#pragma mark -
#pragma mark Event Sub && Pub

- (NSString *)xxEventSubscriberIdentifier {
    return @"ShoppingCartViewControllerSubscriber2";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[ShoppingItemSelectPropertyChangedEvent class]]
            || [event isKindOfClass:[ShoppingItemsChangedEvent class]]) {
        
        [self refresh];
    }
}

#pragma mark -
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if([alertView isKindOfClass:[UIParameterAlertView class]]) {
            UIParameterAlertView *_alertView_ = (UIParameterAlertView *)alertView;
            ShoppingItem *shoppingItem = [_alertView_ parameterForKey:@"shoppingItem"];

            NSIndexPath *indexPath = nil;
            ShopShoppingItems *shopShoppingItems = nil;
            for(int section=0; section<[ShoppingCart myShoppingCart].shopShoppingItemss.count; section++) {
                ShopShoppingItems *ssi = [[ShoppingCart myShoppingCart].shopShoppingItemss objectAtIndex:section];
                for(int row=0; row<ssi.shoppingItems.count; row++) {
                    ShoppingItem *si = [ssi.shoppingItems objectAtIndex:row];
                    if(si == shoppingItem) {
                        shopShoppingItems = ssi;
                        indexPath = [NSIndexPath indexPathForItem:row inSection:section];
                        break;
                    }
                }
            }
            
            if(indexPath != nil) {
                [shopShoppingItems.shoppingItems removeObject:shoppingItem];
                if(shopShoppingItems.shoppingItems.count == 0) {
                    [[ShoppingCart myShoppingCart].shopShoppingItemss removeObject:shopShoppingItems];
                    if([ShoppingCart myShoppingCart].shopShoppingItemss.count != 0) {
                        [_collectionView_ deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                    } else {
                        backgroundView.hidden = NO;
                        _collectionView_.hidden = YES;
                    }
                } else {
                    [_collectionView_ deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    [_collectionView_ reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                }
                [self refreshSettlementView];
            }
        }
    }
}

- (void)purchaseButtonPressed:(id)sender {
    [self showPurchaseViewController];
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

@end
