//
//  AllMerchandiseMallViewController.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AllMerchandiseMallViewController.h"
#import "MerchandiseService.h"
#import "MerchandiseTableViewCell.h"

@implementation AllMerchandiseMallViewController
{
    NSMutableArray *merchandises;
    NSInteger pageIndex;
    PullTableView *tblMerchandises;

}

@synthesize column;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    self.title = column.names;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];

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

}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)refresh {
    pageIndex = 0;
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandisesWithShopId:column.cid pageIndex:pageIndex target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:)  userInfo:[NSNumber numberWithInteger:pageIndex]];
}

- (void)loadMore {
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service getMerchandisesWithShopId:column.cid pageIndex:pageIndex + 1 target:self success:@selector(getMerchandisesSuccess:) failure:@selector(getMerchandisesfailure:)  userInfo:[NSNumber numberWithInteger:pageIndex + 1]];
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
//            [[DiskCacheManager manager] setMerchandises:merchandises];
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

#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  merchandises == nil ? 0 : merchandises.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    MerchandiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[MerchandiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.merchandise = [merchandises objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return kMerchandiseTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Pull Table View Delegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(tblMerchandises.pullTableIsLoadingMore) {
        [self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.3f];
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(tblMerchandises.pullTableIsRefreshing) {
        [self performSelector:@selector(cancelLoadMore) withObject:nil afterDelay:1.5f];
        return;
    }
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3f];
}

- (void)cancelRefresh {
    tblMerchandises.pullTableIsRefreshing = NO;
}

- (void)cancelLoadMore {
    tblMerchandises.pullTableIsLoadingMore = NO;
}

@end
