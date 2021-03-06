#import "HomeViewController.h"
#import "MallViewController.h"
#import "MyPointsRecordViewController.h"
#import "ShoppingCartViewController2.h"
#import "SettingViewController.h"
#import "TaskListViewController.h"
#import "HomePageItemCell.h"
#import "NotificationsViewController.h"
#import "ActivitiesService.h"
#import "ActivityDetailViewController.h"

#import "TaskService.h"
#import "DiskCacheManager.h"
#import "UIImage+Color.h"
#import "UIDevice+ScreenSize.h"
#import "CustomCollectionView.h"
#import "UINavigationViewInitializer.h"
#import "UIDevice+ScreenSize.h"
#import "Account.h"

#import "CashPaymentTypePicker.h"
#import "YoomidRectModalView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    ImagesScrollView *imagesScrollView;
    UIScrollView *scrollview;
    UIPageControl *pageControl;
    
    NSString *cellIdentifier;
    CustomCollectionView *_collectionView;

    ModalView *currentModalView;
    
    NSMutableArray *_activities_;
}

@synthesize allCategories = _allCategories_;
@synthesize rootCategories = _rootCategories;

- (void)showGuidanceImage
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;

    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor=[UIColor blackColor];
//    backgroundView.alpha=0;
    [UIDevice is4InchDevice];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:backgroundView.frame];
    imageView.image=[UIImage imageNamed:[UIDevice is4InchDevice] ? @"daohang1" : @"daohang1_4"];
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
}

- (void)hideImage:(UITapGestureRecognizer*)tap {
//    static int i = 1;
    UIView *backgroundView=tap.view;

//    if (i == 2) {
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha=0;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
        }];
        [SecurityConfig defaultConfig].isFirstLogin = NO;
        [[SecurityConfig defaultConfig] saveConfig];
//    }
//    else
//    {
//        UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
//        imageView.image = [UIImage imageNamed:@"logo1136"];
//    }
//    i++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellIdentifier = @"cellIdentifier";

    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypePresentation;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[CustomCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[HomePageItemCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:_collectionView];
    
    CGFloat imagesViewHeight = self.view.bounds.size.width;
    imagesScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, -imagesViewHeight, self.view.bounds.size.width, imagesViewHeight)];
    imagesScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_image"]];
//    CGFloat viewHeight = self.view.bounds.size.width + (self.view.bounds.size.width/3);

    [_collectionView insertSubview:imagesScrollView atIndex:0];
    _collectionView.contentInset = UIEdgeInsetsMake(imagesViewHeight - 20, 0, 0, 0);
    _collectionView.contentOffset = CGPointMake(0, -imagesViewHeight);
    imagesScrollView.delegate = self;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, imagesScrollView.bounds.size.height-30, 80, 30)];
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor appBlue];
    [pageControl addTarget:self action:@selector(actionChangePage:) forControlEvents:UIControlEventValueChanged];
    [imagesScrollView addSubview:pageControl];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [settingButton setImage:[UIImage imageNamed:@"setup5"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];

    UIButton *notificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 95, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [notificationsButton setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [notificationsButton addTarget:self action:@selector(showNotifications:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:notificationsButton];
 
    UIButton *miRepositoryButton = [[UIButton alloc] initWithFrame:CGRectMake(5, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 5 : 0), 55, 55)];
    [miRepositoryButton setImage:[UIImage imageNamed:@"like5"] forState:UIControlStateNormal];
    [miRepositoryButton addTarget:self action:@selector(showMiRepository:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:miRepositoryButton];
    
}

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self mayRefreshActivities];
    [self mayRefreshTaskCategories];
    [[Account currentAccount] mayRefresh];
}

- (void)mayRefreshTaskCategories {
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
        imagesScrollView.imageItems = images;
    }
    if (isExpired || activities == nil) {
        [self getActivitiesInfo];
    }
    
    pageControl.numberOfPages = imagesScrollView.imageItems.count;
}

#pragma mark -
#pragma mark Request categories

- (void)getCategoriesInfo {
    TaskService *service = [[TaskService alloc] init];
    [service getCategories:self success:@selector(getCategoriesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getCategoriesSuccess:(HttpResponse *)resp {
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
        imagesScrollView.imageItems = imagearray;
        [[DiskCacheManager manager] setActivities:_activities_];
    } else {
        [self handleFailureHttpResponse:resp];
    }
}


#pragma mark -
#pragma mark Show view controllers

- (void)showSettings:(id)sender {
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        [self rightPresentViewController:navigationController animated:YES];
}

- (void)showNotifications:(id)sender {
    return;
    CashPaymentTypePicker *picker = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, 330)];
    [picker showInView:self.view completion:nil];
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
    [currentModalView closeViewAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark Modal view delegate

- (void)modalViewDidClosed:(ModalView *)modalView {
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
    cell.context.text = taskCategory.instruction;
    
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
    
    if(TaskCategoryTypeProductExperience == rootCategory.taskCategoryType) {//415
        AdPlatformPickerView *modalView = [[AdPlatformPickerView alloc] initWithSize:CGSizeMake(300, 320)];
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


- (void)actionChangePage:(id)sender {
    imagesScrollView.pageIndex = pageControl.currentPage;
    [[imagesScrollView scrollView] setContentOffset:CGPointMake(imagesScrollView.bounds.size.width*pageControl.currentPage, 0)];
}

#pragma mark -
#pragma mark Scroll images view delegate

- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView imagesPageIndexChangedTo:(NSUInteger)pageIndex {
    pageControl.currentPage = pageIndex;
}

-(void)imagesScrollView:(ImagesScrollView *)imagesScrollView didTapOnPageIndex:(NSUInteger)pageIndex {
    if(_activities_ != nil && _activities_.count > pageIndex) {
        ActivityDetailViewController *merchandiseDetailViewController = [[ActivityDetailViewController alloc] initWithActivityMerchandise:[_activities_ objectAtIndex:pageIndex]];
        [self rightPresentViewController:merchandiseDetailViewController animated:YES];
    }
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
