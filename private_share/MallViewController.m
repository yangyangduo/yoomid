//
//  MallViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MallViewController.h"
#import "MerchandiseTableViewCell.h"
#import "MerchandiseService.h"
#import "MerchandiseDetailViewController2.h"
#import "DateTimeUtil.h"
#import "XiaojiRecommendTableViewCell.h"
#import "DiskCacheManager.h"
#import "ShoppingCartViewController2.h"

@interface MallViewController ()

@end

@implementation MallViewController {
    NSMutableArray *merchandises;
    NSMutableArray *recommendedMerchandises;
    NSInteger pageIndex;
    PullTableView *tblMerchandises;
    PullTableView *xiaoji;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"mall_view_title", @"");
    
    self.animationController.leftPanAnimationType = PanAnimationControllerTypeDismissal;
    self.navigationController.delegate = self;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ NSLocalizedString(@"chicked_recommend", @""), NSLocalizedString(@"all_merchandises", @"") ]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    CGRect frame = segmentedControl.frame;
    frame.size.width = 190;
    segmentedControl.frame = frame;
    self.navigationItem.titleView = segmentedControl;
    
    UIView *xiaojiHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    xiaojiHeaderView.backgroundColor = [UIColor clearColor];
    xiaoji = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    xiaoji.delegate = self;
    xiaoji.dataSource = self;
    xiaoji.pullDelegate = self;
    xiaoji.tag = 0;
    xiaoji.separatorStyle = NO;
    xiaoji.backgroundColor = [UIColor clearColor];
    xiaoji.tableHeaderView = xiaojiHeaderView;
    [self.view addSubview:xiaoji];
    xiaoji.pullTableIsRefreshing = NO;
    
    UIView *merchandisesHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 15)];
    merchandisesHeaderView.backgroundColor = [UIColor clearColor];
    tblMerchandises = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tblMerchandises.delegate = self;
    tblMerchandises.dataSource = self;
    tblMerchandises.pullDelegate = self;
    tblMerchandises.backgroundColor = [UIColor clearColor];
    tblMerchandises.tag = 1;
    [tblMerchandises setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblMerchandises.tableHeaderView = merchandisesHeaderView;
    [self.view addSubview:tblMerchandises];
    [tblMerchandises setHidden:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self.navigationController pushViewController:[[ShoppingCartViewController2 alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self mayRefresh];
    [self xiaojiRefresh];
}

-(void)xiaojiRefresh
{
    BOOL isExpired;
    NSArray *_recommendedMerchandises_ = [[DiskCacheManager manager] recommendedMerchandises:&isExpired];
    if (_recommendedMerchandises_ != nil) {
        recommendedMerchandises = [NSMutableArray arrayWithArray:_recommendedMerchandises_];
        [xiaoji reloadData];
    }
    
    if (isExpired || _recommendedMerchandises_ == nil) {
        [self performSelector:@selector(refreshXiaoji) withObject:nil afterDelay:0.5f];
    }
}

-(void)refreshXiaoji
{
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getEcommendedMerchandisesTarget:self success:@selector(getEcommendedMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:)];
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
        
        xiaoji.pullLastRefreshDate = [NSDate date];
        [xiaoji reloadData];
        
        [[DiskCacheManager manager] setRecommendedMerchandises:recommendedMerchandises];
        [self cancelRefresh];
        [self cancelLoadMore];
        return;
    }
    [self getMerchandisesfailure:resp];
}

- (void)mayRefresh {
    pageIndex = 0;
    
    BOOL isExpired;
    NSArray *_merchandises_ = [[DiskCacheManager manager] merchandises:&isExpired];
    if(_merchandises_ != nil) {
        merchandises = [NSMutableArray arrayWithArray:_merchandises_];
        [tblMerchandises reloadData];
    }
    
    if(isExpired || _merchandises_ == nil) {
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5f];
    }
}

- (void)refresh {
    pageIndex = 0;
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getHentreStoreMerchandisesByPageIndex:pageIndex target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:) userInfo:[NSNumber numberWithInteger:pageIndex]];
}

- (void)loadMore {
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getHentreStoreMerchandisesByPageIndex:pageIndex + 1 target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:) userInfo:[NSNumber numberWithInteger:pageIndex + 1]];
}

- (void)getMerchandisesSuccess:(HttpResponse *)resp {
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
                [tblMerchandises beginUpdates];
                [tblMerchandises insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [tblMerchandises endUpdates];
            } else {
                [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"no_more", @"") forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
        } else {
            tblMerchandises.pullLastRefreshDate = [NSDate date];
            [tblMerchandises reloadData];
            
            // if page index is 0, need save to disk cache
            [[DiskCacheManager manager] setMerchandises:merchandises];
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
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0)
    {
        [tblMerchandises setHidden:YES];
        [xiaoji setHidden:NO];
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        [tblMerchandises setHidden:NO];
        [xiaoji setHidden:YES];
    }
    else{}
}

