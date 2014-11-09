//
//  MyPointsRecordViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

static CGRect oldframe;

#import "MyPointsRecordViewController.h"
#import "PointsOrder.h"
#import "Account.h"
#import "PointsOrderService.h"
#import "DiskCacheManager.h"
#import "XXEventNameFilter.h"
#import "AccountInfoUpdatedEvent.h"
#import "Account.h"
#import "TaskLevelService.h"
#import "UpgradeTask.h"

NSString * const kLevelKey = @"levels.key";

@interface MyPointsRecordViewController ()

@end

@implementation MyPointsRecordViewController {

    NSMutableArray *pointsOrders;
    PullTableView *pointsOrderTableView;
    NSDateFormatter *dateFormatter;

    UIView *topView;
    UILabel *numberLabel;
    
    UIButton *addBtn;
    UIButton *reduceBtn;
    UIButton *UpgradeBtn;
    UIButton *levelBtn;
    UIImageView *levelbgImage;
    
    PointsOrderType pointsOrderType;
    NSInteger pageIndex;
    
    NSMutableArray *reducePointsOrders;
    NSMutableArray *additionPointsOrders;
    NSDate *reducePointsOrdersRefreshDate;
    NSDate *additionPointsOrdersRefreshDate;
}

- (void)showImage:(UIImageView *)avatarImageView {
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor clearColor];
    backgroundView.alpha=0;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=[UIImage imageNamed:@"levelbg"];
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UIImageView *levelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 501/2-30, 501/2-30)];
    levelImageView.image = image;
    [imageView addSubview:levelImageView];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(35,[UIScreen mainScreen].bounds.size.height == 568.f ? 159 : 115, 501/2 , 501/2);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap {
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-44, self.view.bounds.size.height/2+25)];
    topView.backgroundColor = [UIColor colorWithRed:28.0f / 255.0f green:33.0f / 255.0f blue:38.0f / 255.0f alpha:1.0f];
    
    [self.view addSubview:topView];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, topView.frame.size.height-50, topView.bounds.size.width/2, 50);
    addBtn.backgroundColor = [UIColor colorWithRed:44.0f / 255.0f green:55.0f / 255.0f blue:66.0f / 255.0f alpha:1.0f];
    [addBtn addTarget:self action:@selector(addPoints:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
    [addBtn setTitle:@"  收入" forState:UIControlStateNormal];
    
    reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(addBtn.bounds.size.width+1, topView.frame.size.height-50, self.view.frame.size.width/2, 50);
    reduceBtn.backgroundColor = [UIColor colorWithRed:44.0f / 255.0f green:55.0f / 255.0f blue:66.0f / 255.0f alpha:1.0f];
    [reduceBtn addTarget:self action:@selector(reducePoints:) forControlEvents:UIControlEventTouchUpInside];
    [reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [reduceBtn setTitle:@"  支出" forState:UIControlStateNormal];
    [topView addSubview:addBtn];
    [topView addSubview:reduceBtn];
    
    UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, (topView.bounds.size.height - addBtn.bounds.size.height)/2 - 55, 19, 16)];
    triangleImage.image = [UIImage imageNamed:@"triangle"];
//    [topView addSubview:triangleImage];

    levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    levelBtn.frame = CGRectMake(self.view.frame.size.width/2-115, (topView.bounds.size.height - addBtn.bounds.size.height)/2-80, 150, 57);
    [levelBtn addTarget:self action:@selector(actionLevelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:levelBtn];
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(-8, triangleImage.frame.origin.y + triangleImage.bounds.size.height+13, 250, 65)];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:58];
    numberLabel.text = @"0";
    [topView addSubview:numberLabel];
    
    UIImageView *mm = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-33 -44, (topView.bounds.size.height-addBtn.bounds.size.height)/2 + 20, 66, 66)];
    mm.image = [UIImage imageNamed:@"mm"];
    [topView addSubview:mm];
    
    UIImageView *levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(topView.bounds.size.width - 70, (topView.bounds.size.height - addBtn.bounds.size.height)/2 - 25, 50, 50)];
    levelImage.image = [UIImage imageNamed:@"levelbg"];
    
    levelbgImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 42, 42)];
    [levelImage addSubview:levelbgImage];
    [topView addSubview:levelImage];
    levelImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLevelImage:)];
    [levelImage addGestureRecognizer:tapGesture];
    
    pointsOrderType = PointsOrderTypeIncome;
    
    pointsOrderTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, topView.bounds.size.height, self.view.frame.size.width-44, self.view.bounds.size.height-topView.bounds.size.height) style:UITableViewStyleGrouped];
    pointsOrderTableView.delegate = self;
    pointsOrderTableView.dataSource = self;
    pointsOrderTableView.pullDelegate = self;
    pointsOrderTableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:pointsOrderTableView];
    
    [self refreshAccountInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh:YES];
    [self UsersUpgrade];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    XXEventNameFilter *nameFilter = [[XXEventNameFilter alloc] initWithSupportedEventNames:@[ kEventAccountInfoUpdated ]];
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:nameFilter];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

