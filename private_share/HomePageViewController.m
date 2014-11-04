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
//#import "XiaoJiRecommendMallViewController.h"
#import "ActivitiesService.h"
#import "ActivityDetailViewController.h"
#import "HomePageTemplateService.h"
#import "RowView.h"
#import "ColumnView.h"
#import "NewHomePageItemCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
//#import "AllMerchandiseMallViewController.h"
#import "XiaoJiRecommendTemplateViewController.h"
#import "MerchandiseTemplateTwoViewController.h"
#import "MerchandiseTemplateOneViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    UICollectionView *_collectionView;
    
    ActiveDisplayScrollView *activeDisplaySV;
    XiaoJiRecommendView *xiaoJiView;
    
    NSString *_cell_identifier_;
    NSMutableArray *recommendedMerchandises;
    NSMutableArray *_activities_;
    NSMutableArray *_rowView_;

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
    [_collectionView registerClass:[NewHomePageItemCell class] forCellWithReuseIdentifier:_cell_identifier_];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.view addSubview:_collectionView];

    CGFloat viewHeight = 170;//_xiaojiView height = 170   商品图片1：1
    xiaoJiView = [[XiaoJiRecommendView alloc] initWithFrame:CGRectMake(0, -viewHeight, self.view.bounds.size.width, viewHeight)];
    xiaoJiView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [xiaoJiView addGestureRecognizer:tapGesture];
    [_collectionView insertSubview:xiaoJiView atIndex:0];
    
    viewHeight += 190;//activeDisplaySV height = 180;间距 ＝ 10

    activeDisplaySV = [[ActiveDisplayScrollView alloc] initWithFrame:CGRectMake(0, -viewHeight, self.view.bounds.size.width, 180.f)];
    activeDisplaySV.delegate = self;
    [_collectionView insertSubview:activeDisplaySV atIndex:0];
    _collectionView.contentInset = UIEdgeInsetsMake(viewHeight-20, 0, 0, 0);

    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 10 : 0), 55, 55)];
    [settingButton setImage:[UIImage imageNamed:@"setup5"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];

    
    UIButton *miRepositoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 10 : 0), 55, 55)];
    [miRepositoryButton setImage:[UIImage imageNamed:@"like5"] forState:UIControlStateNormal];
    [miRepositoryButton addTarget:self action:@selector(showMiRepository:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:miRepositoryButton];
    
    [self getMerchandisesTemplate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getEcommendedMerchandisesForDiskCache];
    [self mayRefreshActivities];
//    [self refreshMerchandisesTemplate];
}

- (void)refreshMerchandisesTemplate{
    BOOL isExpired;
    NSArray *merchandisesTemplate = [[DiskCacheManager manager] merchandisesTemplate:&isExpired];
    if (merchandisesTemplate != nil) {
        _rowView_ = [NSMutableArray arrayWithArray:merchandisesTemplate];
        [_collectionView reloadData];
    }
    
    if (isExpired || merchandisesTemplate == nil) {
        [self getMerchandisesTemplate];
    }
}

