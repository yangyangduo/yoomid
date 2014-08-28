//
//  HomePageViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "HomePageViewController.h"
#import "CustomCollectionView.h"
#import "MyPointsRecordViewController.h"
#import "UINavigationViewInitializer.h"
#import "MallViewController.h"
#import "UIDevice+ScreenSize.h"
#import "ShoppingCartViewController2.h"
#import "UIImage+Color.h"
#import "TaskDetailViewController.h"
#import "NSMutableDictionary+Extension.h"
#import "NSDictionary+Extension.h"

NSString * const homePageCell = @"homePageCell";
NSString * const fileName = @"categories4.plist";

@interface HomePageViewController ()

@end


@implementation HomePageViewController
{
    PullScrollZoomImagesView *pullImagesView;
    UIScrollView *scrollview;
    UIPageControl *pageControl;
    
    CustomCollectionView *_collectionView;
    
    UIButton *notificationsButton;
    UIButton *repoButton;
}

@synthesize allCategories = _allCategories_;
@synthesize rootCategories = _rootCategories;

+ (NSString *)CategoriesInfoDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypePresentation;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[CustomCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[HomePageItemCell class] forCellWithReuseIdentifier:homePageCell];
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
    
    notificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [notificationsButton setImage:[UIImage imageNamed:@"information2"] forState:UIControlStateNormal];
    [notificationsButton addTarget:self action:@selector(actionNotifiBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:notificationsButton];
 
    repoButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [repoButton setImage:[UIImage imageNamed:@"miku"] forState:UIControlStateNormal];
    [repoButton addTarget:self action:@selector(showMiRepository:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repoButton];
    
    [self createCategoriesInfoFileIfNotExists];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSError *error;
    
    NSString *filePath = [[[self class] CategoriesInfoDirectory] stringByAppendingPathComponent:fileName];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if(error != nil) return;
    
    NSMutableArray *categoriesInfo = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (categoriesInfo == nil) {
        [self getCategoriesInfo];
    } else {
        self.allCategories = categoriesInfo;
        [_collectionView reloadData];
        NSDate *fileModificationDate = [fileAttributes objectForKey:NSFileModificationDate];
        if (abs(fileModificationDate.timeIntervalSinceNow) / 60 > 30) {
            [self getCategoriesInfo];
        }
    }
}

-(void)createCategoriesInfoFileIfNotExists {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
    }
}

-(void)saveCategoriesInfoToDisk {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:fileName];
    [self.allCategories writeToFile:plistPath atomically:YES];
}

-(void)getCategoriesInfo {
    TaskCategoriesService *taskCategories = [[TaskCategoriesService alloc]init];
    [taskCategories getCategories:self success:@selector(getCategoriesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)getCategoriesSuccess:(HttpResponse *)resp
{
    if (resp.statusCode == 200) {
        NSString *result = [[NSString alloc]initWithData:resp.body encoding:NSUTF8StringEncoding];
        result = [result stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
        NSData *bodyData = [result dataUsingEncoding:NSUTF8StringEncoding];
        self.allCategories = [JsonUtil createDictionaryOrArrayFromJsonData:bodyData];
        [self saveCategoriesInfoToDisk];
        [_collectionView reloadData];
    } else {
        [self handleFailureHttpResponse:resp];
    }
}

-(void)actionNotifiBtn:(id)sender {
}

-(void)showMiRepository:(id)sender {
    ShoppingCartViewController2 *shoppingCartVC = [[ShoppingCartViewController2 alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    navigationController.transitioningDelegate = self;
    
    self.animationController.animationType = PanAnimationControllerTypePresentation;
    
    [self.navigationController presentViewController:navigationController animated:YES completion:^{ }];
}

-(void)actionChangePage:(id)sender {
    pullImagesView.pageIndex = pageControl.currentPage;
    [[pullImagesView scrollView] setContentOffset:CGPointMake(pullImagesView.bounds.size.width*pageControl.currentPage, 0)];
}

#pragma mark - 
#pragma mark UICollectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rootCategories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:homePageCell forIndexPath:indexPath];
    NSDictionary *tempD = [self.rootCategories objectAtIndex:indexPath.row];
    cell.title_lable.text = [tempD objectForKey:@"displayName"];
    cell.context.text = [tempD objectForKey:@"description"];
    NSString *strID = [tempD objectForKey:@"id"];
    if ([strID isEqualToString:@"y:i:gu"]) {
        cell.bg_image.image = [UIImage imageNamed:@"ktct"];
    }else if([strID isEqualToString:@"y:i:sc"])
    {
        cell.bg_image.image = [UIImage imageNamed:@"fxhy"];
    }
    else if([strID isEqualToString:@"y:e:ap"])
    {
        cell.bg_image.image = [UIImage imageNamed:@"tyzx"];
    }else if([strID isEqualToString:@"y:i:sv"])
    {
        cell.bg_image.image = [UIImage imageNamed:@"wjdc"];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
    NSDictionary *rootCategory = [self.rootCategories objectAtIndex:indexPath.row];
    NSString *rootCategoryId = [rootCategory stringForKey:@"id"];
    NSMutableArray *secondaryCategories = [[NSMutableArray alloc]init];
    
    BOOL rootCategoryExists = NO;
    for (NSDictionary *category in self.allCategories) {
        NSString *str = [category objectForKey:@"parentCategory"];
        if ([rootCategoryId isEqualToString:str]) {
            [secondaryCategories addObject:category];
            rootCategoryExists = YES;
        }
    }
    
    if (rootCategoryExists) {
        
    } else {
        TaskDetailViewController *taskVC = [[TaskDetailViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:taskVC];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        
        navigationController.transitioningDelegate = self;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;
        self.animationController.panDirection = PanDirectionLeft;
        self.animationController.animationType = PanAnimationControllerTypePresentation;
        self.animationController.ignoreOffset = YES;
        
        [self.navigationController presentViewController:navigationController animated:YES completion:^{ }];
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
    for (NSDictionary *category in _allCategories_) {
        if(![category booleanForKey:@"parent"]) {
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
#pragma mark Animation controller

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
