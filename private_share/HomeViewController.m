//
//  HomePageViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "HomeViewController.h"
#import "MallViewController.h"
#import "MyPointsRecordViewController.h"
#import "ShoppingCartViewController2.h"
#import "SettingViewController.h"
#import "TaskListViewController.h"

#import "DiskCacheManager.h"
#import "UIImage+Color.h"
#import "UIDevice+ScreenSize.h"
#import "CustomCollectionView.h"
#import "UINavigationViewInitializer.h"

#import "AdwoOfferWall.h"
#import "YouMiWall.h"
#import "DMOfferWallManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    PullScrollZoomImagesView *pullImagesView;
    UIScrollView *scrollview;
    UIPageControl *pageControl;
    
    NSString *cellIdentifier;
    CustomCollectionView *_collectionView;

    ModalView *currentModalView;
}

@synthesize allCategories = _allCategories_;
@synthesize rootCategories = _rootCategories;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypePresentation;
    
    cellIdentifier = @"cellIdentifier";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[CustomCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[HomePageItemCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:_collectionView];
    
    pullImagesView = [[PullScrollZoomImagesView alloc]initAndEmbeddedInScrollView:_collectionView viewHeight:[UIDevice is4InchDevice] ? 330 : 280];
    pullImagesView.delegate = self;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, pullImagesView.bounds.size.height-20, 80, 30)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor appBlue];
    [pageControl addTarget:self action:@selector(actionChangePage:) forControlEvents:UIControlEventValueChanged];
    [pullImagesView addSubview:pageControl];
    
    NSString *url = @"http://pic15.nipic.com/20110716/2304422_180244650175_2.jpg";
    ImageItem *item = [[ImageItem alloc] initWithUrl:url title:nil];

    NSString *url1 = @"http://pic4.nipic.com/20091023/3103365_102101004770_2.jpg";
    ImageItem *item1 = [[ImageItem alloc] initWithUrl:url1 title:nil];

    NSString *url2 = @"http://yoomid.com/image/test/003.png";
    ImageItem *item2 = [[ImageItem alloc] initWithUrl:url2 title:nil];

    NSArray *imagearray = [[NSArray alloc]initWithObjects:item, item1, item2,nil];
    pullImagesView.imageItems = imagearray;
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];

    UIButton *notificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 95, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [notificationsButton setImage:[UIImage imageNamed:@"information2"] forState:UIControlStateNormal];
    [notificationsButton addTarget:self action:@selector(showNotifications:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notificationsButton];
 
    UIButton *miRepositoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [miRepositoryButton setImage:[UIImage imageNamed:@"miku"] forState:UIControlStateNormal];
    [miRepositoryButton addTarget:self action:@selector(showMiRepository:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:miRepositoryButton];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL isExpired;
    NSArray *categories = [[DiskCacheManager manager] taskCategories:&isExpired];
    if(categories != nil) {
        self.allCategories = [NSMutableArray arrayWithArray:categories];
        [_collectionView reloadData];
    }
    
    if(isExpired || categories == nil) {
        [self getCategoriesInfo];
    }
}

-(void)getCategoriesInfo {
    TaskCategoriesService *taskCategories = [[TaskCategoriesService alloc] init];
    [taskCategories getCategories:self success:@selector(getCategoriesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)getCategoriesSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200 && resp.body != nil) {
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSMutableArray *categories = [NSMutableArray array];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                [categories addObject:[[TaskCategory alloc] initWithJson:[jsonArray objectAtIndex:i]]];
            }
        }
        self.allCategories = categories;
        [[DiskCacheManager manager] setTaskCategories:self.allCategories];
        [_collectionView reloadData];
    } else {
        [self handleFailureHttpResponse:resp];
    }
}

- (void)actionChangePage:(id)sender {
    pullImagesView.pageIndex = pageControl.currentPage;
    [[pullImagesView scrollView] setContentOffset:CGPointMake(pullImagesView.bounds.size.width*pageControl.currentPage, 0)];
}


#pragma mark -
#pragma mark Show view controllers

-(void)showSettings:(id)sender {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];
}

-(void)showNotifications:(id)sender {

}

