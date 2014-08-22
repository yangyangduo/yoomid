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

NSString * const homePageCell = @"homePageCell";

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    PullScrollZoomImagesView *pullImagesView;
    UIScrollView *scrollview;
    
    UIPageControl *pageControl;
    
    CustomCollectionView *_collectionView;
    
    NSMutableArray *categoriesArray;
    NSMutableArray *parentCategoryArray;
    
    UIButton *notificationsButton;
    UIButton *repoButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        categoriesArray = [[NSMutableArray alloc]init];
        parentCategoryArray = [[NSMutableArray alloc]init];
        [self getCategoriesInfo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypePresentation;
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[CustomCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[HomePageItemCell class] forCellWithReuseIdentifier:homePageCell];
    [self.view addSubview:_collectionView];
    
    
    pullImagesView = [[PullScrollZoomImagesView alloc]initAndEmbeddedInScrollView:_collectionView viewHeight:[UIDevice is4InchDevice] ? 340 : 280];
    pullImagesView.delegate = self;
    
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, pullImagesView.bounds.size.height-20, 80, 30)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor appBlue];
    [pageControl addTarget:self action:@selector(actionChangePage:) forControlEvents:UIControlEventValueChanged];
    
    [pullImagesView addSubview:pageControl];
    
    UIImageView *topMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)];
    topMaskImageView.image = [UIImage imageNamed:@"black_top"];
    topMaskImageView.userInteractionEnabled = YES;
    [self.view addSubview:topMaskImageView];
    
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
    
    [self.view addSubview:notificationsButton];
 
    repoButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [repoButton setImage:[UIImage imageNamed:@"miku"] forState:UIControlStateNormal];
    [repoButton addTarget:self action:@selector(actionRepo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repoButton];
    
}

-(void)getCategoriesInfo
{
    TaskCategoriesService *taskCategories = [[TaskCategoriesService alloc]init];
    [taskCategories getCategories:self success:@selector(getCategoriesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

-(void)getCategoriesSuccess:(HttpResponse *)resp
{
    if (resp.statusCode == 200)
    {
        categoriesArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        for (NSDictionary *temDict in categoriesArray)
        {
            if ([[temDict objectForKey:@"parent"] boolValue] == false)
            {
                [parentCategoryArray addObject:temDict];
            }
        }
        [_collectionView reloadData];
    }else
    {
        [self handleFailureHttpResponse:resp];
    }
}

-(void)actionRepo:(id)sender
{
}

-(void)actionChangePage:(id)sender
{
    pullImagesView.pageIndex = pageControl.currentPage;
    [[pullImagesView scrollView] setContentOffset:CGPointMake(pullImagesView.bounds.size.width*pageControl.currentPage, 0)];
}

#pragma mark - 
#pragma mark UICollectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return parentCategoryArray.count>0 ? parentCategoryArray.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:homePageCell forIndexPath:indexPath];
    NSDictionary *tempD = [parentCategoryArray objectAtIndex:indexPath.row];
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
    return CGSizeMake(self.view.bounds.size.width, 70);
}//(self.view.bounds.size.height-pullImagesView.bounds.size.height)/4+1

//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tempD = [parentCategoryArray objectAtIndex:indexPath.row];
    NSString *strID = [tempD objectForKey:@"id"];
    NSMutableArray *subcategoryAarray = [[NSMutableArray alloc]init];
    BOOL b = NO;
    for (NSDictionary *Dtemp in categoriesArray)
    {
        NSString *str = [Dtemp objectForKey:@"parentCategory"];
        if ([strID isEqualToString:str])
        {
            [subcategoryAarray addObject:Dtemp];
            b = YES;
        }
    }
    
    if (b) {//push subcategory
        ;
    }
    else    //
    {
    
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

@end