- (void)actionLevelBtnClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLevel = [defaults objectForKey:[Account currentAccount].accountId];
    NSInteger levels = 0;
    
    if (userLevel == nil) {
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//        [dictionary setInteger:levels forKey:kLevelKey];
//        [defaults setObject:dictionary forKey:[Account currentAccount].accountId];
//        [defaults synchronize];
        if ([Account currentAccount].level != 0) {
            levels = [Account currentAccount].level - 1;
        }
    }
    else{
        levels = [userLevel numberForKey:kLevelKey].integerValue;
//        levels = 3;
    }
    
    if (levels == [Account currentAccount].level) {
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 350) image:[UIImage imageNamed:@"images3"] message:@"哈尼,这一等级的题已经答过了哦!" buttonTitles:@[ @"确 认" ] cancelButtonIndex:0];
        [modal setCloseButtonHidden:YES];
        [modal showInView:[UIApplication sharedApplication].keyWindow completion:nil];
        return;
    }
    
    if (([Account currentAccount].level - levels) >= 2) {
        levels = [Account currentAccount].level - 1;
    }
    
    TaskLevelService *taskLevelService = [[TaskLevelService alloc]init];
    [taskLevelService getTasksLevelInfo:levels target:self success:@selector(getTaskLevelSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getTaskLevelSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200 && resp.body != nil) {
        NSDictionary *jsonD = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        UpgradeBtn.enabled = NO;
        if (jsonD != nil) {
            UpgradeTask *upgradeTask =[[UpgradeTask alloc]initWithJson:jsonD];
            UsersUpgradeModalView *upgrade = [[UsersUpgradeModalView alloc]initWithSize:CGSizeMake(500/2, 761/2) backgroundImage:[UIImage imageNamed:@"bg6"] titleMessage:@"恭喜哈尼升级了,么么哒!" message:@"恭喜哈尼答对了!"  upgradeTask:upgradeTask];
            upgrade.deletage = self;
            upgrade.shareType = ShareTypeUser;
            [upgrade showInView:[UIApplication sharedApplication].keyWindow completion:nil];
        }
    }
    else
    {
        [self handleFailureHttpResponse:resp];
    }
}

