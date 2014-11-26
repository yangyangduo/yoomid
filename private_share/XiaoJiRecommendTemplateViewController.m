//
//  XiaoJiRecommendTemplateViewController.m
//  private_share
//
//  Created by 曹大为 on 14/11/1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaoJiRecommendTemplateViewController.h"
#import "DiskCacheManager.h"
#import "MerchandiseService.h"
#import "MerchandiseDetailViewController2.h"

@implementation XiaoJiRecommendTemplateViewController
{
    NSMutableArray *recommendedMerchandises;
    PullRefreshTableView *tblXiaoJi;
    
    NSInteger _index;
}

- (instancetype)initWithIndex:(NSInteger)index Merchandise:(NSMutableArray *)merchandise
{
    self = [super init];
    if (self) {
        _index = index;
        recommendedMerchandises = [[NSMutableArray alloc] initWithArray:merchandise];
        [self merchandiseSort];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    self.title = @"小吉推荐";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    
    UIView *xiaojiHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    xiaojiHeaderView.backgroundColor = [UIColor clearColor];
    tblXiaoJi = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tblXiaoJi.delegate = self;
    tblXiaoJi.dataSource = self;
    tblXiaoJi.pullDelegate = self;
    tblXiaoJi.separatorStyle = NO;
    tblXiaoJi.backgroundColor = [UIColor clearColor];
    [tblXiaoJi setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblXiaoJi.tableHeaderView = xiaojiHeaderView;
    [self.view addSubview:tblXiaoJi];
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

//商品排序
- (void)merchandiseSort
{
    if (recommendedMerchandises.count > 0) {
        if (_index != 0 && _index < recommendedMerchandises.count) {
            Merchandise *_merchandise = [recommendedMerchandises objectAtIndex:_index];
            [recommendedMerchandises removeObjectAtIndex:_index];
            [recommendedMerchandises insertObject:_merchandise atIndex:0];
        }
    }
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self refreshXiaoji];
//}

//小吉推荐模式没有商铺id
-(void)refreshXiaoji
{
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getEcommendedMerchandisesTarget:self success:@selector(getEcommendedMerchandisesSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getEcommendedMerchandisesSuccess:(HttpResponse *)resp {
    [[XXAlertView currentAlertView] dismissAlertView];
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

        [self merchandiseSort];

        tblXiaoJi.pullLastRefreshDate = [NSDate date];
        [tblXiaoJi reloadData];
        
        [self cancelRefresh];
        return;
    }
    [self handleFailureHttpResponse:resp];
}

//点赞成功后，重新获取数据
- (void)actionClickGood:(NSString *)ids{
    [self refreshXiaoji];
}


#pragma mark -
#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recommendedMerchandises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XiaojiRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[XiaojiRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.merchandise = [recommendedMerchandises objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 410;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Merchandise *merchandise = [recommendedMerchandises objectAtIndex:indexPath.row];
    MerchandiseDetailViewController2 *merchandiseDetailViewController = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:merchandise];
    [self rightPresentViewController:merchandiseDetailViewController animated:YES];
    
}

#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView *)pullTableView {
    [[XXAlertView currentAlertView] setPostBearMessage:@"加载中..."];

    [self performSelector:@selector(refreshXiaoji) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    tblXiaoJi.pullTableIsRefreshing = NO;
}

@end