-(void)showMiRepository:(id)sender {
    ShoppingCartViewController2 *shoppingCartVC = [[ShoppingCartViewController2 alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self rightPresentViewController:navigationController animated:YES];
}

#pragma mark -
#pragma mark Category button item delegate

- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    if([@"domob" isEqualToString:identifier]) {
        DMOfferWallManager *domobOfferWall = [[DMOfferWallManager alloc] initWithPublisherID:kDomobSecretKey andUserID:[SecurityConfig defaultConfig].userName];
        domobOfferWall.disableStoreKit = YES;
        [domobOfferWall presentOfferWallWithType:eDMOfferWallTypeList];
    } else if([@"youmi" isEqualToString:identifier]) {
        [YouMiWall showOffers:YES didShowBlock:^{
        } didDismissBlock:^{
        }];
    } else if([@"anwo" isEqualToString:identifier]) {
        NSArray *arr = [NSArray arrayWithObjects:[SecurityConfig defaultConfig].userName, nil];
        AdwoOWSetKeywords(arr);
        BOOL result = AdwoOWPresentOfferWall(kAdwoAppKey, self);
        if(!result) {
            //enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
#ifdef DEBUG
            NSLog(@"[Home] Inital Adwo failure.");
#endif
        }
    }
    [currentModalView closeViewAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark Modal view delegate

- (void)modalViewDidClosed {
    [self.animationController enableGesture];
    currentModalView = nil;
}

#pragma mark - 
#pragma mark UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rootCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TaskCategory *taskCategory = [self.rootCategories objectAtIndex:indexPath.row];
    cell.title_lable.text = taskCategory.displayName;
    cell.context.text = taskCategory.description;
    
    NSString *iconName = taskCategory.iconName;
    if(iconName != nil && ![@"" isEqualToString:iconName]) {
        cell.bg_image.image = [UIImage imageNamed:iconName];
    } else {
        cell.bg_image.image = nil;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 58);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskCategory *rootCategory = [self.rootCategories objectAtIndex:indexPath.row];
    NSString *rootCategoryId = rootCategory.identifier;
    
    if(TaskCategoryTypeProductExperience == rootCategory.taskCategoryType) {
        AdPlatformPickerView *modalView = [[AdPlatformPickerView alloc] initWithSize:CGSizeMake(300, 415)];
        modalView.delegate = self;
        modalView.modalViewDelegate = self;
        currentModalView = modalView;
        [self.animationController disableGesture];
        [modalView showInView:self.view completion:^{  }];
        return;
    }
    
    NSMutableArray *secondaryCategories = [[NSMutableArray alloc]init];
    BOOL rootCategoryExists = NO;
    for (TaskCategory *category in self.allCategories) {
        if ([rootCategoryId isEqualToString:category.parentCategory]) {
            [secondaryCategories addObject:category];
            rootCategoryExists = YES;
        }
    }

    if(!rootCategoryExists) {
        TaskListViewController *taskListViewController = [[TaskListViewController alloc] initWithTaskCategory:rootCategory];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:taskListViewController];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        [self rightPresentViewController:navigationController animated:YES];
    } else {
#ifdef DEBUG
        NSLog(@"[Home] Can't supported child categories now");
#endif
    }
}

#pragma mark -
#pragma mark Getter and setters

- (NSMutableArray *)allCategories {
    if(_allCategories_ == nil) {
        _allCategories_ = [NSMutableArray array];
    }
    return _allCategories_;
}

- (NSMutableArray *)rootCategories {
    if(_rootCategories == nil) {
        _rootCategories = [NSMutableArray array];
    }
    return _rootCategories;
}

- (void)setAllCategories:(NSMutableArray *)allCategories {
    _allCategories_ = [NSMutableArray arrayWithArray:allCategories];
    [self.rootCategories removeAllObjects];
    if(_allCategories_ == nil) return;
    for (TaskCategory *category in _allCategories_) {
        if(!category.hasParent) {
            [self.rootCategories addObject:category];
        }
    }
}

#pragma mark -
#pragma mark Pull scroll images view delegate

-(void)pullScrollZoomImagesView:(PullScrollZoomImagesView *)pullScrollZoomImagesView imagesPageIndexChangedTo:(NSUInteger)newPageIndex {
    pageControl.currentPage = newPageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pullImagesView.scrollViewLocked = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullImagesView pullScrollViewDidScroll:scrollView];
    pageControl.frame = CGRectMake(pullImagesView.bounds.size.width/2-40, pullImagesView.bounds.size.height-30, 80, 30);

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        pullImagesView.scrollViewLocked = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pullImagesView.scrollViewLocked = NO;
}

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
    if([viewController isKindOfClass:[HomeViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end