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
#import "ShoppingCartViewController.h"
#import "DateTimeUtil.h"
#import "XiaojiRecommendTableViewCell.h"
#import "DiskCacheManager.h"

@interface MallViewController ()

@end

@implementation MallViewController {
    NSMutableArray *merchandises;
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
    
    xiaoji = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    xiaoji.delegate = self;
    xiaoji.dataSource = self;
    xiaoji.pullDelegate = self;
    xiaoji.tag = 0;
    xiaoji.separatorStyle = NO;
    xiaoji.backgroundColor = [UIColor clearColor];
    [self.view addSubview:xiaoji];
//    xiaoji.pullTableIsRefreshing = YES;
    
    tblMerchandises = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tblMerchandises.delegate = self;
    tblMerchandises.dataSource = self;
    tblMerchandises.pullDelegate = self;
    tblMerchandises.backgroundColor = [UIColor clearColor];
    tblMerchandises.tag = 1;
    [tblMerchandises setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tblMerchandises];
//    tblMerchandises.pullTableIsRefreshing = YES;
    [tblMerchandises setHidden:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self.navigationController pushViewController:[[ShoppingCartViewController alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self mayRefresh];
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
    NSLog(@"changed to %ld", (long)sender.selectedSegmentIndex);
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

#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger counts = 0;
    if (tableView.tag == 0) {
        counts = 3;
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
        }
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
        cellHeight = [UIDevice is4InchDevice] ? 410 : 335;
    }
    else
    {
        cellHeight = kMerchandiseTableViewCellHeight;
    }

    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        
    }
    else
    {
        MerchandiseDetailViewController2 *controller = [[MerchandiseDetailViewController2 alloc] initWithMerchandise:[merchandises objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:controller animated:YES];
    }
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