- (void)UsersUpgrade
{
    NSString *levelStr = nil;
    if ([Account currentAccount].level < 10) { //水星 0-9
        [levelBtn setImage:[UIImage imageNamed:@"shuixing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"水星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 20 && [Account currentAccount].level > 9) //火星 10-19
    {
        [levelBtn setImage:[UIImage imageNamed:@"huoxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"火星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 30) //金星
    {
        [levelBtn setImage:[UIImage imageNamed:@"jingxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"金星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 40) //地球
    {
        [levelBtn setImage:[UIImage imageNamed:@"diqiu"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"地球%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 50) //海王星
    {
        [levelBtn setImage:[UIImage imageNamed:@"haiwangxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"海王星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 60) //天王星
    {
        [levelBtn setImage:[UIImage imageNamed:@"tianwangxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"天王星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 70) //土星
    {
        [levelBtn setImage:[UIImage imageNamed:@"tuxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"土星%d级",[Account currentAccount].level + 1];
    }
    else if ([Account currentAccount].level < 80) //木星
    {
        [levelBtn setImage:[UIImage imageNamed:@"muxing"] forState:UIControlStateNormal];
        levelStr = [NSString stringWithFormat:@"木星%d级",[Account currentAccount].level + 1];
    }
    [levelBtn setTitle:levelStr forState:UIControlStateNormal];
}

#pragma mark - ShareDeletage
- (void)showShare
{
    [self dismissViewControllerAnimated:YES completion:^{
//        BaseViewController *baseVC = [ViewControllerAccessor defaultAccessor].homeViewController;
        BaseViewController *baseVC = [ViewControllerAccessor defaultAccessor].homePageViewController;

        if (baseVC != nil) {
//            [baseVC showShareTitle:@"升级新生活，尽在有米得" text:@"哈尼棒棒哒~升级任务神马的都不在话下哦！" imageName:@"icon80"];
            [baseVC showShareTitle:@"升级新生活，尽在有米得" text:@"哈尼棒棒哒~升级任务神马的都不在话下哦！" imageName:@"icon80" imageUrl:nil contentUrl:nil];

        }
    }];
}

#pragma mark -
#pragma mark XX event sub && pub

- (NSString *)xxEventSubscriberIdentifier {
    return @"pointsOrdersSubscriber";
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[AccountInfoUpdatedEvent class]]) {
        [self refreshAccountInfo];
    }
}

-(void)setLevelImage:(NSInteger)level
{
    levelbgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d",level+1]];
}

- (void)setPoints:(NSString*)numberStr {
    numberLabel.text = numberStr;
}

- (void)showLevelImage:(id)sender {
    [self showImage:levelbgImage];//调用方法
}

- (void)refresh:(BOOL)animated {
    if(animated) {
//        pointsOrderTableView.pullTableIsRefreshing = YES;
        BOOL isExpired;
        NSArray *pointsArray = [[DiskCacheManager manager] pointsOrdersWithPointsOrderType:pointsOrderType isExpired:&isExpired];
        if (pointsArray != nil) {
            pointsOrders = [NSMutableArray arrayWithArray:pointsArray];
            [pointsOrderTableView reloadData];
            [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:0.5f];
        }
    
        if (isExpired || pointsArray == nil) {
            [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5f];
        }
    }
}

- (void)refresh {
    pageIndex = 0;
    PointsOrderService *service = [[PointsOrderService alloc] init];
    [service getPointsOrdersByPageIndex:pageIndex orderType:pointsOrderType target:self success:@selector(getPointsOrdersSuccess:) failure:@selector(getPointsOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex], @"orderType" : [NSNumber numberWithInt:pointsOrderType]}];
}

- (void)refreshAccountInfo {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userLevel = [defaults objectForKey:[Account currentAccount].accountId];
//    NSInteger levels = [userLevel numberForKey:kLevelKey].integerValue;//获得缓存的等级

    [self setPoints:[NSString stringWithFormat:@"%d",  [Account currentAccount].points]];
    [self setLevelImage:[Account currentAccount].level];
}

- (void)loadMore {
    PointsOrderService *service = [[PointsOrderService alloc] init];
    [service getPointsOrdersByPageIndex:pageIndex + 1 orderType:pointsOrderType target:self success:@selector(getPointsOrdersSuccess:) failure:@selector(getPointsOrdersFailure:) userInfo:@{@"page" : [NSNumber numberWithInteger:pageIndex  + 1], @"orderType" : [NSNumber numberWithInt:pointsOrderType]}];
}

- (void)getPointsOrdersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        
        NSInteger page = ((NSNumber *)[resp.userInfo objectForKey:@"page"]).integerValue;
        NSInteger oType = ((NSNumber *)[resp.userInfo objectForKey:@"orderType"]).integerValue;
        
        if(oType != pointsOrderType) return;
        
        if(pointsOrders == nil) {
            pointsOrders = [NSMutableArray array];
        } else {
            if(page == 0) {
                [pointsOrders removeAllObjects];
            }
        }
        
        NSArray *results = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSUInteger lastIndex = pointsOrders.count;
        if(results != nil) {
            for(int i=0; i<results.count; i++) {
                PointsOrder *order = [[PointsOrder alloc] initWithJson:[results objectAtIndex:i]];
                [pointsOrders addObject:order];
                if(page > 0) {
                    [indexPaths addObject:[NSIndexPath indexPathForItem:lastIndex + i inSection:0]];
                }
            }
        }
       
        if(page > 0) {
            if(results != nil && results.count > 0) {
                pageIndex++;
                [pointsOrderTableView beginUpdates];
                [pointsOrderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [pointsOrderTableView endUpdates];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            pointsOrderTableView.pullLastRefreshDate = [NSDate date];
            [pointsOrderTableView reloadData];
        }
        
        [self cancelRefresh];
        [self cancelLoadMore];
        
        if(page == 0) {
            if(PointsOrderTypePay == pointsOrderType) {
                reducePointsOrders = [NSMutableArray arrayWithArray:pointsOrders];
                reducePointsOrdersRefreshDate = pointsOrderTableView.pullLastRefreshDate;
            } else {
                additionPointsOrders = [NSMutableArray arrayWithArray:pointsOrders];
                additionPointsOrdersRefreshDate = pointsOrderTableView.pullLastRefreshDate;
            }
            [[DiskCacheManager manager]setPointsOrders:pointsOrders pointsOrderType:pointsOrderType];

        }
        
        return;
    }
    
    [self getPointsOrdersFailure:resp];
}

-(void)addPoints:(id)sender
{
    if (pointsOrderType == PointsOrderTypeIncome) return;
    
    pointsOrderType = PointsOrderTypeIncome;
    [addBtn setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
    [reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    
    pointsOrderTableView.pullLastRefreshDate = additionPointsOrdersRefreshDate;
    pointsOrders = [NSMutableArray arrayWithArray:additionPointsOrders];

    [pointsOrderTableView reloadData];
    if(pointsOrderTableView.pullLastRefreshDate == nil) {
        [self refresh:YES];
    }
}

-(void)reducePoints:(id)sender
{
//    [self rightDismissViewControllerAnimated:YES];
    if (pointsOrderType == PointsOrderTypePay) return;
    
    pointsOrderType = PointsOrderTypePay;
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [reduceBtn setImage:[UIImage imageNamed:@"reduce2"] forState:UIControlStateNormal];
    
    pointsOrderType = PointsOrderTypePay;
    pointsOrderTableView.pullLastRefreshDate = reducePointsOrdersRefreshDate;
    pointsOrders = [NSMutableArray arrayWithArray:reducePointsOrders];

    [pointsOrderTableView reloadData];
    if(pointsOrderTableView.pullLastRefreshDate == nil) {
        [self refresh:YES];
    }
}

- (void)getPointsOrdersFailure:(HttpResponse *)resp {
    if(resp.statusCode == 403) {
        [pointsOrders removeAllObjects];
        [pointsOrderTableView reloadData];
    }
    [self cancelRefresh];
    [self cancelLoadMore];
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}


#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (pointsOrders == nil || pointsOrders.count == 0) ? 0 : 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pointsOrders == nil ? 0 : pointsOrders.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12.5f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd HH:mm";
    }
    PointsOrder *order = nil;

//    if (pointsOrderType == PointsOrderTypeIncome) {
        order = [pointsOrders objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"[%@] %d米米 %@",[dateFormatter stringFromDate:order.createTime],order.points,order.taskName];
//    }
//    else
//    {
//        order = [pointsOrders objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@使用%d积分",[dateFormatter stringFromDate:order.createTime],order.taskName,order.points];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark PullTableView delegate

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    if(pointsOrderTableView.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
}

-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if(pointsOrderTableView.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}
- (void)cancelRefresh {
    pointsOrderTableView.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    pointsOrderTableView.pullTableIsLoadingMore = NO;
}


@end