- (void)actionGoodBtn:(UIButton *)sender
{
    UIView * v=[sender superview];
    XiaojiRecommendTableViewCell *cell=(XiaojiRecommendTableViewCell *)[v superview];//找到cell
    NSIndexPath *indexPath=[xiaoji indexPathForCell:cell];//找到cell所在的行
    //
    Merchandise *merchand = [recommendedMerchandises objectAtIndex:indexPath.row];
    NSString *merchandisesStr = merchand.identifier ;
    
    //从本地缓存中取出已点赞的商品id
    NSMutableArray *merchandisesIds = nil;
    NSArray *cacheData = [DiskCacheManager manager].merchandisesIds;
    if (cacheData == nil) {
        merchandisesIds = [NSMutableArray array];
    }
    else{
        merchandisesIds = [NSMutableArray arrayWithArray:cacheData];
    }
    
    if (merchandisesIds.count == 0) {
        MerchandiseService *service = [[MerchandiseService alloc]init];
        [service sendGoodWithMerchandiseId:merchandisesStr target:self success:@selector(sendGoodSuccess:) failure:@selector(handleFailureHttpResponse:) userInfo:nil];
        [merchandisesIds addObject:merchandisesStr];
        [[DiskCacheManager manager] setMerchandisesIds:merchandisesIds];
    }
    else{
        BOOL isZan = NO;
        for (int i = 0; i<merchandisesIds.count; i++) {
            NSString *merchandisesIdStr = [merchandisesIds objectAtIndex:i];
            if ([merchandisesStr isEqualToString:merchandisesIdStr]) {
                isZan = YES;
                break;
            }
        }
        
        if (isZan) {
            [[XXAlertView currentAlertView] setMessage:@"您已经赞过该商品了" forType:AlertViewTypeSuccess];
            [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }else{
            //.....没赞过
            MerchandiseService *service = [[MerchandiseService alloc]init];
            [service sendGoodWithMerchandiseId:merchandisesStr target:self success:@selector(sendGoodSuccess:) failure:@selector(handleFailureHttpResponse:) userInfo:nil];
            [merchandisesIds addObject:merchandisesStr];
            [[DiskCacheManager manager] setMerchandisesIds:merchandisesIds];
        }
    }
}

- (void)sendGoodSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200) {
//        NSLog(@"赞成功");
//        NSNumber *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
//        NSInteger number = jsonArray.integerValue;
        [self refreshXiaoji];
    }
}


#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger counts = 0;
    if (tableView.tag == 0) {
        counts = recommendedMerchandises == nil ? 0 : recommendedMerchandises.count;
    }
    else
    {
        counts = merchandises == nil ? 0 : merchandises.count;
    }
    return counts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    id idcell = nil;
    if (tableView.tag == 0) {
        XiaojiRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[XiaojiRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goodBtn.frame = CGRectMake(20, 10, 51/2, 51/2);
            [goodBtn setImage:[UIImage imageNamed:@"good3"] forState:UIControlStateNormal];
            [goodBtn addTarget:self action:@selector(actionGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:goodBtn];

        }
        cell.merchandise = [recommendedMerchandises objectAtIndex:indexPath.row];
        idcell = cell;
    }
    else
    {
        MerchandiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[MerchandiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.merchandise = [merchandises objectAtIndex:indexPath.row];
        idcell = cell;
    }
    return idcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0.f;
    if (tableView.tag == 0) {
        cellHeight = 410;
    }
    else
    {
        cellHeight = kMerchandiseTableViewCellHeight;
    }

    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Merchandise *merchandise = (tableView.tag == 0 ? [recommendedMerchandises objectAtIndex:indexPath.row] : [merchandises objectAtIndex:indexPath.row]);
    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
    [self rightPresentViewController:merchandiseDetailViewController animated:YES];
}


#pragma mark -
#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if (pullTableView.tag == 0) {
        if (xiaoji.pullTableIsLoadingMore) {
            [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
            return;
        }
        [self performSelector:@selector(refreshXiaoji) withObject:nil afterDelay:0.3f];
    }
    else if (pullTableView.tag == 1) {
        if(tblMerchandises.pullTableIsLoadingMore) {
            [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
            return;
        }
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if (pullTableView.tag == 0) {
        [self cancelLoadMore];
        [self cancelRefresh];
        return;
    } else if (pullTableView.tag == 1) {
        if(tblMerchandises.pullTableIsRefreshing) {
            [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
            return;
        }
        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
    }
}

- (void)cancelRefresh {
    tblMerchandises.pullTableIsRefreshing = NO;
    xiaoji.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblMerchandises.pullTableIsLoadingMore = NO;
    xiaoji.pullTableIsLoadingMore = NO;
}

#pragma mark -
#pragma mark UINavigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:[MerchandiseDetailViewController2 class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
       [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
