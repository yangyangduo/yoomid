//
//  ExperienceTasksViewController.m
//  private_share
//
//  Created by Zhao yang on 6/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ExperienceTasksViewController.h"

//#import "DMOfferWallManager.h"
#import "SecurityConfig.h"
#import "Constants.h"
//#import <immobSDK/immobView.h>

@implementation ExperienceTasksViewController {
    UITableView *taskTableView;
    
//    DMOfferWallManager *domobOfferWall;
//    immobView *limeiAdWall;
}

//adwo error list
static NSString* const errCodeList[] = {
    @"successful",
    @"offer wall is disabled",
    @"login connection failed",
    @"offer wall has not been loginned",
    @"offer wall is not initialized",
    @"offer wall has been loginned",
    @"unknown error",
    @"invalid event flag",
    @"app list request failed",
    @"app list response failed",
    @"app list parameter malformatted",
    @"app list is being requested",
    @"offer wall is not ready for show",
    @"keywords malformatted",
    @"current device has not enough space to save resource",
    @"resource malformatted",
    @"resource load failed",
    @"you are have already loginned",
    @"exceed max show count",
    @"exceed max login count",
    @"you have not enough points",
    @"points consumption is not available",
    @"point is negative number",
    @"receive point is error",
    @"network request error"
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体验类任务";
    
    taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    [self.view addSubview:taskTableView];
    
    //init dianru
//    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
//    if(indexPath.row == 0) {
//        cell.textLabel.text = NSLocalizedString(@"youmi", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    } else if(indexPath.row == 1) {
//        cell.textLabel.text = NSLocalizedString(@"domob", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_domob"];
//    } else if(indexPath.row == 2) {
//        cell.textLabel.text = NSLocalizedString(@"cocounion", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    } else if(indexPath.row == 3) {
//        cell.textLabel.text = NSLocalizedString(@"dianru", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    }else if(indexPath.row == 4) {
//        cell.textLabel.text = NSLocalizedString(@"limei", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    }else if(indexPath.row == 5) {
//        cell.textLabel.text = NSLocalizedString(@"adwo", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    }else if(indexPath.row == 6) {
//        cell.textLabel.text = NSLocalizedString(@"miidi", @"");
//        cell.imageView.image = [UIImage imageNamed:@"icon_experience"];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row == 0) {
//        [YouMiWall showOffers:YES didShowBlock:^{
//        } didDismissBlock:^{
//        }];
//    } else if(indexPath.row == 1) {
//        if(domobOfferWall == nil) {
//            domobOfferWall = [[DMOfferWallManager alloc] initWithPublisherID:kDomobSecretKey andUserID:[SecurityConfig defaultConfig].userName];
//            domobOfferWall.disableStoreKit = YES;
//        }
//        [domobOfferWall presentOfferWallWithType:eDMOfferWallTypeList];
//    }
//    else if(indexPath.row == 2) {
//        [[PBOfferWall sharedOfferWall] loadOfferWall:[PBADRequest request]];
//        [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
//    } else if(indexPath.row == 3) {
//        [DianRuAdWall showAdWall:self];
//    } else if(indexPath.row == 4) {
//        if(limeiAdWall == nil){
//            limeiAdWall=[[immobView alloc] initWithAdUnitId:kLimeiAppKey adUnitType:offerWall rootViewController:self userInfo:nil];
//            [limeiAdWall.UserAttribute setObject:[SecurityConfig defaultConfig].userName forKey:accountname];
//        }
//        [limeiAdWall immobViewRequest];
//        [self.parentViewController.view addSubview:limeiAdWall];
//    } else if(indexPath.row == 5){
//        //set keywords to be the username
//        NSArray *arr = [NSArray arrayWithObjects:[SecurityConfig defaultConfig].userName, nil];
//        AdwoOWSetKeywords(arr);
//        
//        // 初始化并登录积分墙
//        BOOL result = AdwoOWPresentOfferWall(kAdwoAppKey, self);
//        if(!result)
//        {
//            enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
//            NSLog(@"Initialization error, because %@", errCodeList[errCode]);
//        }
//        else{
//            NSLog(@"Initialization successfully!");
//        }
//    } else if(indexPath.row == 6){
//        [MiidiAdWall showAppOffers:self withDelegate:nil];
//    }
    
    /* disable yjf
     YJFIntegralWall *integralWall = [[YJFIntegralWall alloc]init]; if([integralWall isScoreShow]){
     //    integralWall.delegate = self;
     [self presentViewController:integralWall animated:YES completion:nil];
     }
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

//dianru application key
-(NSString *)applicationKey {
    return kDianruAppKey;
}

//dianru required user id
-(NSString *)dianruAdWallAppUserId {
    return [SecurityConfig defaultConfig].userName;
}

- (void)didReceiveGetScoreResult:(int)point {
}

- (void)didReceiveSpendScoreResult:(BOOL)isSuccess {
}

@end