- (void)getMerchandisesTemplate
{
    HomePageTemplateService *service = [[HomePageTemplateService alloc] init];
    [service getHomePageTemlateTarget:self success:@selector(getMerchandisesTemplateSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getMerchandisesTemplateSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200 && resp.body != nil)
    {
        if (_rowView_ == nil) {
            _rowView_ = [[NSMutableArray alloc] init];
        } else {
            [_rowView_ removeAllObjects];
        }
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        for (int i = 0; i<jsonArray.count; i++) {
            NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
            RowView *rowView = [[RowView alloc] initWithJson:jsonObject];
//            NSLog(@"%@",jsonObject);
            [_rowView_ addObject:rowView];
        }
        
        [_collectionView reloadData];
//        [[DiskCacheManager manager] setMerchandisesTemplate:_rowView_];
        return;
    }{
        [self handleFailureHttpResponse:resp];
    }
}

//轮播活动
- (void)mayRefreshActivities {
    BOOL isExpired;
    NSArray *activities = [[DiskCacheManager manager] activities:&isExpired];
    if (activities != nil) {
        _activities_ = [NSMutableArray arrayWithArray:activities];
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for (int i = 0; i<activities.count; i++) {
            Merchandise *merchandise = [activities objectAtIndex:i];
            ImageItem *item = [[ImageItem alloc] initWithUrl:[merchandise.imageUrls objectAtIndex:0] title:nil];
            [images addObject:item];
        }
        activeDisplaySV.imageItems = images;
    }
    if (isExpired || activities == nil) {
        [self getActivitiesInfo];
    }
}

#pragma mark -
#pragma mark Request activities

- (void)getActivitiesInfo {
    ActivitiesService *activitiesService = [[ActivitiesService alloc]init];
    [activitiesService getActivitiesInfo:self success:@selector(getActivitiesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getActivitiesSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200 && resp.body != nil) {
        if (_activities_ == nil) {
            _activities_ = [[NSMutableArray alloc] init];
        } else {
            [_activities_ removeAllObjects];
        }
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSMutableArray *imagearray = [[NSMutableArray alloc]init];
        if (jsonArray != nil) {
            for (int i = 0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                Merchandise *merchandise = [[Merchandise alloc]initWithJson:jsonObject];
                ImageItem *item = [[ImageItem alloc] initWithUrl:[merchandise.imageUrls objectAtIndex:0] title:nil];
                [imagearray addObject:item];
                [_activities_ addObject:merchandise];
            }
        }
        activeDisplaySV.imageItems = imagearray;
        [[DiskCacheManager manager] setActivities:_activities_];
        return;
    } else {
        [self handleFailureHttpResponse:resp];
    }
}



//小吉推荐商品
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
//    Merchandise *merchandise = [recommendedMerchandises objectAtIndex:index];
//    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
//    [self rightPresentViewController:merchandiseDetailViewController animated:YES];
//    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self didClickMoreXiaoJiRecommend];
}


- (void)didClickMoreXiaoJiRecommend
{
    XiaoJiRecommendTemplateViewController *xiaojiTemplate = [[XiaoJiRecommendTemplateViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:xiaojiTemplate];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];

}

#pragma mark - ActiveDisplayScrollView delegate
- (void)activeDisplayScrollView:(ActiveDisplayScrollView *)activeDisplayScrollView didTapOnPageIndex:(NSUInteger)pageIndex
{
#ifdef DEBUG
    NSLog(@"点击了第%d个页面",pageIndex);
#endif
    if(_activities_ != nil && _activities_.count > pageIndex) {
        ActivityDetailViewController *merchandiseDetailViewController = [[ActivityDetailViewController alloc] initWithActivityMerchandise:[_activities_ objectAtIndex:pageIndex]];
        [self rightPresentViewController:merchandiseDetailViewController animated:YES];
    }
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _rowView_.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RowView *row = [_rowView_ objectAtIndex:section];
    return row.sizes;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewHomePageItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cell_identifier_ forIndexPath:indexPath];
    RowView *row = [_rowView_ objectAtIndex:indexPath.section];
    ColumnView *column = [row.columnViews objectAtIndex:indexPath.row];
    
//    NSString *strUrl = [column.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];

    if (column != nil && column.imgUrl != nil) {
        [cell.bg_image setImageWithURL:[NSURL URLWithString:[column.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:DEFAULT_IMAGES];
//        [cell.bg_image setImageWithURLRequest:request placeholderImage:DEFAULT_IMAGES success:nil failure:nil];
//        [cell.bg_image setImageWithURL:[NSURL URLWithString:column.imgUrl]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RowView *row = [_rowView_ objectAtIndex:indexPath.section];
    ColumnView *column = [row.columnViews objectAtIndex:indexPath.row];
    
    if (column == nil) {
        return;
    }
    
    //类别 1为活动,2为店铺
    if (column.types == 1) { //活动

    }else if (column.types == 2){ //店铺
        //视图类别 1,2,3,4  ，
        
        id merchandiseTemplate = nil;
        if (column.viewType == 1) { //1是原全部商品列表样式
//            AllMerchandiseMallViewController *allMall = [[AllMerchandiseMallViewController alloc] init];
//            allMall.column = column;
            
            MerchandiseTemplateTwoViewController *merchandiseTemplateTwoVC = [[MerchandiseTemplateTwoViewController alloc] init];
            merchandiseTemplateTwoVC.column = column;
            merchandiseTemplate = merchandiseTemplateTwoVC;
        }else if (column.viewType == 2){ //2是原小吉推荐商品列表样式
            MerchandiseTemplateOneViewController *merchandiseTemplateOneVC = [[MerchandiseTemplateOneViewController alloc] init];
            merchandiseTemplateOneVC.column = column;
            merchandiseTemplate = merchandiseTemplateOneVC;
        }else if (column.viewType == 3){
            
        }else{}
        
        if (merchandiseTemplate != nil) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:merchandiseTemplate];
            [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
            [self rightPresentViewController:navigationController animated:YES];
        }
    }
}

//大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size ;
    CGFloat viewWidth;
    RowView *row = [_rowView_ objectAtIndex:indexPath.section];
    
    if (row.sizes == 1) {//一行只有一个元素  一个section 16:9
        size = CGSizeMake(self.view.bounds.size.width, 180);
    }else if (row.sizes == 2) {
        viewWidth = (self.view.bounds.size.width-5)/2;
        size =  CGSizeMake(viewWidth, viewWidth);
    }else if (row.sizes == 3){
        viewWidth = (self.view.bounds.size.width-10)/3;
        size =  CGSizeMake(viewWidth, viewWidth);
    }else if (row.sizes == 4){
        viewWidth = (self.view.bounds.size.width-15)/4;
        size =  CGSizeMake(viewWidth, viewWidth);
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

//- (UIViewController *)leftPresentationViewController {
//    MallViewController *mallViewController = [[MallViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mallViewController];
//    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
//    return navigationController;
//}

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
