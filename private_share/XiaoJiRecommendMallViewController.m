//
//  XiaoJiRecommendMallViewController.m
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaoJiRecommendMallViewController.h"
#import "XiaojiRecommendTableViewCell.h"
#import "MerchandiseService.h"
#import "DiskCacheManager.h"

@interface XiaoJiRecommendMallViewController ()

@end

@implementation XiaoJiRecommendMallViewController
{
    PullTableView *tblXiaoJi;
}

@synthesize recommendedMerchandises = _recommendedMerchandises;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;

    self.title = @"小吉推荐";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    
    UIView *xiaojiHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    xiaojiHeaderView.backgroundColor = [UIColor clearColor];
    tblXiaoJi = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tblXiaoJi.delegate = self;
    tblXiaoJi.dataSource = self;
    tblXiaoJi.pullDelegate = self;
    tblXiaoJi.separatorStyle = NO;
    tblXiaoJi.backgroundColor = [UIColor clearColor];
    tblXiaoJi.tableHeaderView = xiaojiHeaderView;
    [self.view addSubview:tblXiaoJi];
    tblXiaoJi.pullTableIsLoadingMore = NO;
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshXiaoji];
}

-(void)refreshXiaoji
{
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getEcommendedMerchandisesTarget:self success:@selector(getEcommendedMerchandisesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getEcommendedMerchandisesSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200) {
        if (_recommendedMerchandises == nil) {
            _recommendedMerchandises = [[NSMutableArray alloc] init];
        }
        else
        {
            [_recommendedMerchandises removeAllObjects];
        }
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if (jsonArray != nil) {
            for (int i = 0; i<jsonArray.count; i++) {
                NSDictionary *jsonObject = [jsonArray objectAtIndex:i];
                [_recommendedMerchandises addObject:[[Merchandise alloc] initWithJson:jsonObject]];
            }
        }
        
        tblXiaoJi.pullLastRefreshDate = [NSDate date];
        [tblXiaoJi reloadData];
        
        [[DiskCacheManager manager] setRecommendedMerchandises:_recommendedMerchandises];
        [self cancelRefresh];
        [self cancelLoadMore];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

//点赞
- (void)actionGoodBtn:(UIButton *)sender
{
    UIView * v=[sender superview];
    XiaojiRecommendTableViewCell *cell=(XiaojiRecommendTableViewCell *)[v superview];//找到cell
    NSIndexPath *indexPath=[tblXiaoJi indexPathForCell:cell];//找到cell所在的行
    //
    Merchandise *merchand = [_recommendedMerchandises objectAtIndex:indexPath.row];
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
        [self refreshXiaoji];
    }
}


#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendedMerchandises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
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
    cell.merchandise = [_recommendedMerchandises objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 410;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Merchandise *merchandise = [_recommendedMerchandises objectAtIndex:indexPath.row];
    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
    [self rightPresentViewController:merchandiseDetailViewController animated:YES];

}

#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if (tblXiaoJi.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refreshXiaoji) withObject:nil afterDelay:0.3f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
//    [self cancelLoadMore];
//    [self cancelRefresh];
    return;
}

- (void)cancelRefresh {
    tblXiaoJi.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblXiaoJi.pullTableIsLoadingMore = NO;
}


@end
