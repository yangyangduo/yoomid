//
//  HomePageViewController.m
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "HomePageViewController.h"
#import "MyPointsRecordViewController.h"
#import "ShoppingCartViewController2.h"
#import "SettingViewController.h"
#import "UINavigationViewInitializer.h"
#import "DiskCacheManager.h"
#import "MerchandiseService.h"
#import "MallViewController.h"
#import "XiaoJiRecommendMallViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    UICollectionView *_collectionView;
    
    ActiveDisplayScrollView *activeDisplaySV;
    XiaoJiRecommendView *xiaoJiView;
    
    NSString *_cell_identifier_;
    NSMutableArray *recommendedMerchandises;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cell_identifier_ = @"cellIdentifier";
    
    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypePresentation;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);//设置其边界
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height ) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cell_identifier_];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.view addSubview:_collectionView];

    CGFloat viewHeight = 180;//_xiaojiView height = 170   商品图片1：1
    xiaoJiView = [[XiaoJiRecommendView alloc] initWithFrame:CGRectMake(0, -viewHeight, self.view.bounds.size.width, viewHeight)];
    xiaoJiView.delegate = self;
    [_collectionView insertSubview:xiaoJiView atIndex:0];
    
    viewHeight += 190;//activeDisplaySV height = 180;间距 ＝ 10

    activeDisplaySV = [[ActiveDisplayScrollView alloc] initWithFrame:CGRectMake(0, -viewHeight, self.view.bounds.size.width, 180.f)];
    activeDisplaySV.delegate = self;
    [_collectionView insertSubview:activeDisplaySV atIndex:0];
    _collectionView.contentInset = UIEdgeInsetsMake(viewHeight-20, 0, 0, 0);
    
    UIImage *image1 = [UIImage imageNamed:@"11"];
    UIImage *image2 = [UIImage imageNamed:@"12"];

    activeDisplaySV.imageItems = [[NSArray alloc] initWithObjects:image1,image2, nil];

    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 10 : 0), 55, 55)];
    [settingButton setImage:[UIImage imageNamed:@"setup5"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];

    
    UIButton *miRepositoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 10 : 0), 55, 55)];
    [miRepositoryButton setImage:[UIImage imageNamed:@"like5"] forState:UIControlStateNormal];
    [miRepositoryButton addTarget:self action:@selector(showMiRepository:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:miRepositoryButton];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getEcommendedMerchandisesForDiskCache];
}

- (void)getEcommendedMerchandisesForDiskCache{
    BOOL isExpired;
    NSArray *_recommendedMerchandises_ = [[DiskCacheManager manager] recommendedMerchandises:&isExpired];
    if (_recommendedMerchandises_ != nil) {
        recommendedMerchandises = [NSMutableArray arrayWithArray:_recommendedMerchandises_];
        xiaoJiView.recommendedMerchandises = recommendedMerchandises;
    }
    
    if (isExpired || _recommendedMerchandises_ == nil) {
        [self performSelector:@selector(getEcommendedMerchandises) withObject:nil afterDelay:0.5f];
    }
}

-(void)getEcommendedMerchandises
{
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getEcommendedMerchandisesTarget:self success:@selector(getEcommendedMerchandisesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getEcommendedMerchandisesSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200) {
        if (recommendedMerchandises == nil) {
            recommendedMerchandises = [[NSMutableArray alloc] init];
        }
        else
        {
            [recommendedMerchandises removeAllObjects];
        }
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if (jsonArray != nil) {
            for (int i = 0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [recommendedMerchandises addObject:[[Merchandise alloc] initWithJson:jsonObject]];
            }
        }
        
        [[DiskCacheManager manager] setRecommendedMerchandises:recommendedMerchandises];
        xiaoJiView.recommendedMerchandises = recommendedMerchandises;
        return;
    }
    [self handleFailureHttpResponse:resp];
}


#pragma mark -
#pragma mark Show view controllers

- (void)showSettings:(id)sender {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];
}

-(void)showMiRepository:(id)sender {
    ShoppingCartViewController2 *shoppingCartVC = [[ShoppingCartViewController2 alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];
}

#pragma mark - XiaoJiRecommendView Delegate
- (void)didClickXiaoJiMerchandise:(NSInteger)index
{
    Merchandise *merchandise = [recommendedMerchandises objectAtIndex:index];
    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
    [self rightPresentViewController:merchandiseDetailViewController animated:YES];
    
}

- (void)didClickMoreXiaoJiRecommend
{
    XiaoJiRecommendMallViewController *xiaojiMall = [[XiaoJiRecommendMallViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:xiaojiMall];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];

}

#pragma mark - ImageScrollView delegate
- (void)activeDisplayScrollView:(ActiveDisplayScrollView *)activeDisplayScrollView didTapOnPageIndex:(NSUInteger)pageIndex
{
#ifdef DEBUG
    NSLog(@"点击了第%d个页面",pageIndex);
#endif
    
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else
        return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cell_identifier_ forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    indexPath.section
    CGSize size ;
    if (indexPath.section == 0) {
        size =  CGSizeMake(self.view.bounds.size.width/2-2.5, 140);
    }else if (indexPath.section == 1){
        size = CGSizeMake(self.view.bounds.size.width, 200);
    }
    return size;
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


#pragma mark -
#pragma mark Animation controller delegate

- (UIViewController *)leftPresentationViewController {
    MallViewController *mallViewController = [[MallViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mallViewController];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    return navigationController;
}


- (UIViewController *)rightPresentationViewController {
    return [[MyPointsRecordViewController alloc] init];
}

- (CGFloat)rightPresentViewControllerOffset {
    return 88.f;
}

#pragma mark -
#pragma mark Navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:[HomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}


@end
