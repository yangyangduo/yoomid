//
//  ActivitiesViewController.m
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivityDetailViewController.h"
#import "MerchandiseService.h"
#import "ActivityCollectionViewCell.h"

@implementation ActivitiesViewController {
    PullCollectionView *activitiesCollectionView;
    NSMutableArray *activities;
    NSString *cellIdentifier;
    
    NSUInteger pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"activity", @"");
    
    cellIdentifier = @"cellIdentifier";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    activitiesCollectionView = [[PullCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) collectionViewLayout:flowLayout];
    activitiesCollectionView.backgroundColor = [UIColor clearColor];
    activitiesCollectionView.alwaysBounceVertical = YES;
    activitiesCollectionView.delegate = self;
    activitiesCollectionView.dataSource = self;
    activitiesCollectionView.pullDelegate = self;
    [activitiesCollectionView registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:activitiesCollectionView];
    
    [self refresh:YES];
}

- (void)refresh:(BOOL)animated {
    if(animated) {
        activitiesCollectionView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.6f];
        return;
    }
    [self refresh];
}

- (void)refresh {
    pageIndex = 0;
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getActivityMerchandisesWithShopId:kHentreStoreID pageIndex:pageIndex target:self success:@selector(getMerchandisesSuccess:) failure:@selector(handleFailureHttpResponse:) userInfo:[NSNumber numberWithInteger:pageIndex]];
}

- (void)loadMore {
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getActivityMerchandisesWithShopId:kHentreStoreID pageIndex:pageIndex + 1 target:self success:@selector(getMerchandisesSuccess:) failure:@selector(handleFailureHttpResponse:) userInfo:[NSNumber numberWithInteger:pageIndex + 1]];
}

- (void)getMerchandisesSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSInteger page = ((NSNumber *)resp.userInfo).integerValue;
        if(activities == nil) {
            activities = [NSMutableArray array];
        } else {
            if(page == 0) {
                [activities removeAllObjects];
            }
        }
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        NSUInteger lastIndex = activities.count;
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [activities addObject:[[Merchandise alloc] initWithDictionary:jsonObject]];
                if(page > 0) {
                    [indexSet addIndex:lastIndex + i];
                }
            }
        }
        
        if(page > 0) {
            if(jsonArray != nil && jsonArray.count > 0) {
                pageIndex++;
                [activitiesCollectionView insertSections:indexSet];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            activitiesCollectionView.pullLastRefreshDate = [NSDate date];
            [activitiesCollectionView reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        return;
    }
    [self handleFailureHttpResponse:resp];
}

- (void)handleFailureHttpResponse:(HttpResponse *)resp {
    [super handleFailureHttpResponse:resp];
    [self cancelRefresh];
    [self cancelLoadMore];
}

#pragma mark -
#pragma mark Pull collection view delegate

- (void)pullTableViewDidTriggerRefresh:(PullCollectionView *)pullTableView {
    if(activitiesCollectionView.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullCollectionView *)pullTableView {
    if(activitiesCollectionView.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    activitiesCollectionView.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    activitiesCollectionView.pullTableIsLoadingMore = NO;
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return activities == nil ? 0 : activities.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return activities == nil ? 0 : 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 200);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Merchandise *merchandise = [activities objectAtIndex:indexPath.row];
    [cell setMerchandise:merchandise];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Merchandise *activity = [activities objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[ActivityDetailViewController alloc] initWithActivityMerchandise:activity] animated:YES];
}

@end