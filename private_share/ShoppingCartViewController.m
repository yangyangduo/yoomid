//
//  ShoppingCartViewController.m
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "PaymentCollectionViewCell.h"
#import "ShoppingCartHeaderTitleView.h"
#import "ShoppingCartLastFooterView.h"
#import "ShoppingCart.h"
#import "ContactInfoPickerViewController.h"
#import "XXEventNameFilter.h"
#import "ShoppingItemsChangedEvent.h"

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController {
    UICollectionView *_collectionView_;
    
    NSMutableArray *pointsPaymentItems;
    NSMutableArray *cashPaymentItems;
    
    NSInteger numberOfSections;
    
    /*     cell identifier     */
    NSString *paymentCellIdentifier;
    NSString *headerViewIdentifier;
    NSString *footerviewIdentifier;
    NSString *lastFooterViewIdentifier;
    
    UILabel *availablePointsLabel;
    
    ShoppingCartFooterView *pointsFooterView;
    ShoppingCartFooterView *cashFooterView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"shopping_cart", @"");
    
    self.view.backgroundColor = [UIColor appSilver];
    
    paymentCellIdentifier = @"paymentCellIdentifier";
    headerViewIdentifier = @"headerViewIdentifier";
    footerviewIdentifier = @"footerviewIdentifier";
    lastFooterViewIdentifier = @"lastFooterViewIdentifier";
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView_ = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 40) collectionViewLayout:layout];
    _collectionView_.alwaysBounceVertical = YES;
    _collectionView_.delegate = self;
    _collectionView_.dataSource = self;
    _collectionView_.backgroundColor = [UIColor whiteColor];
    [_collectionView_ registerClass:[PaymentCollectionViewCell class] forCellWithReuseIdentifier:paymentCellIdentifier];
    [_collectionView_ registerClass:[ShoppingCartHeaderTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
    [_collectionView_ registerClass:[ShoppingCartFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerviewIdentifier];
    [_collectionView_ registerClass:[ShoppingCartLastFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:lastFooterViewIdentifier];
    [self.view addSubview:_collectionView_];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 40, self.view.bounds.size.width, 40)];
    bottomBar.backgroundColor = [UIColor appSilver];
    
    UILabel *availablePointsLabelMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    availablePointsLabelMessage.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"availablePoints", @"")];
    availablePointsLabelMessage.textColor = [UIColor darkGrayColor];
    availablePointsLabelMessage.backgroundColor = [UIColor clearColor];
    availablePointsLabelMessage.font = [UIFont systemFontOfSize:16.f];
    [bottomBar addSubview:availablePointsLabelMessage];
    
    availablePointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 120, 30)];
    availablePointsLabel.text = @"";
    availablePointsLabel.textColor = [UIColor darkGrayColor];
    availablePointsLabel.backgroundColor = [UIColor clearColor];
    availablePointsLabel.font = [UIFont systemFontOfSize:16.f];
    [bottomBar addSubview:availablePointsLabel];
    
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 7, 100, 26)];
    [payButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [payButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [payButton setTitle:NSLocalizedString(@"next", @"") forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    payButton.layer.borderColor = [UIColor appTextFieldGray].CGColor;
    payButton.layer.borderWidth = 1;
    payButton.layer.cornerRadius = 8;
    [bottomBar addSubview:payButton];
    
    [self.view addSubview:bottomBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
    XXEventNameFilter *filter = [[XXEventNameFilter alloc] initWithSupportedEventName:kEventShoppingItemsChanged];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:filter];
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)refresh {
    numberOfSections = 0;
    ShopShoppingItems *ssi = [[ShoppingCart myShoppingCart] shopShoppingItemsWithShopID:kHentreStoreID];
    if(ssi != nil) {
        pointsPaymentItems = [NSMutableArray arrayWithArray:[ssi shoppingItemsWithPaymentType:PaymentTypePoints]];
        cashPaymentItems = [NSMutableArray arrayWithArray:[ssi shoppingItemsWithPaymentType:PaymentTypeCash]];
    } else {
        pointsPaymentItems = [NSMutableArray array];
        cashPaymentItems = [NSMutableArray array];
    }
    if(pointsPaymentItems.count > 0) {
        numberOfSections++;
    }
    if(cashPaymentItems.count > 0) {
        numberOfSections++;
    }
    [_collectionView_ reloadData];
}

- (void)setTotalPayment:(Payment *)totalPayment {
    if(cashFooterView != nil) {
        [cashFooterView setCash:totalPayment.cash];
    }
    if(pointsFooterView != nil) {
        [pointsFooterView setPoints:totalPayment.points];
    }
}

- (void)payButtonPressed:(id)sender {
    if(![ShoppingCart myShoppingCart].hasMerchandises) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"shopping_first", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    [self.navigationController pushViewController:[[ContactInfoPickerViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if([alertView isKindOfClass:[UIParameterAlertView class]]) {
            UIParameterAlertView *_alertView_ = (UIParameterAlertView *)alertView;
            ShoppingItem *item = [_alertView_ parameterForKey:@"shoppingItem"];
            
            NSInteger row = -1;
            NSInteger section = PaymentTypePoints == item.paymentType ? 0 : 1;
            NSMutableArray *items = section == 0 ? pointsPaymentItems : cashPaymentItems;
            
            for(int i=0; i<items.count; i++) {
                ShoppingItem *_item_ = [items objectAtIndex:i];
                if(_item_ == item) {
                    row = i;
                    break;
                }
            }
            if(row != -1) {
                [items removeObjectAtIndex:row];
               // [[ShoppingCart myShoppingCart] setMerchandise:item.merchandise shopID:kHentreStoreID number:0 paymentType:item.paymentType];
                if(items.count == 0) {
                    [self refresh];
                    return;
                }
                [_collectionView_ deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:row inSection:section]]];
            }
        }
    }
}

#pragma mark -
#pragma mark collection view delegate && data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(numberOfSections == 2) {
        if(section == 0) return pointsPaymentItems.count;
        else return cashPaymentItems.count;
    } else {
        if(pointsPaymentItems.count > 0) {
            return pointsPaymentItems.count;
        } else {
            return cashPaymentItems.count;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return numberOfSections;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 26);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCollectionViewCell *shoppingItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:paymentCellIdentifier forIndexPath:indexPath];
    shoppingItemCell.shoppingCartViewController = self;
    if(indexPath.section == 0) {
        if(pointsPaymentItems.count > 0) {
            [shoppingItemCell setShoppingItem:[pointsPaymentItems objectAtIndex:indexPath.row]];
            return shoppingItemCell;
        }
    }
    if(cashPaymentItems.count > 0) {
        shoppingItemCell.shoppingItem = [cashPaymentItems objectAtIndex:indexPath.row];
    }
    return shoppingItemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if(section == numberOfSections - 1) {
        return CGSizeMake(self.view.bounds.size.width, 45 + 90);
    }
    return CGSizeMake(self.view.bounds.size.width, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(UICollectionElementKindSectionHeader == kind) {
        ShoppingCartHeaderTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        if(indexPath.section == 0) {
            if(pointsPaymentItems.count > 0) {
                headerView.title = NSLocalizedString(@"points_exchange", @"");
            } else {
                headerView.title = NSLocalizedString(@"cash_exchange", @"");
            }
        } else if(indexPath.section == 1) {
            if(cashPaymentItems.count > 0) {
                headerView.title = NSLocalizedString(@"cash_exchange", @"");
            }
        }
        return headerView;
    } else if(UICollectionElementKindSectionFooter == kind) {
        ShoppingCartFooterView *footerView = nil;
        if(indexPath.section == numberOfSections - 1) {
            footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lastFooterViewIdentifier forIndexPath:indexPath];
        } else {
            footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerviewIdentifier forIndexPath:indexPath];
        }
        if(numberOfSections == 1) {
            if(pointsPaymentItems.count == 0) {
                cashFooterView = footerView;
            } else {
                pointsFooterView = footerView;
            }
        } else if(numberOfSections == 2) {
            if(indexPath.section == 0) {
                pointsFooterView = footerView;
            } else {
                cashFooterView = footerView;
            }
        }
        [self setTotalPayment:[ShoppingCart myShoppingCart].totalPayment];
        return footerView;
    }
    return nil;
}

#pragma mark -
#pragma mark Event subscriber

- (NSString *)xxEventSubscriberIdentifier {
    return @"ShoppingCartSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[ShoppingItemsChangedEvent class]]) {
        ShoppingItemsChangedEvent *sEvent = (ShoppingItemsChangedEvent *)event;
        [self setTotalPayment:sEvent.totalPayment];
    }
}

@end
