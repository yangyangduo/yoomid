//
//  MerchandiseTemplateThreeViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "MerchandiseTemplateThreeViewController.h"
#import "MerchandiseTemplateThreeCell.h"
#import "MerchandiseService.h"
#import "MerchandiseDetailViewController2.h"

@interface MerchandiseTemplateThreeViewController ()

@end

@implementation MerchandiseTemplateThreeViewController
{
    PullCollectionView *_collectionView;
    NSString *_cell_identifier_;
    NSInteger pageIndex;
    NSMutableArray *merchandises;
}

@synthesize column;

- (void)viewDidLoad {
    [super viewDidLoad];
    _cell_identifier_ = @"cellIdentifier";

    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    self.title = column.names;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[PullCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MerchandiseTemplateThreeCell class] forCellWithReuseIdentifier:_cell_identifier_];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pullDelegate = self;

    [self.view addSubview:_collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}


- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)refresh {
    pageIndex = 0;
    [[XXAlertView currentAlertView] setPostBearMessage:@"加载中..."];

    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandisesWithShopId:column.cid pageIndex:pageIndex target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:)  userInfo:[NSNumber numberWithInteger:pageIndex]];
}

- (void)loadMore {
    [[XXAlertView currentAlertView] setPostBearMessage:@"加载中..."];

    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandisesWithShopId:column.cid pageIndex:pageIndex + 1 target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:)  userInfo:[NSNumber numberWithInteger:pageIndex + 1]];
}

- (void)getMerchandisesSuccess:(HttpResponse *)resp {
    [[XXAlertView currentAlertView] dismissAlertView];

    if(resp.statusCode == 200) {
        NSInteger page = ((NSNumber *)resp.userInfo).integerValue;
        if(merchandises == nil) {
            merchandises = [NSMutableArray array];
        } else {
            if(page == 0) {
                [merchandises removeAllObjects];
            }
        }
    
        NSMutableArray *indexPaths = [NSMutableArray array];

        NSUInteger lastIndex = merchandises.count;
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [merchandises addObject:[[Merchandise alloc] initWithJson:jsonObject]];
                if(page > 0) {
                    
                    [indexPaths addObject:[NSIndexPath indexPathForRow:lastIndex + i inSection:0]];

                }
            }
        }
        
        if(page > 0) {
            if(jsonArray != nil && jsonArray.count > 0) {
                pageIndex++;
                [_collectionView insertItemsAtIndexPaths:indexPaths];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            _collectionView.pullLastRefreshDate = [NSDate date];
            [_collectionView reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        return;
    }
    
    [self getMerchandisesfailure:resp];
}

- (void)getMerchandisesfailure:(HttpResponse *)resp {
    [self cancelRefresh];
    [self cancelLoadMore];
    
    [self handleFailureHttpResponse:resp];
}


#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return merchandises == nil ? 0 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  merchandises == nil ? 0 : merchandises.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MerchandiseTemplateThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cell_identifier_ forIndexPath:indexPath];
    cell.merchandise = [merchandises objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Merchandise *merchandise = [merchandises objectAtIndex:indexPath.row];
    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
    [self rightPresentViewController:merchandiseDetailViewController animated:YES];

}

//大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size ;
    CGFloat viewheight = self.view.bounds.size.width/2;
    size = CGSizeMake(viewheight, viewheight);
    return size;
}

//section行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//section列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(5, 5, 0, 0);
//}


#pragma mark -
#pragma mark Pull collection view delegate

- (void)pullTableViewDidTriggerRefresh:(PullCollectionView *)pullTableView {
    if(_collectionView.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.01f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullCollectionView *)pullTableView {
    if(_collectionView.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.01f];
}

- (void)cancelRefresh {
    _collectionView.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    _collectionView.pullTableIsLoadingMore = NO;
}


@end
